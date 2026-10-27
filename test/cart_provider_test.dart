import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/data/sample_products.dart';
import 'package:final_project/providers/cart_provider.dart';

void main() {
  test('cart totals and individual removal use the selected shoe size', () {
    final cart = CartProvider();
    final shoe = sampleProducts.first;
    cart.addToCart(shoe, 42);
    cart.addToCart(shoe, 42);
    cart.addToCart(shoe, 43);
    expect(cart.itemCount, 3);
    expect(cart.items.length, 2);
    expect(cart.totalPrice, shoe.price * 3);
    expect(cart.containsProduct(shoe.id), isTrue);

    cart.removeItem(cart.items.first);
    expect(cart.itemCount, 1);
    expect(cart.totalPrice, shoe.price);
    cart.clear();
    expect(cart.itemCount, 0);
    expect(cart.totalPrice, 0);
    cart.dispose();
  });

  test('catalog toggle and cart removal update the same state', () {
    final cart = CartProvider();
    final shoe = sampleProducts[1];
    var changes = 0;
    cart.addListener(() => changes++);

    cart.toggleProduct(shoe);
    expect(cart.containsProduct(shoe.id), isTrue);
    expect(cart.itemCount, 1);

    cart.removeProduct(shoe.id);
    expect(cart.containsProduct(shoe.id), isFalse);
    expect(cart.itemCount, 0);
    expect(changes, 2);
    cart.dispose();
  });

  test('removing one size keeps the other size in the bag', () {
    final cart = CartProvider();
    final shoe = sampleProducts.first;
    cart.addToCart(shoe, 41);
    cart.addToCart(shoe, 42);
    cart.removeItem(cart.items.first);
    expect(cart.containsProduct(shoe.id), isTrue);
    expect(cart.itemCount, 1);
    cart.dispose();
  });
}
