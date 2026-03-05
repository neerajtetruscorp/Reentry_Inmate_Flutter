# Copilot Instructions for care_link_pro

## Project Overview
This is a Flutter mobile application. The codebase is organized by feature, with screens in `lib/screens/`, models in `lib/models/`, and helpers in `lib/helper/`. The project targets both Android and iOS platforms, with platform-specific code in `android/` and `ios/` directories.

## Architecture & Patterns
- **Screens**: UI components are in `lib/screens/`. Each screen typically manages its own state and navigation.
- **Models**: Data structures are defined in `lib/models/`. These are used for representing and passing data between screens and services.
- **Helpers**: Utility functions and network logic are in `lib/helper/` and its subdirectories.
- **Platform Integration**: Native code and assets for Android are in `android/`, for iOS in `ios/`. Flutter communicates with native code via platform channels if needed.

## Developer Workflows
- **Build**: Use `flutter build <platform>` (e.g., `flutter build apk`, `flutter build ios`).
- **Run**: Use `flutter run` to launch the app on a connected device or emulator.
- **Test**: Run widget tests with `flutter test`. Example test file: `test/widget_test.dart`.
- **Debug**: Use Flutter DevTools or IDE debugging tools. Hot reload is supported during development.

## Conventions & Practices
- **File Naming**: Dart files use snake_case. Screens and models are named after their purpose (e.g., `login.dart`, `dashboard.dart`).
- **State Management**: Each screen manages its own state. No global state management package is present by default.
- **Navigation**: Standard Flutter navigation (`Navigator.push`, etc.) is used.
- **Assets**: Images and icons are in `web/icons/` and `ios/Runner/Assets.xcassets/`.
- **Platform Configs**: Android configs in `android/app/build.gradle`, iOS configs in `ios/Runner/Info.plist`.

## Integration Points
- **External Dependencies**: Managed via `pubspec.yaml`. Add packages here and run `flutter pub get`.
- **Platform Channels**: If you need to communicate with native code, use Flutter's platform channel APIs.

## Key Files & Directories
- `lib/main.dart`: App entry point.
- `lib/screens/`: UI screens.
- `lib/models/`: Data models.
- `lib/helper/`: Utility and network helpers.
- `test/`: Test files.
- `pubspec.yaml`: Dependency and asset management.
- `android/`, `ios/`: Platform-specific code and configs.

## Example Patterns
- To add a new screen, create a Dart file in `lib/screens/` and register it in your navigation logic.
- To add a new model, define it in `lib/models/` and import where needed.
- To add a dependency, update `pubspec.yaml` and run `flutter pub get`.

---
If any section is unclear or missing, please provide feedback to improve these instructions.