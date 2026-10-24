# SneakShop — Flutter Sneaker Store

This is my Flutter semester project. It is a simple sneaker store where people can browse shoes, check details, save favorites and add pairs to a shopping bag. The original project has been extended into one app instead of separate small examples.

## What works now

- **Home catalog:** sneakers, product pictures, names, prices, ratings, search and category filters. The original Nike Air Max and Puma Run items are still in the catalog, together with other sample pairs.
- **Product page:** photo in a `Stack`, bookmark button, title, price, rating, category tags, sizes and a fixed full-width Add to Cart button.
- **Shopping bag:** choose a size, add an item, adjust quantities and view a total in tenge. The checkout is only a preview; no payment is made.
- **Favorites:** save and remove shoes without losing the current app state.
- **Profile:** registration form with full name, email, password, confirm password, account type and terms checkbox. Invalid fields show errors, and valid submission creates a temporary profile.
- **Navigation:** Home, Favorites and Profile tabs. Products open with `Navigator.push` and return with `Navigator.pop`.
- **Catalog views:** two-column `GridView.builder` (ratio `0.72`) and `ListView.separated` with a toggle.
- **Catalog interactions:** pull to refresh (1.5-second simulation, adds a new item at the beginning); right-to-left swipe to remove a shoe with `Dismissible`, `ValueKey` and a floating SnackBar with UNDO; empty catalog with Reset Catalog.

I am keeping the design and code straightforward so it is easy to understand and continue expanding.

## Three features planned for the final version

These are **future plans, not implemented yet**. They will be developed in later stages when the project has real authentication, REST API, database storage and BLoC.

1. **Smart Lock Price:** a registered customer can lock the price of a sneaker for **exactly 30 days**. A later price increase must not change the locked price while the reservation is valid.
2. **Maximum 3 active reservations:** each account can have up to **three active price locks** at once. To make a fourth reservation, the customer must buy or cancel one, or wait until one expires. The backend will enforce this limit.
3. **Admin Special Offer:** an admin can create a general or personalized discount. When an eligible customer enters the Home screen, the app will show the active offer as a popup/banner.

See [docs/future_features.md](docs/future_features.md) for a more detailed plan. For now, the priority is finishing and testing the customer app. No price-lock, reservation, bonus or administrator screens are part of the current version.

## Start the app

1. Install Flutter and an Android emulator or connect an Android phone with USB debugging. For an iOS build use Flutter and Xcode on macOS.
2. Open the **`final_project_ios_sneakers`** folder in VS Code or Android Studio.
3. In the terminal, run:

```bash
flutter doctor
flutter pub get
flutter run
```

The Android and iOS project folders are **already included**. Do not run `flutter create` to assemble the project. On Windows, `run_windows.bat` can start it if Flutter is available in PATH and a device is connected.

For tests and analysis:

```bash
flutter analyze
flutter test
```

Photos are loaded from public Unsplash URLs, so the phone needs internet access. A placeholder appears if a photo fails to load. Android internet permission is present in the main manifest.

## Project folders

```text
lib/
  main.dart                 App theme and shared store
  models/                  Product, account, cart item
  data/                    Sample product data
  state/                   Shared in-memory StoreController
  screens/                 Catalog, details, cart, favorites, profile, tabs
  widgets/                 Sneaker cards and image widget
  utils/                   Price formatting
android/                    Original Android project files
ios/                        Original iOS project files
test/                       Controller and basic widget tests
docs/                       Future features plan
```

## Limitations of the current version

The product data and user state live **only in memory** and reset after restarting the app. Registration is a form prototype, not real account authentication; the password is never persisted or printed. Checkout is a preview, not a real purchase. Backend features will be added in later milestones.

## Author

Mashat Bekzhan

## Android Studio: if `package:flutter/material.dart` is red

This usually means the IDE has not recognized Flutter or packages have not
been resolved. Check **Settings > Plugins** for Flutter and Dart plugins, then
set **Settings > Languages & Frameworks > Flutter > Flutter SDK path** to the
folder containing the `bin` directory of your Flutter installation.

Open the project root (the folder containing `pubspec.yaml`), not its `android`
subfolder. In the Android Studio Terminal, run:

```powershell
flutter --version
flutter doctor -v
flutter pub get
flutter analyze
flutter run
```

When updating from an older ZIP, back up your project and use the new project
folder. Do not copy machine-specific `android/local.properties` files between
computers; Flutter generates them locally.
