import 'package:flutter/material.dart';
import '../data/services/product_service.dart';
import '../data/models/product_model.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ProductService _productService = ProductService();
  String _statusMessage = 'Bağlantı test edilmeyi bekliyor...';
  List<Product> _products = [];
  bool _isLoading = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Sunucuya bağlanılıyor...';
    });

    try {
      final products = await _productService.getProducts();
      setState(() {
        _products = products;
        _statusMessage = 'Bağlantı Başarılı! ${products.length} ürün bulundu.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Hata: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engelsiz Alışveriş'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _statusMessage,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              child: _isLoading 
                ? const CircularProgressIndicator()
                : const Text('Sunucu Bağlantısını Test Et'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.price} TL'),
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                            ? Image.network(
                                product.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.shop); // Hata durumunda ikon
                                },
                              )
                            : const Icon(Icons.shopping_bag),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
