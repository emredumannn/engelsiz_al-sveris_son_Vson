import 'package:flutter/foundation.dart';
import '../services/tts_service.dart';

class AuthProvider extends ChangeNotifier {
  final TtsService _tts = TtsService();
  bool _isLoggedIn = false;
  String _userName = '';
  final List<String> _allergens = []; // Başlangıçta boş veya default değerler konabilir

  // Alerjen listesi kütüphanesi
  final List<String> availableAllergens = [
    'Gluten',
    'Yer Fıstığı',
    'Süt Ürünleri',
    'Yumurta',
    'Soya'
  ];

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  List<String> get allergens => List.unmodifiable(_allergens);

  void login(String username, String password) {
    if (username.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _userName = username;
      _tts.speak("Giriş başarılı. Hoş geldin $userName.");
      notifyListeners();
    } else {
      _tts.speak("Lütfen kullanıcı adı ve şifre alanlarını doldurun.");
    }
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _tts.speak("Çıkış yapıldı.");
    notifyListeners();
  }

  void toggleAllergen(String allergen) {
    if (_allergens.contains(allergen)) {
      _allergens.remove(allergen);
      _tts.speak("$allergen uyarısı kaldırıldı.");
    } else {
      _allergens.add(allergen);
      _tts.speak("$allergen uyarısı eklendi.");
    }
    notifyListeners();
  }

  void triggerSOS() {
    _tts.speak("Acil yardım çağrısı başlatıldı. Mağaza görevlilerine konum bilgileriniz iletiliyor. Lütfen sıradaki yönlendirmeyi bekleyin.");
  }
}
