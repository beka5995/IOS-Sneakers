import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'state/store_controller.dart';

void main() {
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
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: HomeShell(store: _store),
    );
  }
}
