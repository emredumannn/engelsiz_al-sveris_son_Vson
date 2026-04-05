import 'package:engelsiz_alisveris/core/services/tts_service.dart';
import 'package:engelsiz_alisveris/data/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class DesktopScanningScreen extends StatefulWidget {
  const DesktopScanningScreen({super.key});

  @override
  State<DesktopScanningScreen> createState() => _DesktopScanningScreenState();
}

class _DesktopScanningScreenState extends State<DesktopScanningScreen> {
  final TtsService _ttsService = TtsService();
  final ProductService _productService = ProductService();
  String _scanResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Masaüstü/Web Tarayıcı")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ));
                  setState(() {
                    if (res is String) {
                      _scanResult = res;
                      _handleBarcodeDetected(res);
                    }
                  });
                },
                icon: const Icon(Icons.camera_alt, size: 30),
                label: const Text('Barkod Tara', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_scanResult.isNotEmpty)
              Text("Bulunan Barkod: $_scanResult", style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  void _handleBarcodeDetected(String barcodeValue) async {
    if (barcodeValue == '-1' || barcodeValue.isEmpty) return;
    
    print("Barkod bulundu: $barcodeValue");
    await _ttsService.speak("Barkod okundu.");

    try {
      final product = await _productService.getProductByBarcode(barcodeValue);
      if (product != null) {
        String speakText = "Ürün: ${product.name}. Fiyatı: ${product.price} TL.";
        await _ttsService.speak(speakText);
        setState(() {
           _scanResult = "$barcodeValue - ${product.name}";
        });
      } else {
        await _ttsService.speak("Ürün bulunamadı.");
      }
    } catch (e) {
      await _ttsService.speak("Bir hata oluştu.");
    }
  }
}
