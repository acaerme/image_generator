import 'package:flutter/material.dart';
import '../navigation/app_state.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = _controller.text.trim().isNotEmpty;

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    // For mobile-first layout prefer a max width that fits phones comfortably
    final maxContentWidth = screenWidth < 480 ? screenWidth * 0.95 : 460.0;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      // Keep resizeToAvoidBottomInset true so the body moves up for the keyboard.
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create Image'),
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
                    boxShadow: [
                      BoxShadow(color: theme.shadowColor.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 6),
                      const Text(
                        'Create an image',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Briefly describe the image you want. Be specific for better results.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 13),
                      ),
                      const SizedBox(height: 12),

                      // Preview placeholder
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.06)),
                        ),
                        child: Center(
                          child: Icon(Icons.image, size: 48, color: theme.colorScheme.onBackground.withOpacity(0.3)),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxContentWidth - 24),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'A cozy cabin in snowy mountains, warm lighting, 16:9',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              prefixIcon: const Icon(Icons.edit, size: 20),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.18)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.8),
                              ),
                            ),
                            maxLines: 4,
                            onChanged: (s) => setState(() {}),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            icon: const Icon(Icons.auto_fix_high),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('Generate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          onPressed: hasText
                              ? () {
                                  // Use the shared AppState to show the result screen via RouterDelegate
                                  final appState = AppStateScope.of(context);
                                  appState.generate(_controller.text.trim());
                                }
                              : null,
                        ),
                      ),

                      const SizedBox(height: 8),
                      if (!hasText) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Tip: add adjectives like "cinematic", "photorealistic" or an aspect ratio like "16:9"',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
