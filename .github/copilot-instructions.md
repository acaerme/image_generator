<!-- Copilot instructions — image_generator
Short, actionable guidance for AI coding agents working on this repository.

Overview
- Single-module Flutter app. Entry: `lib/main.dart`.
- Core UX: Prompt -> Generate -> Result. Navigation is implemented with Navigator 2.0 (custom `AppRouterDelegate` + `AppRouteParser`) and is driven by a single `PromptBloc` (flutter_bloc).

Read-first (fast path)
- `lib/navigation/app_router.dart` — RouterDelegate listens to `PromptBloc` and composes the page stack. See how it maps `PromptLoading`/`PromptResult` -> result page.
- `lib/bloc/prompt_bloc.dart` — single source of truth for navigation and generation: events (`GeneratePrompt`, `PopResult`) and states (`PromptInitial`, `PromptLoading`, `PromptResult`).
- `lib/screens/prompt_screen.dart` and `lib/screens/result_screen.dart` — UI patterns (responsive ConstrainedBox, lifecycle/dispose, BlocBuilder usage).

Key patterns & important notes
- Router ↔ Bloc coupling: navigation state mirrors `PromptBloc`. Do not mutate Navigator stack without emitting the corresponding Bloc event/state. `AppRouterDelegate` listens to `promptBloc.stream` and calls `notifyListeners()`.
- Lifecycle discipline: create and dispose router and bloc in `MyApp` (`routerDelegate.dispose()` and `promptBloc.close()` in `dispose`). Dispose controllers (example: `_controller.dispose()` in `PromptScreen`) and subscriptions (`promptSub.cancel()` in `AppRouterDelegate`).
- Responsive layout: cap width with a `ConstrainedBox`; compute `maxContentWidth` from `MediaQuery` (see both screens for the pattern).
- UI state handling: use `BlocBuilder<PromptBloc, PromptState>` to render loading / result / empty states. `ResultScreen` reads `state.imagePath` when `PromptResult` is active.
- Assets: images live under `assets/images/` and are declared in `pubspec.yaml` (no per-file listing required for that folder).

Developer workflows (concrete commands)
- Install deps: run `flutter pub get` at repo root after any `pubspec.yaml` change.
- Run locally: `flutter run` (or `flutter run -d <deviceId>`). Use `r` for hot reload.
- Static checks & tests: `flutter analyze` and `flutter test`.
- Build: `flutter build <platform>` (e.g. `apk`, `web`, `macos`).

Project conventions (what agents should follow)
- Keep navigation changes and bloc updates in sync. If you add a route or new navigation event, update `AppRouteParser.setNewRoutePath` and `PromptBloc` accordingly.
- Reuse the responsive container pattern from `PromptScreen` / `ResultScreen` for new screens.
- Prefer `Bloc` for state and side-effects (network or long-running ops). `PromptBloc` is the example pattern to follow.
- Avoid committing native secrets (`local.properties`, signing files) — they exist but are intentionally local.

Files to inspect when editing behavior
- `lib/main.dart` — app bootstrap, bloc/router wiring.
- `lib/navigation/app_router.dart` — page stack & deep-link mapping.
- `lib/bloc/prompt_bloc.dart` — event/state transitions and async mock API call.
- `lib/screens/prompt_screen.dart`, `lib/screens/result_screen.dart` — primary UI patterns and examples.
- `lib/services/mock_api.dart` — example service layer used by the bloc.

PR & QA checklist for agents
- Run `flutter analyze` and `flutter test` before opening a PR. Fix analyzer errors.
- Keep PRs small and focused (one screen/feature/bugfix per PR). For navigation changes include a short screen recording or screenshots.

Where to add small improvements
- Add unit tests for `PromptBloc` transitions (happy path + error path).
- Add widget tests for `PromptScreen` to assert button dispatches `GeneratePrompt` and shows loading state.

If anything here is unclear or you'd like more examples (test templates, CI config, or a PR checklist), tell me which section to expand and I'll iterate.
-->
