# SneakShop

A single Flutter shoe store with one network-backed catalog. The same products
power Home, Explore, favorites, details and the shopping bag.

## Run

```sh
flutter pub get
flutter run -d chrome --web-port=7358
```

For Android, select the emulator in Android Studio and run lib/main.dart.
The initial catalog requires internet. No GitHub setup, API key or separate server is needed.

## Shopping

- Six products appear initially, obtained from the HTTP responses.
- Home offers Grid and List views with direct Cart and Favorites controls.
- Explore searches all available products by name or brand. Paste a product link
  copied from the share sheet and select Open product to go straight to its details.
- Add opens a product selector. Choose Cart, Favorites, or both from the same sheet.
- Favorite any product; favorites and cart are saved locally and restored after restarting the app.
- Details show the exact selected product, USD price, rating, photo gallery,
  size options, full-screen photo zoom, Share and sticky Add to Cart.
- Global CartBloc: live badge, per-size quantities, remove and Clear All.
- Registration, validation, login/profile and SQLite session storage remain in the same app.
- Native deep link: narxoz://store/product/api_88. Web route: #/product/api_88.

## Photo Journal

Open Photo Journal in the bottom bar, then take a photo with Front or Rear, or
choose a photo from Gallery. Select Fetch GPS, enter a caption, and save the entry.
Entries include the photo, time, coordinates, altitude and accuracy. They are
saved in local SQLite storage and also appear in the signed-in profile.

For Android Emulator, stop the virtual device before editing it in **Device
Manager → Edit → Additional settings**. Assign **Webcam0** to both **Front**
and **Rear**, then start the device and allow camera access inside SneakShop.
If both virtual cameras use Webcam0, they capture the same physical camera.
Set the emulator's location in **Extended Controls → Location** to test GPS.

On the web, open through localhost or HTTPS and allow camera and location
permissions in the browser. With a single webcam, both selections can use that
camera. Keep the same local port and browser profile to reopen saved entries.

## Network catalog

`ProductService` performs direct GET requests to:

- https://dummyjson.com/products/category/mens-shoes
- https://dummyjson.com/products/category/womens-shoes

SneakShop reads the product catalog from DummyJSON.
Product metadata and photos are fetched from that service. No local product list or
bundled JSON is used as fallback. Prices remain in USD; no exchange rate is invented.
The API does not supply size inventory, so the existing selectable EU size options
remain store configuration. This app does not process real orders or payments.

Loading → success → error with Retry Connection are explicit catalog states.
Connectivity changes to “none” clear the visible catalog immediately and invalidate
in-flight responses. Restoring a network triggers a fresh request. Wi-Fi availability
alone is not proof of internet; HTTP errors and a 10-second timeout are still handled.

## Refresh, swipe and reset

Pull down in either view or press Refresh. A real HTTP reload runs alongside a
minimum 1.5-second delay. The next unseen server product is prepended at index 0.
The existing products are updated from the response without duplicate IDs.
Once all products from the server have been loaded, refresh updates the existing
collection instead of inventing duplicate products. New server products can appear
at the top on later refreshes.

Swipe right-to-left in List view to hide a product. UNDO restores its original
index. A reload invalidates stale UNDO actions. When the catalog is empty,
Reset Catalog performs a fresh network request and restores the first six products.

## Check offline behavior

1. Open the app online and wait for the collection.
2. On Android, disable mobile data AND Wi-Fi. Airplane Mode may leave Wi-Fi enabled.
3. The main catalog shows an offline error when the platform reports no connection.
4. Restore the connection; the app requests the collection again. Retry also works manually.
5. In Chrome: F12 → Network → Offline. If the browser does not emit an offline event,
   press Refresh inside the app. Restore No throttling and press Retry Connection.
6. Selected cart/favorite objects are restored from local storage after restart; their cards are
   not substitutes for a successful Home catalog request.

## Checks

```sh
flutter analyze
flutter test
flutter build web
```

On Windows, `.\check_project.ps1` runs all these checks after `flutter pub get`.

Run the checks above after updating dependencies.


## Account and shopping state

Register or sign in from Profile. After signing in, the app opens the catalog.
Accounts are stored locally in SQLite. AuthCubit handles the asynchronous login
states. CartBloc receives add, remove and clear events and shares the current
selections, count and total across screens.

Open Notes from the top bar to manage your display name, theme and notes.
The app stores these settings, favorites and shopping selections on the device.
