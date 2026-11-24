import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../services/product_links.dart';
import '../state/cart_bloc.dart';
import '../state/store_controller.dart';
import '../widgets/product_list_tile.dart';
import 'product_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.store});
  final StoreController store;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _query = '';
  String? _linkError;

  void _openProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ProductDetailScreen(product: product, store: widget.store),
      ),
    );
  }

  void _submit(String input) {
    final query = input.trim();
    final link = ProductLink.fromSearch(query);
    if (link != null) {
      FocusScope.of(context).unfocus();
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              ProductLinkScreen(productId: link.sneakerId, store: widget.store),
        ),
      );
    } else if (query.contains('://') || query.startsWith('/product/')) {
      setState(
        () => _linkError = 'Paste a product link copied from SneakShop.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartBloc>().state;
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final query = _query.trim().toLowerCase();
        final link = ProductLink.fromSearch(_query);
        final matches = widget.store.availableProducts.where((product) {
          return product.name.toLowerCase().contains(query) ||
              product.brand.toLowerCase().contains(query);
        }).toList();

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: _submit,
                    onChanged: (value) => setState(() {
                      _query = value;
                      _linkError = null;
                    }),
                    decoration: InputDecoration(
                      labelText: 'Name or product link',
                      prefixIcon: const Icon(Icons.search),
                      errorText: _linkError,
                    ),
                  ),
                ),
                Expanded(
                  child: link != null
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: FilledButton.icon(
                            onPressed: () => _submit(_query),
                            icon: const Icon(Icons.link),
                            label: const Text('Open product'),
                          ),
                        )
                      : _results(matches, cart),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _results(List<Product> products, CartState cart) {
    final store = widget.store;
    if (store.status == CatalogStatus.loading && !store.isRefreshing) {
      return const Center(child: CircularProgressIndicator());
    }
    if (store.status == CatalogStatus.error) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                store.error ?? 'Unable to load sneakers',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: store.loadCatalog,
                child: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      );
    }
    if (products.isEmpty) {
      return const Center(child: Text('No matching sneakers'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = products[index];
        final inCart = cart.containsProduct(product.id);
        return ProductListTile(
          product: product,
          inCart: inCart,
          favorite: store.isFavorite(product.id),
          onFavorite: () => store.toggleFavorite(product.id),
          onCartToggle: () => context.read<CartBloc>().add(
                inCart
                    ? RemoveProductEvent(product.id)
                    : AddProductEvent(product),
              ),
          onTap: () => _openProduct(product),
        );
      },
    );
  }
}
