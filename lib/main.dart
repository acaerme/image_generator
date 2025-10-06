import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation/app_router.dart';
import 'bloc/prompt_bloc.dart';

// App bootstrap and ownership
// - `MyApp` creates and owns the lifecycle of `PromptBloc` and `AppRouterDelegate`.
// - RouterDelegate listens to bloc state and maps it to Navigator pages (navigation-by-bloc).

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouterDelegate routerDelegate;
  late final AppRouteParser routeParser;
  late final PromptBloc promptBloc;

  @override
  void initState() {
    super.initState();
    promptBloc = PromptBloc();
    routerDelegate = AppRouterDelegate(promptBloc);
    routeParser = AppRouteParser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: promptBloc,
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
    promptBloc.close();
    super.dispose();
  }
}

