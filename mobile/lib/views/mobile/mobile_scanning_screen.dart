import 'package:camera/camera.dart';
import 'package:engelsiz_alisveris/core/providers/scanning_provider.dart';
import 'package:engelsiz_alisveris/core/providers/cart_provider.dart';
import 'package:engelsiz_alisveris/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileScanningScreen extends StatelessWidget {
  const MobileScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Engelsiz Tarayıcı',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          // Flaş Butonu
          Consumer<ScanningProvider>(
            builder: (context, provider, child) {
              return Semantics(
                label: "El fenerini ${provider.isFlashOn ? 'kapat' : 'aç'}",
                button: true,
                child: IconButton(
                  icon: Icon(
                    provider.isFlashOn ? Icons.flash_on : Icons.flash_off,
                    size: 32,
                    color: provider.isFlashOn ? Colors.yellow : Colors.white54,
                  ),
                  onPressed: () => provider.toggleFlash(),
                  tooltip: provider.isFlashOn ? 'Flaşı Kapat' : 'Flaşı Aç',
                  padding: const EdgeInsets.all(12),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ScanningProvider>(
        builder: (context, provider, child) {
          if (!provider.isCameraInitialized || provider.cameraController == null) {
            return Center(
              child: Semantics(
                label: "Kamera başlatılıyor, lütfen bekleyin.",
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Color(0xFFFFD600)),
                    const SizedBox(height: 24),
                    const Text(
                      'Kamera hazırlanıyor...',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Kamera Önizlemesi
              Semantics(
                label: "Kamera görüntüsü. Barkodu okutmak için ürünü kameranın önüne getirin.",
                hint: "Barkod algılandığında titreşim ve sesli uyarı alacaksınız.",
                child: CameraPreview(provider.cameraController!),
              ),

              // 2. Koyu Üst Gradient (okunabilirlik için)
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    ),
                  ),
                ),
              ),

              // 3. Tarama Çerçevesi
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 280,
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFFD600), width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          // Köşe çizgileri
                          _buildCorner(Alignment.topLeft),
                          _buildCorner(Alignment.topRight),
                          _buildCorner(Alignment.bottomLeft),
                          _buildCorner(Alignment.bottomRight),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Barkodu çerçeve içine getirin',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Ürün Bilgi Paneli (Barkod okunduğunda)
              if (provider.lastScannedProduct != null)
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: _ProductInfoPanel(provider: provider),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    const size = 24.0;
    const thickness = 4.0;
    const color = Color(0xFFFFD600);

    bool isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    bool isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;

    return Positioned(
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CornerPainter(
            isTop: isTop,
            isLeft: isLeft,
            color: color,
            thickness: thickness,
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  final Color color;
  final double thickness;

  _CornerPainter({required this.isTop, required this.isLeft, required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (isTop && isLeft) {
      canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
      canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
    } else if (isTop && !isLeft) {
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
    } else if (!isTop && isLeft) {
      canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
    } else {
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProductInfoPanel extends StatelessWidget {
  final ScanningProvider provider;

  const _ProductInfoPanel({required this.provider});

  @override
  Widget build(BuildContext context) {
    final product = provider.lastScannedProduct!;

    return Semantics(
      container: true,
      label: 'Ürün bilgisi paneli. ${product.name}, ${product.price} lira.',
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Adı
            Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Fiyat
            Text(
              '${product.price.toStringAsFixed(2)} ₺',
              style: const TextStyle(
                color: Color(0xFFFFD600),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Açıklama
            if (product.description != null) ...[
              const SizedBox(height: 8),
              Text(
                product.description!,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 20),
            // Butonlar
            Row(
              children: [
                // Tekrar Oku
                Expanded(
                  child: Semantics(
                    label: 'Ürün bilgisini tekrar sesli oku',
                    button: true,
                    child: OutlinedButton.icon(
                      onPressed: () => provider.replayLastProduct(),
                      icon: const Icon(Icons.volume_up, size: 24),
                      label: const Text('Tekrar Oku'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Sepete Ekle / Sepetten Çıkar
                Expanded(
                  flex: 2,
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      final inCart = cartProvider.containsProduct(product.id);
                      return Semantics(
                        label: inCart ? '${product.name} sepetten çıkar' : '${product.name} sepete ekle',
                        button: true,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (inCart) {
                              cartProvider.removeProduct(product.id);
                            } else {
                              cartProvider.addProduct(product);
                            }
                          },
                          icon: Icon(inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart, size: 24),
                          label: Text(inCart ? 'Sepetten Çıkar' : 'Sepete Ekle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: inCart ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(0, 56),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
