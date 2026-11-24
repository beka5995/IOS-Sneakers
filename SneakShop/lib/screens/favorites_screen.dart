import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/cart_bloc.dart';

import '../state/store_controller.dart';
import '../widgets/product_list_tile.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final StoreController store;
  const FavoritesScreen({super.key, required this.store});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final products = store.favorites;
      final cart = context.watch<CartBloc>().state;
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Your favorites',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: products.isEmpty
                      ? const Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey,
                                  size: 55,
                                ),
                                SizedBox(height: 12),
                                Text('Nothing saved yet'),
                                SizedBox(height: 4),
                                Text(
                                  'Tap the heart on a pair you like.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: products.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final inCart = cart.containsProduct(product.id);
                            return ProductListTile(
                              inCart: inCart,
                              onCartToggle: () => context.read<CartBloc>().add(
                                inCart
                                    ? RemoveProductEvent(product.id)
                                    : AddProductEvent(product),
                              ),
                              product: product,
                              favorite: true,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => ProductDetailScreen(
                                    product: product,
                                    store: store,
                                  ),
                                ),
                              ),
                              onFavorite: () =>
                                  store.toggleFavorite(product.id),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
