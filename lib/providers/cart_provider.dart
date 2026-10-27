import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => List.unmodifiable(_items.values);
  int get itemCount => _items.values.fold<int>(
        0, (sum, item) => sum + item.quantity,
      );
  int get totalPrice => _items.values.fold<int>(
        0, (sum, item) => sum + item.product.price * item.quantity,
      );

  String _key(Product product, int size) => '${product.id}_$size';

  bool containsProduct(String productId) {
    return _items.values.any((item) => item.product.id == productId);
  }

  void addToCart(Product product, int size) {
    final key = _key(product, size);
    final old = _items[key];
    _items[key] = CartItem(
      product: product,
      size: size,
      quantity: (old?.quantity ?? 0) + 1,
    );
    notifyListeners();
  }

  void toggleProduct(Product product) {
    if (containsProduct(product.id)) {
      removeProduct(product.id);
    } else {
      final size = product.sizes.contains(42) ? 42 : product.sizes.first;
      addToCart(product, size);
    }
  }

  void removeProduct(String productId) {
    final keys = _items.keys.where(
      (key) => _items[key]!.product.id == productId,
    ).toList();
    if (keys.isEmpty) return;
    for (final key in keys) {
      _items.remove(key);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    if (_items.remove(_key(item.product, item.size)) != null) {
      notifyListeners();
    }
  }

  void changeQuantity(CartItem item, int difference) {
    final key = _key(item.product, item.size);
    final current = _items[key];
    if (current == null) return;
    final next = current.quantity + difference;
    if (next <= 0) {
      _items.remove(key);
    } else {
      _items[key] = current.withQuantity(next);
    }
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
