import 'package:flutter/material.dart';

import '../state/store_controller.dart';
import '../utils/price.dart';
import '../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  final StoreController store;

  const CartScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final items = store.cart;
        return Scaffold(
          appBar: AppBar(title: const Text('Shopping bag')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: items.isEmpty
                  ? const Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 56, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Your bag is empty'),
                        Text('Add your favorite sneakers to start shopping.',
                            style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                      ],
                    ))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const Divider(height: 24),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Row(
                          children: [
                            ProductImage(url: item.product.imageUrl, width: 85, height: 92),
                            const SizedBox(width: 12),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name,
                                    maxLines: 2, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text('EU ${item.size}', style: const TextStyle(color: Colors.grey)),
                                Text(formatPrice(item.product.price)),
                              ],
                            )),
                            Column(children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => store.changeCartQuantity(item, 1),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => store.changeCartQuantity(item, -1),
                              ),
                            ]),
                          ],
                        );
                      },
                    ),
            ),
          ),
          bottomNavigationBar: items.isEmpty
              ? null
              : SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 17)),
                            Text(formatPrice(store.cartTotal), style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,
                            )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Demo order'),
                                  content: const Text('This is a preview store. No real payment will be made.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        store.clearCart();
                                        Navigator.pop(dialogContext);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Demo order placed!')),
                                        );
                                      },
                                      child: const Text('Place demo order'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Continue'),
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
}
