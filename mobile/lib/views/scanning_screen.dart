import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/cart_provider.dart';
import 'mobile/mobile_scanning_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MobileScanningScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 12)],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: 'Barkod Tara sekmesi',
                      selected: _currentIndex == 0,
                      button: true,
                      child: InkWell(
                        onTap: () => setState(() => _currentIndex = 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                size: 36,
                                color: _currentIndex == 0 ? const Color(0xFFFFD600) : Colors.white54,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tara',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _currentIndex == 0 ? const Color(0xFFFFD600) : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Semantics(
                      label: 'Sepetim sekmesi. ${cart.itemCount} ürün var.',
                      selected: _currentIndex == 1,
                      button: true,
                      child: InkWell(
                        onTap: () => setState(() => _currentIndex = 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    Icons.shopping_cart,
                                    size: 36,
                                    color: _currentIndex == 1 ? const Color(0xFFFFD600) : Colors.white54,
                                  ),
                                  if (cart.itemCount > 0)
                                    Positioned(
                                      right: -8,
                                      top: -8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFC62828),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${cart.itemCount}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sepetim',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _currentIndex == 1 ? const Color(0xFFFFD600) : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Semantics(
                      label: 'Profil ve Ayarlar',
                      selected: _currentIndex == 2,
                      button: true,
                      child: InkWell(
                        onTap: () => setState(() => _currentIndex = 2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person,
                                size: 36,
                                color: _currentIndex == 2 ? const Color(0xFFFFD600) : Colors.white54,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Hesabım',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _currentIndex == 2 ? const Color(0xFFFFD600) : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
