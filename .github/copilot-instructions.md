<!-- Updated Copilot instructions — image_generator -->

# Purpose
- Short, actionable guidance for AI coding agents working on this single-module Flutter app. Focus: navigation-by-bloc, lifecycle ownership, where to wire an image-generation API, and developer workflows.

## Fast-path (read these files first)
- `lib/main.dart` — app bootstrap; `routerDelegate` and `promptBloc` are created/disposed here.
- `lib/bloc/prompt_bloc.dart` — single source of truth for events, states and generation flow. Any navigation or flow change must touch this file.
- `lib/navigation/app_router.dart` — `RouterDelegate` composes the `Page` stack from `PromptBloc` state. See `promptSub` subscription that keeps Navigator in sync.
- `lib/services/mock_api.dart` — mock backend used by `PromptBloc`. Preserve the async contract: return `Future<String>` (path to image).
- `lib/screens/prompt_screen.dart` and `lib/screens/result_screen.dart` — UI wiring examples, controller disposal, and `BlocBuilder` usage.

## Key rules & conventions (must-follow)
- Navigation is a projection of `PromptBloc` state. Do NOT call `Navigator.push`/`pop` directly; emit `PromptEvent`s and let `AppRouterDelegate` map states → pages.
- Adding a new route/state:
  1. Add a `PromptState` case in `lib/bloc/prompt_bloc.dart`.
  2. Map that state to a `Page` in `lib/navigation/app_router.dart`.
  3. Update `AppRouteParser.setNewRoutePath` if deep-linking is required.
- Lifecycle: `MyApp` (in `main.dart`) owns `routerDelegate` and `promptBloc`. Any controllers or subscriptions added in screens must be disposed in the owning widget.
- Mock API contract: `lib/services/mock_api.dart` returns `Future<String>` containing a local asset or file path (e.g. `assets/images/generated_image.jpg`). When integrating a real API, keep the same return type or add an adapter.
- Assets: images live under `assets/images/` and are referenced from `pubspec.yaml`.

## Developer workflows & common commands
- Install deps: `flutter pub get` (run from repo root).
- Run app: `flutter run` or `flutter run -d <deviceId>`; press `r` for hot reload.
- Static checks & tests: `flutter analyze` and `flutter test`.
- Builds: `flutter build apk`, `flutter build web`, `flutter build macos`.

Note: if you change the mock API shape, update `PromptBloc` and add a small unit test under `test/` that verifies the bloc receives the expected image path string.

## Project-specific patterns & examples
- Single source of truth: `PromptBloc` represents UI states (idle, loading, success, failure). UI widgets react using `BlocBuilder` in `prompt_screen.dart` and `result_screen.dart`.
- RouterDelegate pattern: `app_router.dart` listens to `PromptBloc` (via `promptSub`) and rebuilds the `Navigator` stack. All navigation should go through bloc events, not direct Navigator calls.
- Mock backend: `mock_api.dart` simulates a generation delay and returns a `String` path. Keep the service isolated under `lib/services/` to make swapping to a real API simple.

## Integration points — where to wire real services
- Replace or wrap `lib/services/mock_api.dart` with a service that calls your image-generation API. Keep method signatures returning `Future<String>`.
- If you need to return more metadata later (URLs, IDs), add an adapter layer that maps your real response to the existing `Future<String>` contract, and evolve `PromptBloc` with tests.

## Testing & CI notes
- Unit tests should focus on `PromptBloc` transitions (happy path + error path). Add widget tests for `PromptScreen` interactions.
- CI should run `flutter analyze` and `flutter test`. Run these locally before pushing.

## Small, safe PR checklist for agents
- Run `flutter analyze` and `flutter test` and fix issues.
- For navigation/state changes: update `lib/bloc/prompt_bloc.dart`, `lib/navigation/app_router.dart`, and `AppRouteParser` if deep links are added.
- Ensure any new controllers or subscriptions are disposed.
- When changing `mock_api.dart`, keep the `Future<String>` contract or add an adapter and unit tests that assert `PromptBloc` behavior.

## Files to inspect when extending the app
- `lib/main.dart` — bootstrap & ownership of router/bloc.
- `lib/bloc/prompt_bloc.dart` — events, states, and generation flow.
- `lib/navigation/app_router.dart` — page stack mapping & `promptSub`.
- `lib/screens/prompt_screen.dart`, `lib/screens/result_screen.dart` — UI patterns & controller disposal.
- `lib/services/mock_api.dart` — mocked backend contract to preserve.

If anything here is unclear or you want templates (PromptBloc unit tests, widget tests, or CI snippets), tell me which part to expand.
