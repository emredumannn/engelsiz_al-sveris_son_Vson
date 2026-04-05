import 'package:engelsiz_alisveris/core/providers/scanning_provider.dart';
import 'package:engelsiz_alisveris/core/providers/cart_provider.dart';
import 'package:engelsiz_alisveris/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:engelsiz_alisveris/core/theme/app_theme.dart';
import 'package:engelsiz_alisveris/views/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EngelsizApp());
}

class EngelsizApp extends StatelessWidget {
  const EngelsizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ScanningProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Engelsiz Alışveriş',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        showSemanticsDebugger: false,
        home: const LoginScreen(),
      ),
    );
  }
}
