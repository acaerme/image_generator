<!--
Guidance for AI coding agents working on this repository.
Keep this short, concrete and tied to discoverable patterns in the codebase.
-->

# Copilot instructions — image_generator

Quick context
- Small, single-app Flutter project. UI and logic live under `lib/`. Entry point: `lib/main.dart` (MaterialApp -> `PromptScreen`).
- SDK and deps in `pubspec.yaml` (Dart/Flutter constraint). Lint rules in `analysis_options.yaml`.

Big-picture architecture
- One-module mobile-first app. UI screens and state are colocated in `lib/screens/` and small widgets under `lib/`.
- Navigation and data passing follow simple route pushes between `lib/screens/prompt_screen.dart` and `lib/screens/result_screen.dart`.
- No backend services in repo. If you must add network code, centralize it in `lib/services/` and add unit tests.

Developer workflows (essential commands)
- Install deps: `flutter pub get` (run at repo root).
- Run: `flutter run` or `flutter run -d <device id>` (e.g., `-d chrome` for web). Use `r` for hot reload and hot restart when needed.
- Build: `flutter build apk` | `flutter build ios` | `flutter build web` | `flutter build macos`.
- QA: `flutter analyze` (linting) and `flutter test` (unit/widget tests). Fix lints before opening a PR.

Project-specific conventions and patterns
- UI-first: screens use `MediaQuery` + `ConstrainedBox` to constrain width (see `lib/screens/prompt_screen.dart`).
- Controller lifecycle: text and animation controllers are disposed in `dispose()` (copy this pattern for new screens to avoid leaks).
- Keep widgets small and local. Add new features under `lib/features/` or `lib/widgets/` rather than reorganizing existing layout.
- Minimal external dependencies. Add packages in `pubspec.yaml` and run `flutter pub get`; include only what's necessary.

Integration points & cautions
- Platform folders (`android/`, `ios/`, `macos/`, etc.) contain native configs. Avoid editing signing/provisioning files without maintainer approval.
- Do NOT commit `local.properties`, credentials, or provisioning files. Use environment variables or platform secrets for keys.
- If you add platform channels, update both Dart and native code and document channel names in your PR.

Files to inspect when changing code
- `lib/main.dart` — app root, theme (ColorScheme.fromSeed), and initial routing; good place to wire app-wide providers.
- `lib/screens/prompt_screen.dart` — form input example (TextEditingController usage, dispose pattern, responsive layout).
- `lib/screens/result_screen.dart` — result display and navigation example.
- `pubspec.yaml` — dependencies, assets, and SDK constraints.
- `analysis_options.yaml` — lint rules to follow.

PR checklist for AI agents
- Run `flutter analyze` and resolve lints.
- Run `flutter test` and include results in the PR description.
- Keep PRs small and focused: one screen/feature or one bugfix.
- Document platform/native changes and any manual steps (e.g., Xcode signing) in the PR body.

Examples (copy patterns)
- Add a screen: create `lib/screens/new_screen.dart`, follow `PromptScreen` pattern (stateful widget, controller dispose, responsive constraints).
- Add a service: create `lib/services/my_service.dart`, export from a single file if multiple services added.

Feedback
If anything here is unclear or you want examples (PR template, commit message format, or code style rules), tell me which area to expand.
