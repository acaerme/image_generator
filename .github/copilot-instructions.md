<!-- Copilot instructions — image_generator

Condensed, repo-specific guidance for AI coding agents working on this Flutter app.

Quick overview
- Single-module Flutter app. Entrypoint: `lib/main.dart`.
- Primary flow: Prompt -> Generate -> Result. Navigation is implemented with Navigator 2.0 (custom `AppRouterDelegate` + `AppRouteParser`) and is driven by a single `PromptBloc` (flutter_bloc).

Read-first (fast path)
- `lib/navigation/app_router.dart` — RouterDelegate composes pages from `PromptBloc` state (watch how `PromptLoading`/`PromptResult` map to pages).
- `lib/bloc/prompt_bloc.dart` — single source of truth for generation and navigation events/states.
- `lib/screens/prompt_screen.dart` & `lib/screens/result_screen.dart` — UI patterns: responsive container, lifecycle disposal, `BlocBuilder` usage.

Important patterns & rules (do not ignore)
- Router ↔ Bloc coupling: the navigation stack is a projection of `PromptBloc` state. Never mutate Navigator directly without emitting the corresponding Bloc event/state. See `AppRouterDelegate` subscription to `promptBloc.stream`.
- Lifecycle: create and dispose `routerDelegate` and `promptBloc` in `MyApp` (`dispose()` calls exist in `lib/main.dart`). Dispose controllers and subscriptions (examples: `_controller.dispose()` in `PromptScreen`, `promptSub.cancel()` in `AppRouterDelegate`).
- Responsive layout: constrain content width with a `ConstrainedBox` and use `MediaQuery`-derived `maxContentWidth` (pattern shown in both screens).
- State handling: UI reads `PromptBloc` states — `ResultScreen` expects `PromptResult.imagePath` to display the generated image.
- Assets: put generated/static images under `assets/images/` and reference them via `pubspec.yaml`.

Developer workflows (concrete commands)
- Install deps: `flutter pub get` at repo root after updating `pubspec.yaml`.
- Run locally: `flutter run` (or `flutter run -d <deviceId>`). Use `r` for hot reload.
- Static checks & tests: `flutter analyze` and `flutter test`.
- Build: `flutter build <platform>` (e.g. `apk`, `web`, `macos`).

Conventions and project-specific guidance
- Follow the existing Bloc-driven navigation: adding routes requires updates in `AppRouteParser.setNewRoutePath` and `PromptBloc` so deeplinks and back navigation stay consistent.
- Prefer adding small, focused tests: unit tests for `PromptBloc` (happy & error paths) and widget tests for `PromptScreen` interactions.
- Keep PRs minimal. For navigation changes include a short screencast or screenshots showing back/forward behavior.

Key files to inspect when making changes
- `lib/main.dart` — app bootstrap, wiring of router & bloc.
- `lib/navigation/app_router.dart` — page stack, deep-link mapping, router delegate implementation.
- `lib/bloc/prompt_bloc.dart` — events, states, and async generation flow (calls `lib/services/mock_api.dart`).
- `lib/screens/prompt_screen.dart` & `lib/screens/result_screen.dart` — UI structure, layout, and Bloc usage.
- `lib/services/mock_api.dart` — mocked service used by the bloc; replace/extend for real APIs.

PR checklist for agents
- Run `flutter analyze` and `flutter test` locally; fix new analyzer errors.
- Update `AppRouteParser` + `PromptBloc` together when changing navigation.
- Add tests for new logic and keep changes scoped to a single feature where possible.

Where to add small improvements
- Add unit tests for `PromptBloc` transitions (happy/error paths).
- Add widget tests for `PromptScreen` to validate button dispatches and loading UI.

If any of the above is unclear or you want example test templates or CI steps, tell me which section to expand and I will iterate.
-->
