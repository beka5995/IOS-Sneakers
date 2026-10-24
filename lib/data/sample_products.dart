import '../models/product.dart';

// Pictures are loaded from Unsplash when the phone has internet access.
const sampleProducts = <Product>[
  Product(
    id: 'p01',
    name: 'Nike Air Max',
    brand: 'Nike',
    category: 'Running',
    description: 'Lightweight everyday sneakers with a soft sole. '
        'A good choice for city walks and active days.',
    price: 42990,
    rating: 4.8,
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80',
    sizes: [39, 40, 41, 42, 43, 44],
  ),
  Product(
    id: 'p02',
    name: 'Classic Low White',
    brand: 'Street Lab',
    category: 'Lifestyle',
    description: 'Simple low-top sneakers for a clean casual look. '
        'Comfortable with jeans or relaxed trousers.',
    price: 37990,
    rating: 4.6,
    imageUrl: 'https://images.unsplash.com/photo-1600269452121-4f2416e55c28?w=800&q=80',
    sizes: [38, 39, 40, 41, 42, 43],
  ),
  Product(
    id: 'p03',
    name: 'Court Classic',
    brand: 'Next Step',
    category: 'Basketball',
    description: 'A court-inspired silhouette with extra ankle support '
        'and a grippy outsole.',
    price: 55990,
    rating: 4.9,
    imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800&q=80',
    sizes: [40, 41, 42, 43, 44, 45],
  ),
  Product(
    id: 'p04',
    name: 'Puma Run',
    brand: 'Puma',
    category: 'Running',
    description: 'Breathable upper, flexible feel and enough cushioning '
        'for a busy day.',
    price: 46990,
    rating: 4.5,
    imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&q=80',
    sizes: [39, 40, 41, 42, 43],
  ),
  Product(
    id: 'p05',
    name: 'Retro Street',
    brand: 'Street Lab',
    category: 'Lifestyle',
    description: 'Retro colors and a classic shape made for daily wear.',
    price: 39990,
    rating: 4.7,
    imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=800&q=80',
    sizes: [38, 39, 40, 41, 42, 43],
  ),
  Product(
    id: 'p06',
    name: 'High Top One',
    brand: 'Next Step',
    category: 'Basketball',
    description: 'High-top styling with a stable sole and comfortable padding.',
    price: 61990,
    rating: 4.8,
    imageUrl: 'https://images.unsplash.com/photo-1579338559194-a162d19bf842?w=800&q=80',
    sizes: [40, 41, 42, 43, 44],
  ),
];
