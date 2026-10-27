import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/data/sample_products.dart';
import 'package:final_project/models/account.dart';
import 'package:final_project/state/store_controller.dart';
import 'package:final_project/utils/price.dart';

void main() {
  test('store starts with sample products', () {
    final store = StoreController();
    expect(store.products.length, sampleProducts.length);
    store.dispose();
  });

  test('favorite button toggles an item', () {
    final store = StoreController();
    const id = 'p01';
    store.toggleFavorite(id);
    expect(store.isFavorite(id), isTrue);
    expect(store.favorites.single.id, id);
    store.toggleFavorite(id);
    expect(store.isFavorite(id), isFalse);
    store.dispose();
  });

  test('new items are added to the start', () {
    final store = StoreController();
    final firstOldId = store.products.first.id;
    store.addFreshProduct();
    expect(store.products.first.id, 'new_1');
    expect(store.products[1].id, firstOldId);
    store.dispose();
  });

  test('removed products can be restored at their old index', () {
    final store = StoreController();
    final second = store.products[1];
    store.removeProduct(second.id);
    expect(store.products.any((p) => p.id == second.id), isFalse);
    store.restoreProduct(second, 1);
    expect(store.products[1].id, second.id);
    store.dispose();
  });

  test('reset catalog restores original products', () {
    final store = StoreController();
    for (final product in sampleProducts) {
      store.removeProduct(product.id);
    }
    expect(store.products, isEmpty);
    store.resetCatalog();
    expect(store.products.length, sampleProducts.length);
    expect(store.products.first.id, sampleProducts.first.id);
    store.dispose();
  });

  test('register and sign out change the profile', () {
    final store = StoreController();
    expect(store.account, isNull);
    store.register(const Account(
      fullName: 'Demo User',
      email: 'demo@example.com',
      role: 'Student',
    ));
    expect(store.account?.fullName, 'Demo User');
    store.signOut();
    expect(store.account, isNull);
    store.dispose();
  });

  test('prices are written in tenge', () {
    expect(formatPrice(42990), '42 990 ₸');
  });
}
