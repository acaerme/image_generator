import 'package:flutter/material.dart';
import 'app_state.dart';
import '../screens/prompt_screen.dart';
import '../screens/result_screen.dart';

class AppRoutePath {
  final bool isResult;
  AppRoutePath.home() : isResult = false;
  AppRoutePath.result() : isResult = true;
}

class AppRouteParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '/');
    if (uri.pathSegments.contains('result')) {
      return AppRoutePath.result();
    }
    return AppRoutePath.home();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isResult) {
      return const RouteInformation(location: '/result');
    }
    return const RouteInformation(location: '/');
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  final AppState appState;

  AppRouterDelegate(this.appState) : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appState.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  AppRoutePath get currentConfiguration => appState.showResult ? AppRoutePath.result() : AppRoutePath.home();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: PromptScreen()),
        if (appState.showResult) MaterialPage(child: ResultScreen()),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        appState.pop();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    if (configuration.isResult) {
      appState.showResult = true;
    } else {
      appState.showResult = false;
    }
  }
}
