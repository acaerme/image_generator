import 'dart:async';
import 'package:flutter/material.dart';
import '../bloc/prompt_bloc.dart';
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
    final uri = routeInformation.uri;
    if (uri.pathSegments.contains('result')) {
      return AppRoutePath.result();
    }
    return AppRoutePath.home();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isResult) {
      return RouteInformation(uri: Uri(path: '/result'));
    }
    return RouteInformation(uri: Uri(path: '/'));
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final PromptBloc promptBloc;
  late final StreamSubscription promptSub;

  AppRouterDelegate(this.promptBloc) : navigatorKey = GlobalKey<NavigatorState>() {
    promptSub = promptBloc.stream.listen((state) => notifyListeners());
  }

  @override
  void dispose() {
    promptSub.cancel();
    super.dispose();
  }

  bool get _showResult =>
      promptBloc.state is PromptResult || promptBloc.state is PromptLoading || promptBloc.state is PromptError;

  @override
  AppRoutePath get currentConfiguration => _showResult ? AppRoutePath.result() : AppRoutePath.home();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: PromptScreen()),
        if (_showResult) MaterialPage(child: ResultScreen()),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        promptBloc.add(PopResult());
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    if (!configuration.isResult) {
      promptBloc.add(PopResult());
    }
  }
}
