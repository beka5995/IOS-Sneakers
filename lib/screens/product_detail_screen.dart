import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/store_controller.dart';
import '../utils/price.dart';
import '../widgets/product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final StoreController store;

  const ProductDetailScreen({super.key, required this.product, required this.store});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int? _selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.18,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductImage(url: product.imageUrl),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: AnimatedBuilder(
                          animation: widget.store,
                          builder: (context, _) => Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: IconButton(
                              tooltip: 'Favorite',
                              onPressed: () => widget.store.toggleFavorite(product.id),
                              icon: Icon(widget.store.isFavorite(product.id)
                                  ? Icons.bookmark : Icons.bookmark_border,
                                color: widget.store.isFavorite(product.id)
                                    ? const Color(0xFFE25448) : Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(product.brand.toUpperCase(), style: const TextStyle(
                  fontSize: 12, letterSpacing: 1.4, color: Colors.grey,
                )),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(product.name, style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(formatPrice(product.price),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 19, color: Color(0xFFF2AA40)),
                    Text(' ${product.rating}  ', style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Text('Customer rating', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 7,
                  children: [
                    Chip(label: Text(product.category)),
                    const Chip(label: Text('Comfort fit')),
                    if (product.isNew) const Chip(label: Text('New arrival')),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('About this pair', style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 6),
                Text(product.description, style: const TextStyle(height: 1.5)),
                const SizedBox(height: 18),
                const Text('Choose size (EU)', style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 7,
                  children: product.sizes.map((size) {
                    return ChoiceChip(
                      label: Text('$size'),
                      selected: _selectedSize == size,
                      onSelected: (_) => setState(() => _selectedSize = size),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go back'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: FilledButton.icon(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Add to Cart'),
                  onPressed: () {
                    if (_selectedSize == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please choose a size first'),
                        behavior: SnackBarBehavior.floating,
                      ));
                      return;
                    }
                    widget.store.addToCart(product, _selectedSize!);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${product.name} added to your bag'),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
