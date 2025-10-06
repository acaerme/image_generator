import 'dart:async';
import 'dart:math';

/// Simple mock API that simulates image generation.
///
/// Usage:
///   final path = await MockApi.generate(prompt);
class MockApi {
  /// Simulate a network call that takes 2-3 seconds and returns an asset path.
  ///
  /// 50% of the time this method will throw an [Exception] to simulate a
  /// transient failure. Callers should handle exceptions and surface errors
  /// to users.
  static Future<String> generate(String prompt) async {
    // Random delay between 2000 and 3000 ms
    final delayMs = 2000 + Random().nextInt(1001);
    await Future.delayed(Duration(milliseconds: delayMs));

    // 50% chance to fail
    final failed = Random().nextBool();
    if (failed) {
      throw Exception('Mock API failure: simulated transient error');
    }

    // Return the bundled image asset used by the app.
    // In a real integration this would be a remote URL or a saved file path.
    return 'assets/images/generated_image.jpg';
  }
}
