import 'product.dart';

class CartItem {
  final Product product;
  final int size;
  final int quantity;

  const CartItem({
    required this.product,
    required this.size,
    required this.quantity,
  });

  CartItem withQuantity(int newQuantity) {
    return CartItem(product: product, size: size, quantity: newQuantity);
  }
}
