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

    // Debug: log received prompt
    print('[MockApi] generate() prompt: "$prompt"');

    // Prefer exact-matching of known example prompts to avoid accidental keyword collisions.
    final lower = prompt.trim().toLowerCase();
    const ex1 = 'cozy desktop workspace by a window, warm lamp light, plants, shallow depth of field';
    const ex2 = 'soft clouds over rolling hills at golden hour, high dynamic range, wide angle';
    const ex3 = 'serene river flowing through a forest, misty morning, photorealistic';

    if (lower == ex1) {
      print('[MockApi] matched example_1');
      return 'assets/images/example_1.jpg';
    }
    if (lower == ex2) {
      print('[MockApi] matched example_2');
      return 'assets/images/example_2.jpg';
    }
    if (lower == ex3) {
      print('[MockApi] matched example_3');
      return 'assets/images/example_3.jpg';
    }

    // Fallback keyword mapping (less preferred). Keep as a secondary heuristic.
    if (lower.contains('cloud') || lower.contains('clouds') || lower.contains('sky')) {
      print('[MockApi] keyword matched clouds -> example_2');
      return 'assets/images/example_2.jpg';
    }
    if (lower.contains('river') || lower.contains('stream') || lower.contains('water')) {
      print('[MockApi] keyword matched river -> example_3');
      return 'assets/images/example_3.jpg';
    }
    if (lower.contains('desktop') || lower.contains('desk') || lower.contains('workspace') || lower.contains('cozy')) {
      print('[MockApi] keyword matched desk/cozy -> example_1');
      return 'assets/images/example_1.jpg';
    }

    // Default fallback
    print('[MockApi] returning generated_image');
    return 'assets/images/generated_image.jpg';
  }
}
