import 'package:flutter/material.dart';
import 'navigation/app_state.dart';
import 'navigation/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppState appState;
  late final AppRouterDelegate routerDelegate;
  late final AppRouteParser routeParser;

  @override
  void initState() {
    super.initState();
    appState = AppState();
    routerDelegate = AppRouterDelegate(appState);
    routeParser = AppRouteParser();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: appState,
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerDelegate: routerDelegate,
        routeInformationParser: routeParser,
      ),
    );
  }

  @override
  void dispose() {
    routerDelegate.dispose();
    appState.dispose();
    super.dispose();
  }
}

