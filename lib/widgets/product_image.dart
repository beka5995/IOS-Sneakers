import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: const Color(0xFFECECEB),
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF0F0EF),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },
      ),
    );
  }
}
