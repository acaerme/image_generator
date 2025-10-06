<!-- Short, actionable guidance for AI coding agents working on this repository. -->
# Copilot instructions — image_generator

Overview
- Single-module Flutter app. Entrypoint: `lib/main.dart`.
- Core UX flow: Prompt -> Generate -> Result. Navigation uses Navigator 2.0 (RouterDelegate + RouteInformationParser). State and navigation signaling are driven by a single `PromptBloc` (flutter_bloc).

Fast reading order (start here)
- `lib/navigation/app_router.dart` — RouterDelegate listens to `PromptBloc` and builds the page stack (home + optional `ResultScreen`). See `AppRouterDelegate` for how navigation is triggered from bloc events.
- `lib/bloc/prompt_bloc.dart` — Events: `GeneratePrompt`, `PopResult`. States: `PromptInitial`, `PromptLoading`, `PromptResult`.
- `lib/screens/prompt_screen.dart` — Text input and generate button; dispatches `GeneratePrompt`.
- `lib/screens/result_screen.dart` — Shows `assets/images/generated_image.jpg` when `PromptResult` is active; back button dispatches `PopResult`.

Concrete examples & important patterns
- Router lifecycle: `AppRouterDelegate` + `AppRouteParser` are created in `lib/main.dart` and must be disposed in `MyApp.dispose()` (call `routerDelegate.dispose()` and `promptBloc.close()`).
- Router <-> Bloc coupling: the RouterDelegate listens to `promptBloc.stream` and calls `notifyListeners()` on changes. When adding navigation-related events, update both `PromptBloc` and `AppRouterDelegate`.
- UI state rendering: use `BlocBuilder<PromptBloc, PromptState>` to show loading and result states (see `PromptScreen` and `ResultScreen`).
- Responsive UI convention: cap content width with a `ConstrainedBox` and compute `maxContentWidth` using `MediaQuery` (both screens follow this pattern).
- Dispose everything: always `dispose()` controllers, subscriptions and blocs (examples: `_controller.dispose()` in `PromptScreen`, `promptSub.cancel()` in `AppRouterDelegate.dispose()`).

Developer workflows (commands you will run)
- Install dependencies: `flutter pub get` (from repo root).
- Run locally: `flutter run` or `flutter run -d <deviceId>` (e.g. `-d chrome`). Use `r` for hot reload.
- Static checks & tests: `flutter analyze` and `flutter test`.
- Build for release: `flutter build <platform>` (e.g. `apk`, `web`, `macos`).

Files & places to check when changing behavior
- Routing & bootstrap: `lib/main.dart`, `lib/navigation/app_router.dart`.
- State & business logic: `lib/bloc/prompt_bloc.dart`.
- UI: `lib/screens/prompt_screen.dart`, `lib/screens/result_screen.dart`.
- Assets: `assets/images/` (project includes `generated_image.jpg` referenced by `ResultScreen`).
- Lints & config: `analysis_options.yaml`, `pubspec.yaml` (deps include `flutter_bloc`, `bloc`, `equatable`).

Integration points & gotchas (discovered from code)
- Deep links: `AppRouteParser` maps `/result` to a result route. If you add deep-linking support, make sure `PromptBloc` can accept external navigation events or extend `setNewRoutePath`.
- Assets: `assets/images/` is declared in `pubspec.yaml`. Adding images under this folder does not require changing pubspec unless you add a different path.
- Navigation design decision: navigation state is not stored in Navigator alone — it mirrors `PromptBloc` state. Do not update the page stack without updating the bloc's state transitions.
- Do not commit native platform secrets: `local.properties` and platform signing files should not be committed.

PR & QA checklist for agents
- Run `flutter analyze` and fix analyzer errors before opening a PR.
- Run `flutter test` and include the output in the PR description.
- Keep PRs small and focused (one screen/feature/bugfix per PR). For navigation changes, include a short recording or screenshots demonstrating the flow.

Where to add tests or small improvements
- Unit-test `PromptBloc` transitions (happy path: Generate -> Loading -> Result; pop -> Initial).
- Add widget tests for `PromptScreen` to assert that generate button dispatches the event and shows loading UI.

If something is unclear or you want deeper examples (tests, CI steps, PR templates), tell me what to add and I will iterate.
<!-- Short, actionable guidance for AI coding agents working on this repository. -->
# Copilot instructions — image_generator

Quick context
- Single-module Flutter app (entry: `lib/main.dart`). Core flow: prompt -> generate -> show result.
- Uses Navigator 2.0 (RouterDelegate + RouteInformationParser) and `flutter_bloc` for state & navigation signaling.

Essential architecture (what to read first)
- Navigation: `lib/navigation/app_router.dart` (Bloc-driven).
  - Navigation is driven by `PromptBloc` state; `AppRouterDelegate` listens to the bloc stream and shows `ResultScreen` when state is `PromptResult`.
  - `AppRouterDelegate` + `AppRouteParser` are created in `lib/main.dart` and must be disposed in `MyApp.dispose()`.
- UI: screens live under `lib/screens/`. `PromptScreen` is the pattern for responsive layout (uses `MediaQuery` + `ConstrainedBox`) and controller lifecycle.
- State & async: `lib/bloc/prompt_bloc.dart` contains the existing bloc pattern — prefer extending/using it for async prompt/image generation.

Developer workflows (concrete commands)
- Install dependencies: `flutter pub get` at repo root after updating `pubspec.yaml`.
- Run app locally: `flutter run` or `flutter run -d <device id>` (e.g. `-d chrome`). Use `r` for hot reload.
- Static checks & tests: `flutter analyze` and `flutter test`. CI expects no analyzer errors.
- Build for release: `flutter build <platform>` (e.g. `apk`, `web`, `macos`).

Project conventions & gotchas (repo-specific)
- Responsive layout: cap content width with `ConstrainedBox` (see `PromptScreen`) — follow the same pattern for new screens.
- Lifecycle discipline: always `dispose()` controllers and router/state objects to avoid leaks (examples: `_controller.dispose()` in `PromptScreen`, `routerDelegate.dispose()` and `promptBloc.close()` in `MyApp.dispose()`).
- State access pattern: use `Bloc` (`context.read<PromptBloc>()` / `BlocBuilder`) for state and navigation decisions. The RouterDelegate listens to bloc state changes.
- File organization: widgets → `lib/widgets/`, screens → `lib/screens/`, services → `lib/services/`, blocs → `lib/bloc/`.

Integration points & external dependencies
- Check `pubspec.yaml` before adding packages. After adding, run `flutter pub get` and `flutter analyze`.
- Do not commit `local.properties` or platform signing files. Native folders (`android/`, `ios/`, `macos/`) contain sensitive config.

Editing navigation or routing
- Any route/state change must keep the `PromptBloc` and `app_router.dart` in sync. RouterDelegate reflects `PromptBloc` state (push/pop based on `PromptResult` and `PopResult`).
- Preserve listeners and `dispose()` calls when changing lifetime or wiring to avoid memory leaks.

Files to check when modifying behavior
- `lib/main.dart` — app bootstrap and Router wiring
- `lib/navigation/app_router.dart` — page stack logic
- `lib/screens/prompt_screen.dart` and `lib/screens/result_screen.dart` — UI flow examples
- `lib/bloc/prompt_bloc.dart` — async prompt handling
- `pubspec.yaml`, `analysis_options.yaml` — dependencies and lint rules

PR & QA checklist for agents
- Run `flutter analyze` and fix any new analyzer errors.
- Run `flutter test` and include results in PR description.
- Keep changes small and focused (one screen/feature/bugfix per PR).

If anything in these instructions is unclear or you want more examples (tests, PR template, reviewer checklist), tell me what to add.
