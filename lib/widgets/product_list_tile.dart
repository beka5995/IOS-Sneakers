import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/price.dart';
import 'product_image.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const ProductListTile({
    super.key,
    required this.product,
    required this.favorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              ProductImage(url: product.imageUrl, width: 82, height: 86),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(product.brand, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(product.category, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    Row(children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF2AA40), size: 15),
                      Text('${product.rating}', style: const TextStyle(fontSize: 11)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.zero,
                    onPressed: onFavorite,
                    icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                        size: 21, color: favorite ? const Color(0xFFE25448) : Colors.grey),
                  ),
                  const SizedBox(height: 9),
                  Text(formatPrice(product.price),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
