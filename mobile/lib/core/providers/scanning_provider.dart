import 'package:camera/camera.dart';
import 'package:engelsiz_alisveris/core/services/tts_service.dart';
import 'package:engelsiz_alisveris/data/models/product_model.dart';
import 'package:engelsiz_alisveris/data/services/product_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

class ScanningProvider extends ChangeNotifier {
  CameraController? _cameraController;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final TtsService _ttsService = TtsService();
  final ProductService _productService = ProductService();

  // Rotasyon hesaplaması için gerekli
  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _isFlashOn = false;
  Product? _lastScannedProduct;
  DateTime? _lastScanTime;
  String? _lastScannedBarcode;
  DateTime _lastTextScanTime = DateTime.now();
  String? _lastReadText;

  // Getters
  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isFlashOn => _isFlashOn;
  Product? get lastScannedProduct => _lastScannedProduct;

  ScanningProvider() {
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      _ttsService.speak("Kamera izni verilmedi.");
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      _ttsService.speak("Kamera bulunamadı.");
      return;
    }

    final firstCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(FlashMode.off);
      // Sürekli odaklama ve otomatik ışık ayarı (Kullanıcı hareket halindeyken netlik için)
      await _cameraController!.setFocusMode(FocusMode.auto);
      await _cameraController!.setExposureMode(ExposureMode.auto);
      
      _isCameraInitialized = true;
      notifyListeners();
      
      _ttsService.speak("Kamera hazır. Barkodu okutabilirsiniz.");
      _startImageStream();
    } catch (e) {
      print("Kamera hatası: $e");
      _ttsService.speak("Kamera başlatılamadı.");
    }
  }

  void _startImageStream() {
    _cameraController!.startImageStream((CameraImage image) {
      if (_isProcessing) return;
      _isProcessing = true;
      _processImage(image);
    });
  }

  Future<void> _processImage(CameraImage image) async {
    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _isProcessing = false;
        return;
      }

      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        final barcode = barcodes.first;
        if (barcode.rawValue != null) {
          _handleBarcodeDetected(barcode.rawValue!);
        }
      } else {
        // Barkod bulunamadıysa metin tara (Throttle: 1 saniye)
        if (DateTime.now().difference(_lastTextScanTime).inMilliseconds > 1000) {
          _lastTextScanTime = DateTime.now();
          await _processText(inputImage);
        }
      }
    } catch (e) {
      print("Tarama hatası: $e");
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _handleBarcodeDetected(String barcodeValue) async {
    final now = DateTime.now();
    if (_lastScannedBarcode == barcodeValue &&
        _lastScanTime != null &&
        now.difference(_lastScanTime!).inSeconds < 3) {
      return;
    }

    _lastScannedBarcode = barcodeValue;
    _lastScanTime = now;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 100);
    }

    _ttsService.speak("Barkod okundu.");
    await _fetchAndSpeakProductInfo(barcodeValue);
  }

  Future<void> _processText(InputImage inputImage) async {
    try {
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Basit filtreleme: İçinde sayı ve TL/Fiyat geçen satırları bul
      // Regex: Fiyat formatı (örn: 12.50, 12,50, 100 vb. ve yanında TL/Lira işareti veya kelimesi)
      // Bu çok basit bir regex, geliştirilebilir.
      
      String? bestMatch;
      
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text;
          // Örnek: "24.90 TL", "59,99", "Fiyat: 100"
          if (text.contains(RegExp(r'\d+[.,]?\d*\s*(TL|tl|Tl|₺|Lira)')) || 
              (text.contains(RegExp(r'Fiyat|FIYAT')) && text.contains(RegExp(r'\d+')))) {
            bestMatch = text;
            break; 
          }
        }
        if (bestMatch != null) break;
      }

      if (bestMatch != null && bestMatch != _lastReadText) {
        _lastReadText = bestMatch;
        _ttsService.speak("Etiket bulundu: $bestMatch");
        if (await Vibration.hasVibrator()) {
           Vibration.vibrate(duration: 50);
        }
      }

    } catch (e) {
      print("Metin okuma hatası: $e");
    }
  }

  Future<void> _fetchAndSpeakProductInfo(String barcode) async {
    try {
      final product = await _productService.getProductByBarcode(barcode);
      _lastScannedProduct = product;
      notifyListeners();

      if (product != null) {
        String speakText = "Ürün: ${product.name}. Fiyatı: ${product.price} TL.";
        _ttsService.speak(speakText);
      } else {
        _ttsService.speak("Ürün bulunamadı.");
      }
    } catch (e) {
      _ttsService.speak("Bir hata oluştu.");
    }
  }

  void toggleFlash() async {
    if (_cameraController != null && _isCameraInitialized) {
      _isFlashOn = !_isFlashOn;
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off
      );
      notifyListeners();
      _ttsService.speak(_isFlashOn ? "Flaş açıldı" : "Flaş kapandı");
    }
  }

  void replayLastProduct() {
      if (_lastScannedProduct != null) {
          String speakText = "Tekrar okunuyor: ${_lastScannedProduct!.name}. Fiyatı: ${_lastScannedProduct!.price} TL. ${_lastScannedProduct!.description ?? ''}";
          _ttsService.speak(speakText);
      } else {
          _ttsService.speak("Henüz bir ürün okunmadı.");
      }
  }

  // Helper method for InputImage conversion (Logic same as before but encapsulated)
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    
    // Rotasyon Hesaplama
    InputImageRotation? rotation;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      var rotationCompensation = _orientations[_cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // Ön kamera
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // Arka kamera
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // Format Hesaplama
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    
    // Sadece desteklenen formatları kabul et (Android için genellikle nv21 veya yuv_420_888)
    if (format == null || (format != InputImageFormat.nv21 && format != InputImageFormat.yuv420)) {
         // Fallback veya desteklenmeyen format durumunda null dönülebilir, 
         // ancak şimdilik `nv21` varsayıp devam etmeyi deneyebiliriz veya loglayabiliriz.
         // Çoğu durumda Android camera paketi yuv420 verir, MLKit bunu nv21 olarak işleyebilir 
         // eğer plane'ler doğru birleştirilirse.
    }

    // Byte birleştirme (Özellikle Android YUV420 -> NV21 dönüşümü gerekebilir ama
    // MLKit son sürümlerinde basic birleştirme ile bytesPerRow doğru verilirse çalışıyor)
    // Ancak en güvenli yöntem tüm plane'leri birleştirmektir.
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    // Android'de Row Stride önemli
    final plane = image.planes.first;

    final inputImageMetadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: format ?? InputImageFormat.nv21, // Varsayılan nv21
      bytesPerRow: plane.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _barcodeScanner.close();
    _textRecognizer.close();
    _ttsService.stop();
    super.dispose();
  }
}
