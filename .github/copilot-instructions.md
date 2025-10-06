<!-- Copilot instructions — image_generator

Condensed, repo-specific guidance for AI coding agents working on this Flutter app.

Quick overview
- Single-module Flutter app. Entrypoint: `lib/main.dart`.
- Primary flow: Prompt -> Generate -> Result. Navigation is implemented with Navigator 2.0 (custom `AppRouterDelegate` + `AppRouteParser`) and is driven by a single `PromptBloc` (flutter_bloc).

```markdown
<!-- Copilot instructions — image_generator (merged & trimmed)

Quick summary
- Single-module Flutter app. Entrypoint: `lib/main.dart`.
- User flow: Prompt -> Generate -> Result. Navigation is implemented with Navigator 2.0 using a custom `AppRouterDelegate` + `AppRouteParser` and driven entirely by `PromptBloc` (flutter_bloc).

Read this first (fast path)
- `lib/navigation/app_router.dart` — RouterDelegate composes the page stack from `PromptBloc` state. Look for the `promptSub` subscription which keeps Navigator in sync.
- `lib/bloc/prompt_bloc.dart` — single source of truth: events (user actions & deep links), states (PromptInitial/PromptLoading/PromptResult/PromptError), and the async generation flow (calls `lib/services/mock_api.dart`).
- `lib/screens/prompt_screen.dart` & `lib/screens/result_screen.dart` — UI patterns: constrained layout, controller disposal, and `BlocBuilder` usage.

Critical project rules (must follow)
- Router ↔ Bloc coupling: the navigation stack is a projection of `PromptBloc` state. Never manipulate Navigator directly; emit a Bloc event instead. (See `AppRouterDelegate` behavior mapping from states to pages.)
- Lifecycle: `routerDelegate` and `promptBloc` are created/disposed in `MyApp` (`lib/main.dart`). Dispose any controllers/subscriptions you add.
- Deep-linking/back navigation: when adding routes update both `AppRouteParser.setNewRoutePath` and `PromptBloc` so state and parsed routes stay consistent.

Developer workflows & commands (concrete)
- Install deps: run `flutter pub get` in repo root after editing `pubspec.yaml`.
- Run: `flutter run` or `flutter run -d <deviceId>`; press `r` for hot reload.
- Analyze & tests: `flutter analyze` and `flutter test`.
- Build: `flutter build <platform>` (e.g. `apk`, `web`, `macos`).

Integration points & conventions
- Mock API: `lib/services/mock_api.dart` — used by `PromptBloc`. Replace or extend for real APIs; keep the same async contract (returns a path to a generated image).
- Assets: generated or static images live in `assets/images/` and are referenced in `pubspec.yaml` (see `assets/images/generated_image.jpg` example).
- Navigation & state: Add UI pages by creating a new State in `PromptBloc` and mapping it to a Page in `AppRouterDelegate`. Update `AppRouteParser` for deeplink parsing.

Examples (how to change navigation safely)
- To add a new Result variant:
	- Add a new `PromptState` subclass in `lib/bloc/prompt_bloc.dart`.
	- Map that state to a `Page` in `lib/navigation/app_router.dart`.
	- Update `AppRouteParser.setNewRoutePath` to parse the new deeplink and emit a corresponding `PromptEvent`.

Files worth inspecting (quick links)
- `lib/main.dart` — app bootstrap and disposal.
- `lib/navigation/app_router.dart` — router delegate, page mapping, `promptSub`.
- `lib/bloc/prompt_bloc.dart` — events/states and generation flow.
- `lib/screens/prompt_screen.dart`, `lib/screens/result_screen.dart` — UI & Bloc usage.
- `lib/services/mock_api.dart` — mocked backend contract.

PR checklist for agents
- Run `flutter analyze` and `flutter test` after changes.
- Update `AppRouteParser` and `PromptBloc` together for any navigation change.
- Keep tests small: unit tests for `PromptBloc` transitions (happy & error) and widget tests for `PromptScreen` interactions.

If something here is unclear or you want short test templates / CI snippets, tell me which part to expand.
-->

```
