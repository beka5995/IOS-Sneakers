# Future features — Sneakers Store

**Planning document only.** The current application implements the catalog, product details, cart, favorites, registration form, navigation and list interactions. The three features below are for the final stages of the semester, after the basic mobile UI is complete.

## 1. Smart Lock Price — exactly 30 days

- A signed-in customer locks the current price of a selected product.
- Record at least: user ID, product ID, locked price (tenge), start time (UTC), expiry time (UTC) and status.
- Expiry time is exactly 30 days after the lock starts; expiration and final checkout price are checked by the **server**, not just the phone's clock.
- While the lock is active, a higher normal price does not change the reserved price. After expiration, the saved price is no longer available.
- The UI will include a reserve button, a list of active reservations and remaining time.

## 2. Maximum of three active price reservations

- A customer can hold at most **three active, non-expired** reservations simultaneously.
- Before making a fourth, they must complete a purchase, cancel a reservation or let one expire.
- The backend must check this limit in one atomic transaction to avoid bypassing it with multiple devices.
- The UI will show the available reservation slots, for example `2 / 3 used`.

## 3. Admin Special Offer

- An admin creates an offer in a separate admin panel (global or targeted to one user).
- The mobile app requests applicable offers from the REST API when the customer enters the main menu.
- An active applicable offer appears as a popup/banner in the app.
- The backend will keep the discount rules, eligibility, expiration and read/dismissed status to prevent repeated unwanted popups.

## When to implement them

1. **Now:** finish and test the product catalog, detail page, navigation, registration and touch interactions.
2. **Next course topics:** connect REST APIs and real login, add a database, migrate shared state to BLoC.
3. **Final capstone stage:** add price reservation logic, three-reservation rule and the admin offer flow, with backend validation and tests.

No reservation, admin offer or pricing feature is implemented in this version.
