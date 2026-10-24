class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final int price;
  final double rating;
  final String imageUrl;
  final List<int> sizes;
  final bool isNew;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.sizes,
    this.isNew = false,
  });
}
