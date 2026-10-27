import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/main.dart';

void main() {
  testWidgets('main tabs and the catalog are shown', (tester) async {
    await tester.pumpWidget(const SneakersApp());

    expect(find.text('SneakShop'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('profile tab opens the registration form', (tester) async {
    await tester.pumpWidget(const SneakersApp());
    await tester.tap(find.text('Profile'));
    await tester.pump();

    expect(find.text('Create account'), findsWidgets);
    expect(find.byType(Form), findsOneWidget);
  });
  testWidgets('shopping bag updates when a catalog item is removed',
      (tester) async {
    await tester.pumpWidget(const SneakersApp());

    await tester.tap(find.text('Add to Cart').first);
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Shopping bag'));
    await tester.pumpAndSettle();
    expect(find.text('Clear All'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove item').first);
    await tester.pump();
    expect(find.text('Your bag is empty'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Add to Cart'), findsWidgets);
  });

}
