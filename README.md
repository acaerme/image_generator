# Image Generator (Flutter)

Small single-module Flutter app that demonstrates a prompt-driven image generator UI with bloc-driven navigation.

## Quick setup

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. From the project root, fetch dependencies:

```bash
flutter pub get
```

## Run on a connected mobile device or emulator

- Android (device or emulator):

```bash
flutter run -d <deviceId>
# or simply
flutter run
```

- iOS (Mac with Xcode + device or simulator):

```bash
flutter run -d <deviceId>
```

## Run on desktop (macOS / Linux / Windows)

- macOS:

```bash
flutter run -d macos
```

- Linux:

```bash
flutter run -d linux
```

- Windows:

```bash
flutter run -d windows
```

## Run in browser (Web)

```bash
flutter run -d chrome
# or
flutter run -d web-server
```

## Static checks and tests

```bash
flutter analyze
flutter test
```

## Notes for contributors

- Navigation is driven by `PromptBloc` (see `lib/bloc/prompt_bloc.dart`). Do not call `Navigator.push`/`pop` directly — emit events and let `AppRouterDelegate` (in `lib/navigation/app_router.dart`) map states to pages.
- Mock API: `lib/services/mock_api.dart` returns `Future<String>` (asset path) and simulates delays/failures. Keep the same contract when wiring a real API or add an adapter.
- Assets: local images live under `assets/images/` and are referenced in `pubspec.yaml`.

If you need help adding platform-specific instructions (codesigning, emulators, etc.), tell me which platform and I'll expand this file.
