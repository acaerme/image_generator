import 'dart:async';
import 'dart:math';

/// MockApi: lightweight, local service that simulates image generation.
/// - Contract: `generate(String prompt) -> Future<String>` returning a local asset path (e.g. `assets/images/example_1.jpg`).
/// - Behavior: simulates delay and occasional failure for development/testing; keep this shape when replacing with a real API.
class MockApi {
  static Future<String> generate(String prompt) async {
    final delayMs = 2000 + Random().nextInt(1001);
    await Future.delayed(Duration(milliseconds: delayMs));

    final failed = Random().nextBool();
    if (failed) {
      throw Exception('Mock API failure: simulated transient error');
    }

    final lower = prompt.trim().toLowerCase();
    const ex1 = 'cozy desktop workspace by a window, warm lamp light, plants, shallow depth of field';
    const ex2 = 'soft clouds over rolling hills at golden hour, high dynamic range, wide angle';
    const ex3 = 'serene river flowing through a forest, misty morning, photorealistic';

    if (lower == ex1) {
      return 'assets/images/example_1.jpg';
    }
    if (lower == ex2) {
      return 'assets/images/example_2.jpg';
    }
    if (lower == ex3) {
      return 'assets/images/example_3.jpg';
    }

    if (lower.contains('cloud') || lower.contains('clouds') || lower.contains('sky')) {
      return 'assets/images/example_2.jpg';
    }
    if (lower.contains('river') || lower.contains('stream') || lower.contains('water')) {
      return 'assets/images/example_3.jpg';
    }
    if (lower.contains('desktop') || lower.contains('desk') || lower.contains('workspace') || lower.contains('cozy')) {
      return 'assets/images/example_1.jpg';
    }

    return 'assets/images/generated_image.jpg';
  }
}
