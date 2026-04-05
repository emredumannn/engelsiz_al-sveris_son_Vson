import 'dart:ui' as ui;
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      // Cihazın mevcut dilini al
      final systemLocale = ui.PlatformDispatcher.instance.locale;
      // tr_TR veya en_US formatında olabilir, TTS genelde tr-TR ister, tire ile birleştirelim
      String languageTag = "${systemLocale.languageCode}-${systemLocale.countryCode}";
      
      print("Sistem Dili: $languageTag");

      try {
        // Hangi dillerin desteklendiğini görelim
        var languages = await _flutterTts.getLanguages;
        print("Emülatörde Yüklü Diller: $languages");

        if (languages != null && languages.toString().contains("tr")) {
           await _flutterTts.setLanguage("tr-TR");
           print("Türkçe dili ayarlandı.");
        } else {
           print("UYARI: Emülatörde Türkçe dil paketi BULUNAMADI! İngilizce konuşabilir.");
           // Yine de şansımızı deneyelim
           await _flutterTts.setLanguage("tr-TR");
        }
      } catch (e) {
        print("Dil kontrolü hatası: $e");
      }

      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        print("TTS Hatası: $msg");
      });
    } catch (e) {
      print("TTS Başlatma Hatası: $e");
    }
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      print("TTS Konuşuyor: $text");
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  bool get isSpeaking => _isSpeaking;
}
