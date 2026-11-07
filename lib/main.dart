import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'database/local_auth.dart';
import 'providers/cart_provider.dart';
import 'screens/home_shell.dart';
import 'screens/product_detail_screen.dart';
import 'services/product_links.dart';
import 'state/store_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) databaseFactory = databaseFactoryFfiWeb;
  runApp(const SneakersApp());
}

class SneakersApp extends StatefulWidget {
  final StoreController? store;
  final bool enablePlatformServices;
  const SneakersApp({super.key, this.store, this.enablePlatformServices = true});
  @override
  State<SneakersApp> createState() => _SneakersAppState();
}

class _SneakersAppState extends State<SneakersApp> with WidgetsBindingObserver {
  late final StoreController _store;
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;
  Timer? _connectionTimer;
  String? _lastLink;
  DateTime? _lastLinkTime;

  @override
  void initState() {
    super.initState();
    _store = widget.store ?? StoreController();
    _store.loadCatalog();
    if (widget.enablePlatformServices) {
      WidgetsBinding.instance.addObserver(this);
      _restoreUser();
      _watchNetwork();
      _startConnectionChecks();
      if (!kIsWeb) _listenToLinks();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNetwork();
      _store.verifyConnection();
      _startConnectionChecks();
    } else {
      _connectionTimer?.cancel();
    }
  }

  void _startConnectionChecks() {
    _connectionTimer?.cancel();
    _connectionTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) _store.verifyConnection();
    });
  }

  void _applyNetwork(List<ConnectivityResult> results) {
    if (!mounted) return;
    _store.setNetworkAvailable(results.any((r) => r != ConnectivityResult.none));
  }

  Future<void> _checkNetwork() async {
    try {
      final results = await Connectivity().checkConnectivity();
      _applyNetwork(results);
      // Wi-Fi availability alone is not proof of internet; retry uses real HTTP.
      if (mounted && _store.status == CatalogStatus.error &&
          results.any((r) => r != ConnectivityResult.none)) _store.loadCatalog();
    } catch (error) { debugPrint('Network status unavailable: $error'); }
  }

  Future<void> _watchNetwork() async {
    try {
      _networkSubscription = Connectivity().onConnectivityChanged.listen(
        _applyNetwork, onError: (Object e) => debugPrint('Network status: $e'));
      await _checkNetwork();
    } catch (error) { debugPrint('Network monitoring unavailable: $error'); }
  }

  Future<void> _restoreUser() async {
    try {
      final account = await LocalAuth.instance.currentAccount();
      if (mounted && account != null) _store.register(account);
    } catch (error) { debugPrint('Could not restore session: $error'); }
  }

  Future<void> _listenToLinks() async {
    try {
      final links = AppLinks();
      _linkSubscription = links.uriLinkStream.listen(_openLink,
        onError: (Object e) => debugPrint('Link error: $e'));
      final uri = await links.getInitialLink();
      if (!mounted || uri == null) return;
      if (_navigatorKey.currentState != null) {
        _openLink(uri);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _openLink(uri); });
        WidgetsBinding.instance.ensureVisualUpdate();
      }
    } catch (error) { debugPrint('Unable to initialize links: $error'); }
  }

  void _openLink(Uri uri) {
    if (!mounted) return;
    final link = ProductLink.parse(uri);
    final navigator = _navigatorKey.currentState;
    if (link == null || navigator == null) return;
    final now = DateTime.now();
    if (_lastLink == uri.toString() && _lastLinkTime != null &&
        now.difference(_lastLinkTime!) < const Duration(seconds: 2)) return;
    _lastLink = uri.toString();
    _lastLinkTime = now;
    navigator.push(MaterialPageRoute<void>(builder: (_) =>
      ProductLinkScreen(productId: link.sneakerId, store: _store)));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription?.cancel();
    _networkSubscription?.cancel();
    _connectionTimer?.cancel();
    if (widget.store == null) _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<CartProvider>(
    create: (_) => CartProvider(),
    child: MaterialApp(
      navigatorKey: _navigatorKey, debugShowCheckedModeBanner: false, title: 'SneakShop',
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus, PointerDeviceKind.invertedStylus, PointerDeviceKind.unknown,
      }),
      theme: ThemeData(
        useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFFAFAF9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE25448)),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFFAFAF9), scrolledUnderElevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: HomeShell(store: _store),
      onGenerateRoute: (settings) {
        final link = ProductLink.parse(Uri.tryParse(settings.name ?? '') ?? Uri());
        if (link == null) return null;
        return MaterialPageRoute<void>(settings: settings, builder: (_) =>
          ProductLinkScreen(productId: link.sneakerId, store: _store));
      },
    ),
  );
}
