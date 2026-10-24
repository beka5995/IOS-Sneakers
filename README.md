# Sneakers Shop

Sneakers Shop is a sneaker shopping app built with Flutter. It helps shoppers discover sneakers, compare product details, save favorite pairs, and organize items in a shopping bag.

## Features

- **Sneaker discovery:** Browse a sample catalog with product photos, names, ratings, and prices in tenge.
- **Search and categories:** Find sneakers by name and filter products by category.
- **Product details:** View photos, ratings, tags, available sizes, and prices.
- **Favorites:** Bookmark sneakers and manage saved items across screens.
- **Profile:** Create a temporary user profile using a registration form with field validation.
- **Flexible catalog:** Switch between a two-column grid and a scrolling list.
- **Catalog interactions:** Pull to refresh, swipe to remove a sneaker in list mode, undo removal, or reset the catalog.
- **Shopping bag:** Select a shoe size, add items, update quantities, and see the total price.
- **Checkout preview:** Review the shopping bag without making a payment.

## Main Screens

- **Home:** Sneaker cards, search, category filters, and grid/list controls.
- **Product Details:** Large product image, overlaid favorite action, product information, sizes, and Add to Cart button.
- **Favorites:** Sneakers saved by the user.
- **Shopping Bag:** Selected products, sizes, quantities, and total cost.
- **Profile & Registration:** Personal details and a validated account form.

## Flutter Implementation

- `Column`, `Row`, `Card`, and `Expanded` organize the main layouts.
- `Stack` places the bookmark control over the product image.
- `GridView` and `ListView` provide alternative catalog layouts.
- `StatefulWidget` and `setState()` update interactive parts of the interface.
- A shared `StoreController` keeps catalog, favorites, shopping bag, and profile data synchronized.
- Scrollable and adaptive layouts accommodate different screen sizes.

## Technologies

- Flutter and Dart
- Material Design
- StatefulWidget and setState
- Navigator
- Form and input validation

## Project Structure

```text
lib/
  main.dart
  data/         Sample sneaker data
  models/       Product, account, and cart item models
  state/        StoreController and shared app state
  screens/      Catalog, product details, favorites, cart, profile, registration
  widgets/      Reusable sneaker cards and image widgets
  utils/        Price formatting
```

## Getting Started

From the project folder, run:

```bash
flutter pub get
flutter run
```

## Author

**Mashat Bekzhan**

> Products are sample data. Favorites, shopping bag, and profile information are stored in memory; checkout is currently a preview.
