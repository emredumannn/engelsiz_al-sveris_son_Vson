import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/theme/app_theme.dart';
import 'scanning_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      auth.login(_usernameController.text, _passwordController.text);
      // Başarılı girişten sonra ana ekrana geç
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ScanningScreen()),
      );
    } else {
      auth.login('', ''); // Hata mesajı okutmak için
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Semantics(
              label: 'Giriş Ekranı. Lütfen kullanıcı adı ve şifrenizi girin.',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.shopping_cart_checkout, size: 100, color: AppTheme.accentColor),
                  const SizedBox(height: 24),
                  const Text(
                    'Engelsiz Alışveriş',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 48),
                  
                  // Kullanıcı Adı
                  Semantics(
                    label: 'Kullanıcı Adı giriş alanı',
                    child: TextField(
                      controller: _usernameController,
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.surfaceColor,
                        labelText: 'Kullanıcı Adı',
                        labelStyle: const TextStyle(fontSize: 20, color: Colors.white70),
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16),
                           borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Şifre
                  Semantics(
                    label: 'Şifre giriş alanı',
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.surfaceColor,
                        labelText: 'Şifre',
                        labelStyle: const TextStyle(fontSize: 20, color: Colors.white70),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16),
                           borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Giriş Butonu
                  Semantics(
                    label: 'Giriş Yap Butonu',
                    button: true,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Giriş Yap', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
