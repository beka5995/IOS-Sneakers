import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../state/cart_bloc.dart';
import '../state/store_controller.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({
    super.key,
    required this.products,
    required this.store,
  });
  final List<Product> products;
  final StoreController store;

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  late Product _product = widget.products.first;
  bool _cart = true;
  bool _favorite = false;

  void _add() {
    if (_cart) context.read<CartBloc>().add(AddProductEvent(_product));
    if (_favorite) widget.store.saveFavorite(_product);
    final destination = _cart && _favorite
        ? 'your bag and favorites'
        : _cart
        ? 'your bag'
        : 'favorites';
    Navigator.pop(context, '${_product.name} added to $destination');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add a pair',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (widget.products.isEmpty)
              const Text('There are no pairs available right now.')
            else ...[
              DropdownButtonFormField<Product>(
                initialValue: _product,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Sneaker'),
                items: [
                  for (final product in widget.products)
                    DropdownMenuItem(
                      value: product,
                      child: Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _product = value);
                },
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _cart,
                onChanged: (value) => setState(() => _cart = value ?? false),
                title: const Text('Add to Cart'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _favorite,
                onChanged: (value) =>
                    setState(() => _favorite = value ?? false),
                title: const Text('Save to Favorites'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              FilledButton(
                onPressed: _cart || _favorite ? _add : null,
                child: const Text('Add selected'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
