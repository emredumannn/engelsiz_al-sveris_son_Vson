import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/cart_provider.dart';
import '../core/theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Consumer<CartProvider>(
          builder: (context, cart, _) => Text(
            'Sepetim (${cart.itemCount} ürün)',
          ),
        ),
        actions: [
          // Sepeti sesli oku
          Consumer<CartProvider>(
            builder: (context, cart, _) => Semantics(
              label: 'Sepet özetini sesli oku',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.volume_up, size: 32),
                onPressed: () => cart.speakCartSummary(),
                tooltip: 'Sepeti Sesli Oku',
              ),
            ),
          ),
          // Sepeti temizle
          Consumer<CartProvider>(
            builder: (context, cart, _) => cart.items.isEmpty
                ? const SizedBox()
                : Semantics(
                    label: 'Sepeti temizle',
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.delete_sweep, size: 32, color: Color(0xFFC62828)),
                      onPressed: () => _showClearCartDialog(context, cart),
                      tooltip: 'Sepeti Temizle',
                    ),
                  ),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Semantics(
                label: 'Sepetiniz boş. Ürün taramak için barkod tara sekmesine gidin.',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.white24),
                    const SizedBox(height: 24),
                    const Text(
                      'Sepetiniz Boş',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ürün eklemek için barkod tarayın',
                      style: TextStyle(fontSize: 18, color: Colors.white54),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Ürün Listesi
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Semantics(
                      label: '${item.product.name}, ${item.quantity} adet, ${item.totalPrice.toStringAsFixed(2)} lira',
                      child: Card(
                        color: AppTheme.cardColor,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Ürün Bilgisi
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.product.price.toStringAsFixed(2)} ₺ / adet',
                                      style: const TextStyle(color: Colors.white54, fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Toplam: ${item.totalPrice.toStringAsFixed(2)} ₺',
                                      style: const TextStyle(
                                        color: Color(0xFFFFD600),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Miktar Kontrolü
                              Column(
                                children: [
                                  Semantics(
                                    label: '${item.product.name} miktarını artır',
                                    button: true,
                                    child: _CircleButton(
                                      icon: Icons.add,
                                      color: const Color(0xFF2E7D32),
                                      onTap: () => cart.incrementQuantity(item.product.id),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Semantics(
                                    label: '${item.product.name} miktarını azalt',
                                    button: true,
                                    child: _CircleButton(
                                      icon: item.quantity <= 1 ? Icons.delete : Icons.remove,
                                      color: const Color(0xFFC62828),
                                      onTap: () => cart.decrementQuantity(item.product.id),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Alt Özet & Ödeme Butonu
              _CartSummaryBar(cart: cart),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Sepeti Temizle', style: TextStyle(color: Colors.white, fontSize: 20)),
        content: const Text(
          'Sepetteki tüm ürünler silinecek. Emin misiniz?',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal', style: TextStyle(color: Colors.white54, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828)),
            child: const Text('Temizle', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _CartSummaryBar extends StatelessWidget {
  final CartProvider cart;

  const _CartSummaryBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Özet Satırları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ürün Sayısı:', style: TextStyle(color: Colors.white70, fontSize: 16)),
              Text('${cart.itemCount} adet', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Toplam Tutar:', style: TextStyle(color: Colors.white70, fontSize: 18)),
              Text(
                '${cart.totalPrice.toStringAsFixed(2)} ₺',
                style: const TextStyle(color: Color(0xFFFFD600), fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Ödeme Butonu
          Semantics(
            label: 'Ödeme yap. Toplam: ${cart.totalPrice.toStringAsFixed(2)} lira',
            button: true,
            child: ElevatedButton.icon(
              onPressed: () => _showCheckoutDialog(context),
              icon: const Icon(Icons.payment, size: 28),
              label: const Text('Ödemeye Geç'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Ödeme', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFFFD600), size: 48),
            const SizedBox(height: 16),
            const Text(
              'Ödeme sistemi yakında aktif olacak.\n\nMağaza kasasına gidin ve ödemenizi tamamlayın.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Toplam: ${cart.totalPrice.toStringAsFixed(2)} ₺',
              style: const TextStyle(color: Color(0xFFFFD600), fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: const Text('Tamam', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
