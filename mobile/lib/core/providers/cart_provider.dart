import 'package:flutter/foundation.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../services/tts_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final TtsService _tts = TtsService();

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool containsProduct(int? productId) {
    return _items.any((item) => item.product.id == productId);
  }

  void addProduct(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
      _tts.speak('${product.name} sepete eklendi. Toplam ${_items[existingIndex].quantity} adet.');
    } else {
      _items.add(CartItem(product: product));
      _tts.speak('${product.name} sepete eklendi. Fiyatı ${product.price.toStringAsFixed(2)} lira.');
    }
    notifyListeners();
  }

  void removeProduct(int? productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final name = _items[index].product.name;
      _items.removeAt(index);
      _tts.speak('$name sepetten çıkarıldı.');
      notifyListeners();
    }
  }

  void incrementQuantity(int? productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
      _tts.speak('${_items[index].product.name}, ${_items[index].quantity} adet.');
      notifyListeners();
    }
  }

  void decrementQuantity(int? productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity <= 1) {
        removeProduct(productId);
      } else {
        _items[index] = _items[index].copyWith(quantity: _items[index].quantity - 1);
        _tts.speak('${_items[index].product.name}, ${_items[index].quantity} adet.');
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _items.clear();
    _tts.speak('Sepet temizlendi.');
    notifyListeners();
  }

  void speakCartSummary() {
    if (_items.isEmpty) {
      _tts.speak('Sepetiniz boş.');
      return;
    }
    String summary = 'Sepetinizde ${itemCount} ürün var. Toplam tutar: ${totalPrice.toStringAsFixed(2)} lira.';
    for (var item in _items) {
      summary += ' ${item.product.name}, ${item.quantity} adet, ${item.totalPrice.toStringAsFixed(2)} lira.';
    }
    _tts.speak(summary);
  }
}
