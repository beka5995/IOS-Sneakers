# SneakShop

**SneakShop** is a sneaker shopping application built with Flutter and Dart. It lets shoppers discover shoes, compare product details, save favorite pairs, and organize selected sizes and quantities in a shopping bag.

## Features

- **Sneaker catalog:** Browse sneakers with photos, brands, categories, ratings, and prices in tenge.
- **Search and filters:** Search by product name or brand and filter by shoe category.
- **Product details:** View a large product image, rating, description, tags, available sizes, and an **Add to Cart** button.
- **Favorites:** Bookmark sneakers and manage saved pairs in a dedicated tab.
- **Catalog layouts:** Switch between a two-column grid and a scrolling list.
- **Interactive catalog:** Pull to refresh to add a sample product, swipe left in list mode to remove a sneaker, restore it with **UNDO**, or use **Reset Catalog**.
- **Shopping bag:** Add shoes in a selected size, change quantities, and see the total price in tenge.
- **User profile:** Create a temporary account with name, email, password confirmation, account type, and terms acceptance.
- **Checkout preview:** Review a demo order without processing a real payment.

## Main Screens

| Screen | Description |
| --- | --- |
| **Home / Catalog** | Product cards, search, category filters, and grid/list toggle. |
| **Product Details** | Product photo with favorite overlay, tags, size selection, and fixed Add to Cart button. |
| **Favorites** | Saved sneakers with access to their detail pages. |
| **Shopping Bag** | Selected shoes, sizes, quantities, total amount, and demo checkout. |
| **Profile** | Registration form or existing temporary profile with sign-out action. |

## Flutter Implementation

- **Layouts:** `Column`, `Row`, `Card`, `Expanded`, `Flexible`, `Stack`, `Wrap`, and scrollable views.
- **Interactive UI:** `StatefulWidget` and `setState()` for navigation, search filters, layout switching, and size selection.
- **Shared state:** `StoreController` extends `ChangeNotifier`; `AnimatedBuilder` rebuilds widgets when products, favorites, cart items, or profile information change.
- **Catalog widgets:** `GridView.builder`, `ListView.separated`, `RefreshIndicator`, `Dismissible`, and `LayoutBuilder`.
- **Navigation:** `BottomNavigationBar`, `IndexedStack`, `Navigator.push`, and `Navigator.pop`.
- **Forms:** `Form`, `GlobalKey<FormState>`, `TextEditingController`, and field validation.
- **Reusable components:** Separate widgets for sneaker cards, list tiles, images, and price formatting.

The `StoreController` manages the in-memory product catalog, favorite IDs, shopping bag, and temporary account. The screens access that controller to keep changes synchronized across the application.

## Project Structure

```text
lib/
├── main.dart                      # Application entry point and theme
├── data/
│   └── sample_products.dart       # Sample sneaker catalog
├── models/
│   ├── account.dart               # Account data model
│   ├── cart_item.dart             # Shopping bag item model
│   └── product.dart               # Product data model
├── screens/
│   ├── home_shell.dart            # Main navigation and tab shell
│   ├── catalog_screen.dart        # Products, search, filters, and gestures
│   ├── product_detail_screen.dart # Product information and size selection
│   ├── favorites_screen.dart      # Saved sneakers
│   ├── cart_screen.dart           # Shopping bag and demo checkout
│   └── profile_screen.dart        # Registration and profile
├── state/
│   └── store_controller.dart      # Shared in-memory state
├── widgets/
│   ├── product_card.dart          # Grid product card
│   ├── product_list_tile.dart     # List product item
│   └── product_image.dart         # Network image with fallback
└── utils/
    └── price.dart                 # Tenge price formatting

test/
├── store_controller_test.dart     # State and shopping bag tests
└── widget_test.dart               # Flutter widget tests

docs/
└── future_features.md            # Additional feature notes

android/                           # Android runner
web/                               # Web runner
ios/                               # iOS runner
linux/                             # Linux runner
macos/                             # macOS runner
windows/                           # Windows runner
pubspec.yaml                       # Packages and project configuration
analysis_options.yaml              # Dart analysis rules
run_windows.bat                    # Windows launch script
README.md                          # Project documentation
```

## Getting Started

With Flutter installed, open the project folder and run:

```bash
flutter pub get
flutter run
```

To check the project:

```bash
flutter analyze
flutter test
```

> Products and prices are demonstration data. Favorites, cart items, and profile information are kept in memory. Registration does not create an online account, and checkout is a demo action without real payment processing.

## Author

**Mashat Bekzhan**
