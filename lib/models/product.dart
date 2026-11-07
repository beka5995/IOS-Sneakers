class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  final List<int> sizes;
  final bool isNew;
  final List<String> photos;
  final int stock;

  const Product({
    required this.id, required this.name, required this.brand,
    required this.category, required this.description, required this.price,
    required this.rating, required this.imageUrl, required this.sizes,
    this.isNew = false, this.photos = const [], this.stock = 99,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final name = json['title'];
    final price = json['price'];
    final rating = json['rating'];
    final category = json['category'];
    if (rawId is! int || rawId <= 0 || name is! String || name.trim().isEmpty ||
        price is! num || !price.isFinite || price < 0 ||
        rating is! num || !rating.isFinite || rating < 0 || rating > 5 ||
        (category != 'mens-shoes' && category != 'womens-shoes')) {
      throw const FormatException('Invalid product information');
    }
    bool validImage(String url) {
      final uri = Uri.tryParse(url);
      return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
    }
    final rawImages = json['images'];
    final images = rawImages is List
        ? rawImages.whereType<String>().where(validImage).toList(growable: false)
        : <String>[];
    final thumbnail = json['thumbnail'];
    final image = thumbnail is String && validImage(thumbnail)
        ? thumbnail : images.isEmpty ? '' : images.first;
    final rawStock = json['stock'];
    return Product(
      id: 'api_$rawId', name: name.trim(),
      brand: json['brand'] is String ? json['brand'] as String : '',
      category: category == 'mens-shoes' ? 'Men' : 'Women',
      description: json['description'] is String ? json['description'] as String : '',
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: image,
      photos: images.isEmpty && image.isNotEmpty ? [image] : images,
      sizes: category == 'mens-shoes'
          ? const [39, 40, 41, 42, 43, 44, 45] : const [36, 37, 38, 39, 40, 41],
      stock: rawStock is num && rawStock.isFinite ? rawStock.toInt().clamp(0, 99999).toInt() : 0,
    );
  }
}
