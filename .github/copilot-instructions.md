<!--
Guidance for AI coding agents working on this repository.
Keep this short, concrete and tied to discoverable patterns in the codebase.
-->

# Copilot instructions — image_generator

Quick context
- This is a small Flutter app scaffold (single-app project). Key entry points and files:
  - `lib/main.dart` — app entry and UI root (MaterialApp). Use this to find UI/state logic.
  - `pubspec.yaml` — project metadata, SDK requirement (Dart ^3.9.2) and dependencies.
  - `analysis_options.yaml` — lints and static-analysis rules used by the repo.
  - `test/widget_test.dart` — example test harness.
  - Platform folders: `android/`, `ios/`, `macos/`, `web/`, `windows/`, `linux/` — native build/config.

<!-- Copilot instructions for image_generator (concise, actionable) -->

# Copilot instructions — image_generator

Quick context
- Single Flutter app (UI + logic under `lib/`). Entry point: `lib/main.dart` (MaterialApp -> `PromptScreen`).
- SDK in `pubspec.yaml` (Dart/Flutter constraint) and lint rules in `analysis_options.yaml`.

Big-picture architecture
- One module app: UI and state live in `lib/`. Small screens (e.g. `lib/screens/prompt_screen.dart`) handle input and show simple UI cards.
- Platform-specific build configs live under `android/`, `ios/`, `macos/`, `web/`, `windows/`, `linux/`. Avoid editing signing/provisioning files without CI/maintainer coordination.

Concrete dev workflows (do these locally)
- Install deps: `flutter pub get` (run at repo root).
- Run locally: `flutter run` or `flutter run -d <device id>` (use `-d macos`/`-d ios` on macOS as needed).
- Build: `flutter build apk` | `flutter build ios` | `flutter build web` | `flutter build macos`.
- Tests & static analysis: `flutter test` and `flutter analyze` (follow `analysis_options.yaml`).
- Quick iteration: use hot reload (`r` in terminal or save in IDE) for UI changes; hot restart to reset state.

Project-specific patterns and examples
- UI-first, mobile-first layout: screens use `MediaQuery` and `ConstrainedBox` to cap widths (see `lib/screens/prompt_screen.dart`).
- Keep widgets small and local. New features should add folders under `lib/` (e.g. `lib/features/` or `lib/widgets/`).
- Minimal third-party dependencies; add packages in `pubspec.yaml` and run `flutter pub get`.

Integration points & cautions
- No backend or network code in repo; if you add network clients, centralize them under `lib/services/` and add tests.
- If adding platform channels, update both Dart and native (Android/iOS) sides and document channel names.
- Do NOT commit credentials, provisioning profiles, or `local.properties` contents.

Files to reference when making changes
- `lib/main.dart` — app root and theme (ColorScheme.fromSeed). Good place to wire global providers.
- `lib/screens/prompt_screen.dart` — example screen: TextField, controller lifecycle (`dispose()`), responsive layout.
- `pubspec.yaml` — add dependencies and assets here.
- `analysis_options.yaml` — follow lint rules; run `flutter analyze`.

How to behave as an AI code agent (practical rules)
1. Make minimal, focused changes. Prefer adding new files under `lib/` rather than reorganizing without maintainer approval.
2. After edits: run `flutter analyze` and `flutter test` locally and include the results in your PR description.
3. When touching native project files, call out required manual steps (signing, Xcode versions, Gradle) in the PR.
4. Never add secrets or provisioning files. Suggest env-vars or secure stores instead.

If unclear, ask the maintainer where to place features (preferred package layout, CI expectations, target platforms).

---
If you'd like, I can also add short example PR templates or code snippets for common changes (small widget, new screen, add dependency).
