import 'dart:io';
import 'dart:typed_data';

import 'package:final_project/database/journal_database.dart';
import 'package:final_project/main.dart';
import 'package:final_project/models/account.dart';
import 'package:final_project/services/journal_photo.dart';
import 'package:final_project/services/product_links.dart';
import 'package:final_project/state/preferences_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as image;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;

import 'fixtures/catalog.dart';

void main() {
  test('Explore accepts product share links and web addresses', () {
    for (final link in [
      'narxoz://store/product/api_88',
      'http://localhost:7358/#/product/api_88',
      'https://shop.example.com/product/api_88',
    ]) {
      expect(ProductLink.fromSearch(link)?.sneakerId, 'api_88');
    }
    expect(ProductLink.fromSearch('https://shop.example.com/#/product/invalid'),
        isNull);
  });

  testWidgets('Add saves the same product to Cart and Favorites', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await PreferencesStore.load();
    final store = testStore();
    await tester.pumpWidget(
      SneakersApp(
        preferences: preferences,
        store: store,
        enablePlatformServices: false,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save to Favorites'));
    await tester.tap(find.text('Add selected'));
    await tester.pumpAndSettle();
    expect(store.favorites.single.id, store.products.first.id);

    await tester.tap(find.byTooltip('Shopping bag'));
    await tester.pumpAndSettle();
    expect(find.text(store.products.first.name), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Remove'), findsOneWidget);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(store.favorites, hasLength(1));
    await tester.pumpWidget(const SizedBox());
    preferences.dispose();
    store.dispose();
  });

  testWidgets('Explore finds products beyond Home and opens copied links', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await PreferencesStore.load();
    final store = testStore();
    await tester.pumpWidget(
      SneakersApp(
        preferences: preferences,
        store: store,
        enablePlatformServices: false,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      store.products.map((product) => product.name),
      isNot(contains('Pair 8')),
    );
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    final search = find.widgetWithText(TextField, 'Name or product link');
    await tester.enterText(search, 'Pair 8');
    await tester.pumpAndSettle();
    expect(find.text('Pair 8'), findsWidgets);
    await tester.enterText(search, 'narxoz://store/product/api_8');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open product'));
    await tester.pumpAndSettle();
    expect(find.text('Pair 8'), findsOneWidget);
    expect(find.text('Back to catalog'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    preferences.dispose();
    store.dispose();
  });

  testWidgets('Profile details and journal controls fit a compact layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final preferences = await PreferencesStore.load();
    final store = testStore();
    store.register(
      const Account(
        fullName: 'Test Shopper',
        email: 'shopper@example.com',
        role: 'Sneaker collector',
      ),
    );
    await tester.pumpWidget(
      SneakersApp(
        preferences: preferences,
        store: store,
        enablePlatformServices: false,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(NavigationDestination).last);
    await tester.pumpAndSettle();
    expect(find.text('Sneaker collector'), findsOneWidget);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('shopper@example.com'), findsOneWidget);
    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Front'), findsOneWidget);
    expect(find.text('Rear'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    preferences.dispose();
    store.dispose();
  });

  test(
    'photo journal persists the optimized photo and position after reopen',
    () async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      final temp = await Directory.systemTemp.createTemp('sneakshop-journal-');
      await databaseFactory.setDatabasesPath(temp.path);
      const repository = JournalDatabase();
      final bytes = image.encodePng(image.Image(width: 1200, height: 400));
      final photo = optimizeJournalPhoto(Uint8List.fromList(bytes));
      expect(image.decodeJpg(photo)?.width, 1080);
      final takenAt = DateTime(2026, 11, 24, 14, 30);
      final entry = await repository.save(
        photo: photo,
        caption: 'My new pair',
        takenAt: takenAt,
        location: Position(
          latitude: 43.238949,
          longitude: 76.889709,
          timestamp: takenAt,
          accuracy: 12.4,
          altitude: 840,
          altitudeAccuracy: 3,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        ),
      );
      await (await repository.open()).close();
      final restored = (await const JournalDatabase().read()).single;
      expect(restored.id, entry.id);
      expect(restored.photo, orderedEquals(photo));
      expect(restored.caption, 'My new pair');
      expect(restored.takenAt, takenAt);
      expect(restored.latitude, 43.238949);
      expect(restored.longitude, 76.889709);
      expect(restored.accuracy, 12.4);
      expect(restored.altitude, 840);
      await repository.delete(entry.id);
      expect(await repository.read(), isEmpty);
      await (await repository.open()).close();
      await temp.delete(recursive: true);
    },
  );
}
