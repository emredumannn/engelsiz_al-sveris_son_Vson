import 'package:flutter/material.dart';

class AppTheme {
  // Yüksek Kontrast Renkler (Görme Engelli Dostu)
  static const Color primaryColor = Color(0xFF1565C0);     // Koyu Mavi
  static const Color accentColor = Color(0xFFFFD600);      // Parlak Sarı
  static const Color successColor = Color(0xFF2E7D32);     // Koyu Yeşil
  static const Color dangerColor = Color(0xFFC62828);      // Koyu Kırmızı
  static const Color backgroundDark = Color(0xFF0A0A0A);   // Neredeyse Siyah
  static const Color surfaceColor = Color(0xFF1A1A2E);     // Koyu Lacivert
  static const Color cardColor = Color(0xFF16213E);        // Koyu Kart

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColor,
      error: dangerColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundDark,

    // Büyük ve okunaklı yazı tipleri
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
      headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white, height: 1.5),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
      labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    ),

    // Büyük dokunma alanları (min 48x48 dp, biz 64+ yapıyoruz)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 64),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        side: const BorderSide(color: accentColor, width: 2),
        minimumSize: const Size(double.infinity, 64),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      toolbarHeight: 64,
    ),

    iconTheme: const IconThemeData(size: 32, color: Colors.white),

    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
  );
}
