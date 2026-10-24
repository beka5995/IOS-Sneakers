# Как убрать красные ошибки в Android Studio

Если строка `import 'package:flutter/material.dart';` подчёркнута красным,
сначала нужно проверить Flutter SDK. Это не обязательно ошибка в main.dart.

1. Открой в Android Studio именно папку `final_project_ios_sneakers` (там лежит `pubspec.yaml`), не папку `android`.
2. File → Settings → Plugins: Flutter и Dart должны быть установлены и включены.
3. File → Settings → Languages & Frameworks → Flutter: укажи путь к Flutter SDK, например `C:\src\flutter` (НЕ `C:\src\flutter\bin`).
4. Открой Terminal в корне проекта и выполни команды по очереди:

```powershell
flutter --version
flutter doctor -v
flutter pub get
flutter analyze
flutter run
```

Если команда `flutter` не найдена, настрой Flutter SDK в Android Studio и добавь `...\flutter\bin` в PATH Windows, затем перезапусти IDE.

**Изменение в этой версии:** в `pubspec.yaml` минимальная версия Dart снижена до 3.3,
старый `pubspec.lock` удалён. При `flutter pub get` зависимости установятся заново
для твоей версии Flutter (при наличии совместимого SDK и доступа к pub.dev).

Если ошибки остались, пришли вывод `flutter --version` и `flutter pub get` из терминала, а также первую ошибку из Problems.

Для iOS-сборки нужен macOS с Xcode, но писать Dart-код и запускать Android-версию можно на Windows.
