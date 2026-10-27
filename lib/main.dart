import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/local_auth.dart';
import 'providers/cart_provider.dart';
import 'screens/home_shell.dart';
import 'state/store_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(const SneakersApp());
}

class SneakersApp extends StatefulWidget {
  const SneakersApp({super.key});

  @override
  State<SneakersApp> createState() => _SneakersAppState();
}

class _SneakersAppState extends State<SneakersApp> {
  final StoreController _store = StoreController();

  @override
  void initState() {
    super.initState();
    _restoreUser();
  }

  Future<void> _restoreUser() async {
    try {
      final account = await LocalAuth.instance.currentAccount();

      if (mounted && account != null) {
        _store.register(account);
      }
    } catch (e) {
      debugPrint('Could not restore session: $e');
    }
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartProvider>(
      create: (_) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SneakShop',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFAFAF9),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE25448),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFAFAF9),
            scrolledUnderElevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: HomeShell(store: _store),
      ),
    );
  }
}
