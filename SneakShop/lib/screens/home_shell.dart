import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/cart_bloc.dart';
import '../state/photo_journal_store.dart';
import '../state/preferences_store.dart';
import '../state/store_controller.dart';
import 'add_product_sheet.dart';
import 'cart_screen.dart';
import 'catalog_screen.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'notes_screen.dart';
import 'photo_journal_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.store});

  final StoreController store;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _journal = PhotoJournalStore();
  int _selectedIndex = 0;
  bool _journalVisited = false;

  static const _titles = [
    'SneakShop',
    'Explore',
    '',
    'Photo Journal',
    'Profile',
  ];

  void _select(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
      if (index == 3) _journalVisited = true;
    });
  }

  Future<void> _showAdd() async {
    final products = {
      for (final product in widget.store.availableProducts) product.id: product,
      for (final product in widget.store.favorites) product.id: product,
    }.values.toList();
    final message = await showModalBottomSheet<String>(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (_) => AddProductSheet(products: products, store: widget.store),
    );
    if (!mounted || message == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  void dispose() {
    _journal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex != 0
            ? Text(
                _titles[_selectedIndex],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SneakShop',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                  ),
                  Text(
                    context.watch<PreferencesStore>().displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Favorites')),
                  body: FavoritesScreen(store: widget.store),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Notes',
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Notes')),
                  body: const NotesScreen(),
                ),
              ),
            ),
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cart) => Badge(
              isLabelVisible: cart.count > 0,
              label: Text('${cart.count}'),
              child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                tooltip: 'Shopping bag',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const CartScreen()),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HeroMode(
            enabled: _selectedIndex == 0,
            child: CatalogScreen(store: widget.store),
          ),
          HeroMode(
            enabled: _selectedIndex == 1,
            child: ExploreScreen(store: widget.store),
          ),
          const SizedBox.shrink(),
          _journalVisited
              ? PhotoJournalScreen(journal: _journal)
              : const SizedBox.shrink(),
          ProfileScreen(
            store: widget.store,
            journal: _journal,
            onOpenJournal: () => _select(3),
            onSignedIn: () => _select(0),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            _showAdd();
          } else {
            _select(index);
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Add',
          ),
          const NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Journal',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
