import 'package:flutter/material.dart';

import '../state/store_controller.dart';
import 'cart_screen.dart';
import 'catalog_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  final StoreController store;

  const HomeShell({super.key, required this.store});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SneakShop', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25)),
        actions: [
          AnimatedBuilder(
            animation: widget.store,
            builder: (context, _) {
              return Badge(
                isLabelVisible: widget.store.cartCount > 0,
                label: Text('${widget.store.cartCount}'),
                child: IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  tooltip: 'Shopping bag',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => CartScreen(store: widget.store),
                    ));
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CatalogScreen(store: widget.store),
          FavoritesScreen(store: widget.store),
          ProfileScreen(store: widget.store),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE25448),
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
