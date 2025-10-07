<!-- Copilot instructions (concise & actionable) — image_generator -->

# Purpose
- Make an AI coding agent productive in this small Flutter app that turns text prompts into images.

## Quick read (start here)
- `lib/main.dart` — App owner: constructs and disposes `PromptBloc` and `AppRouterDelegate`.
- `lib/bloc/prompt_bloc.dart` — single source of truth for navigation and prompt lifecycle (look for `GeneratePrompt`, `PromptLoading`, `PromptResult`, `PromptError`, `PopResult`).
- `lib/navigation/app_router.dart` — maps bloc state -> Navigator pages; watch `promptSub` (stream subscription) and `AppRouteParser` for deep-link routing.
- `lib/services/mock_api.dart` — `MockApi.generate(String) -> Future<String>`: returns a local asset path under `assets/images/` and simulates delays/errors. Keep this contract when swapping services.

## Non-obvious rules & conventions
- Navigation is derived from `PromptBloc` state. Do not call `Navigator.push/pop` from screens — dispatch bloc events instead (e.g., `PopResult`).
- Adding routes/states:
  1. Add a `PromptState` variant in `lib/bloc/prompt_bloc.dart`.
  2. Map that state to a `Page` in `lib/navigation/app_router.dart` (update the `pages` list returned by `build`).
  3. Optionally update `AppRouteParser.setNewRoutePath` to support deep links.
- Ownership: `MyApp` owns lifecycle for router + bloc. Screen-local controllers (TextEditingController, PageController) must be disposed in their State (see `prompt_screen.dart`).

## Integration points & API contract
- `MockApi.generate(String prompt) -> Future<String>`: returns a local file path (e.g., `assets/images/generated_image.jpg`). When replacing with a real backend, either preserve the signature and convert remote content to a local file path, or add an adapter and update `PromptBloc` tests.
- If you extend responses (IDs, URLs, meta), update `PromptBloc` states and add unit tests under `test/` to assert transitions.

## Developer workflows (concrete commands)
- Install deps: `flutter pub get` (repo root)
- Run app: `flutter run` or `flutter run -d <deviceId>` (press `r` for hot reload)
- Static checks & tests: `flutter analyze` and `flutter test`
- Build: `flutter build apk|web|macos`

## Tests & CI hints
- Focus unit tests on `PromptBloc` transitions (happy path, loading, error). Suggested file: `test/prompt_bloc_test.dart`.
- Add a widget test for `PromptScreen` that verifies the Generate button dispatches `GeneratePrompt` when input is non-empty.
- Repo currently has no CI; a minimal GitHub Actions workflow should run `flutter analyze` and `flutter test` on PRs.

## PR checklist for agents
- Run `flutter analyze` and `flutter test` before opening PRs.
- When changing navigation/state: update `lib/bloc/prompt_bloc.dart`, `lib/navigation/app_router.dart`, and `AppRouteParser` as needed.
- Update `assets/images/` and `pubspec.yaml` when adding images.
- Dispose any new controllers/subscriptions and add unit tests when changing bloc contracts.

## Files to inspect (quick map)
- Owners & boot: `lib/main.dart`
- State & flow: `lib/bloc/prompt_bloc.dart`
- Navigation: `lib/navigation/app_router.dart` (see `promptSub`, `_showResult`, `setNewRoutePath`)
- UI examples: `lib/screens/prompt_screen.dart`, `lib/screens/result_screen.dart`
- Mock backend: `lib/services/mock_api.dart`
- Assets & deps: `pubspec.yaml` (assets declared under `assets/images/`)

If you want, I can also add: a `PromptBloc` unit test template, a small widget test, or a minimal GitHub Actions CI file — tell me which and I'll create it.
