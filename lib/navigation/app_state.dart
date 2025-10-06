import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Simple application navigation state used by the RouterDelegate.
class AppState extends ChangeNotifier {
  String? prompt;
  bool showResult = false;

  void generate(String promptText) {
    prompt = promptText;
    showResult = true;
    notifyListeners();
  }

  void pop() {
    if (showResult) {
      showResult = false;
      notifyListeners();
    }
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState notifier, required Widget child}) : super(notifier: notifier, child: child);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}
