import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/store_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/product_list_tile.dart';
import 'product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  final StoreController store;

  const CatalogScreen({super.key, required this.store});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool _showGrid = true;
  String _category = 'All';
  String _search = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _visibleProducts(List<Product> products) {
    return products.where((product) {
      final categoryMatches = _category == 'All' || product.category == _category;
      final query = _search.trim().toLowerCase();
      final searchMatches = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query);
      return categoryMatches && searchMatches;
    }).toList();
  }

  void _openProduct(Product product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ProductDetailScreen(product: product, store: widget.store),
    ));
  }

  Future<void> _refreshProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    widget.store.addFreshProduct();
    // Make the new product visible even if a filter had been selected.
    setState(() {
      _category = 'All';
      _search = '';
      _searchController.clear();
    });
  }

  void _removeWithUndo(Product product) {
    final originalIndex = widget.store.products.indexWhere((p) => p.id == product.id);
    if (originalIndex < 0) return;
    widget.store.removeProduct(product.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('${product.name} removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => widget.store.restoreProduct(product, originalIndex),
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final allProducts = widget.store.products;
        final visible = _visibleProducts(allProducts);
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, size) {
                  // Keep the search bar usable when the keyboard makes the screen short.
                  final compact = size.maxHeight < 420;
                  final veryCompact = size.maxHeight < 250;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compact) Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(top: 8, bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF272A31),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FRESH PICKS', style: TextStyle(
                              color: Color(0xFFFFB9AC), fontSize: 11, letterSpacing: 1.5,
                            )),
                            SizedBox(height: 4),
                            Text('Find your next pair', style: TextStyle(
                              color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold,
                            )),
                            Text('New styles for every day', style: TextStyle(
                              color: Color(0xFFC8C8CB), fontSize: 12,
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 46,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _search = value),
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Search sneakers...',
                            prefixIcon: Icon(Icons.search),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (!veryCompact) SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Running', 'Lifestyle', 'Basketball'].map((name) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: ChoiceChip(
                                label: Text(name),
                                selected: _category == name,
                                onSelected: (_) => setState(() => _category = name),
                                visualDensity: VisualDensity.compact,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Discover (${visible.length})',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _showGrid = false),
                            tooltip: 'List view',
                            icon: Icon(Icons.view_list_rounded,
                                color: !_showGrid ? const Color(0xFFE25448) : Colors.grey),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _showGrid = true),
                            tooltip: 'Grid view',
                            icon: Icon(Icons.grid_view_rounded,
                                color: _showGrid ? const Color(0xFFE25448) : Colors.grey),
                          ),
                        ],
                      ),
                      Expanded(
                        child: allProducts.isEmpty
                            ? _emptyCatalog()
                            : visible.isEmpty
                                ? const Center(child: Text('No sneakers found. Try another search.'))
                                : _showGrid ? _grid(visible) : _list(visible),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _grid(List<Product> products) {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: GridView.builder(
        key: const PageStorageKey('catalog-grid'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            key: ValueKey(product.id),
            product: product,
            favorite: widget.store.isFavorite(product.id),
            onTap: () => _openProduct(product),
            onFavorite: () => widget.store.toggleFavorite(product.id),
          );
        },
      ),
    );
  }

  Widget _list(List<Product> products) {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: ListView.separated(
        key: const PageStorageKey('catalog-list'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: products.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = products[index];
          return Dismissible(
            key: ValueKey(product.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              color: const Color(0xFFD94141),
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            onDismissed: (_) => _removeWithUndo(product),
            child: ProductListTile(
              product: product,
              favorite: widget.store.isFavorite(product.id),
              onTap: () => _openProduct(product),
              onFavorite: () => widget.store.toggleFavorite(product.id),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyCatalog() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
          const SizedBox(height: 14),
          const Text('Catalog is Empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('All products have been removed.'),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () {
              widget.store.resetCatalog();
              setState(() {
                _category = 'All';
                _search = '';
                _searchController.clear();
              });
            },
            child: const Text('Reset Catalog'),
          ),
        ],
      ),
    );
  }
}
