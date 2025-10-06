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
