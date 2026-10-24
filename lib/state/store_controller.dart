import 'package:flutter/foundation.dart';

import '../data/sample_products.dart';
import '../models/account.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class StoreController extends ChangeNotifier {
  final List<Product> _products = List<Product>.of(sampleProducts);
  final Set<String> _favoriteIds = {};
  final Map<String, CartItem> _cart = {};
  Account? _account;
  int _newProductNumber = 0;

  List<Product> get products => List.unmodifiable(_products);
  Account? get account => _account;
  List<CartItem> get cart => List.unmodifiable(_cart.values);
  List<Product> get favorites => List.unmodifiable(
        _products.where((product) => _favoriteIds.contains(product.id)),
      );

  int get cartCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);
  int get cartTotal => _cart.values.fold(
        0,
        (sum, item) => sum + item.product.price * item.quantity,
      );

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (!_favoriteIds.add(id)) {
      _favoriteIds.remove(id);
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  void restoreProduct(Product product, int originalIndex) {
    if (_products.any((item) => item.id == product.id)) return;
    final index = originalIndex.clamp(0, _products.length).toInt();
    _products.insert(index, product);
    notifyListeners();
  }

  void resetCatalog() {
    _products
      ..clear()
      ..addAll(sampleProducts);
    _newProductNumber = 0;
    notifyListeners();
  }

  void addFreshProduct() {
    _newProductNumber++;
    final template = sampleProducts[_newProductNumber % sampleProducts.length];
    _products.insert(
      0,
      Product(
        id: 'new_$_newProductNumber',
        name: 'Fresh Drop $_newProductNumber',
        brand: template.brand,
        category: template.category,
        description: 'Just added to the shop. ${template.description}',
        price: template.price,
        rating: template.rating,
        imageUrl: template.imageUrl,
        sizes: template.sizes,
        isNew: true,
      ),
    );
    notifyListeners();
  }

  void addToCart(Product product, int size) {
    final id = '${product.id}_$size';
    final oldItem = _cart[id];
    _cart[id] = CartItem(
      product: product,
      size: size,
      quantity: (oldItem?.quantity ?? 0) + 1,
    );
    notifyListeners();
  }

  void changeCartQuantity(CartItem item, int difference) {
    final id = '${item.product.id}_${item.size}';
    final current = _cart[id];
    if (current == null) return;
    final nextQuantity = current.quantity + difference;
    if (nextQuantity <= 0) {
      _cart.remove(id);
    } else {
      _cart[id] = current.withQuantity(nextQuantity);
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void register(Account account) {
    _account = account;
    notifyListeners();
  }

  void signOut() {
    _account = null;
    notifyListeners();
  }
}
