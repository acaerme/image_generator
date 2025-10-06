import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prompt_bloc.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use Material + InkWell so taps are visually apparent (ripple) and accessibility
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: theme.colorScheme.primary.withOpacity(0.16),
        highlightColor: theme.colorScheme.primary.withOpacity(0.06),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
          ),
          child: Text(label, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String asset;
  final String title;
  final VoidCallback onUse;

  const _ExampleCard({required this.asset, required this.title, required this.onUse});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onUse,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(asset, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.black.withOpacity(0.18), Colors.black.withOpacity(0.04)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onUse,
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Use'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Prompt screen: UI for entering a text prompt, picking example prompts, and applying quick suggestion chips.
// - Small sub-widgets (`_SuggestionChip`, `_ExampleCard`) are used to keep the layout modular.
// - `_applySuggestion` appends the suggestion to the TextField; `_applyExample` replaces the text with a full example.
class _PromptScreenState extends State<PromptScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applySuggestion(String suggestion) {
    final current = _controller.text.trim();
    final newText = current.isEmpty ? suggestion : '$current, $suggestion';
    _controller.text = newText;
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: newText.length));
    setState(() {});
  }

  void _applyExample(String example) {
    _controller.text = example;
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: example.length));
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = _controller.text.trim().isNotEmpty;

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth < 480 ? screenWidth * 0.95 : 460.0;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
          child: Text('Prompt', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
        ),
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
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: theme.shadowColor.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6)),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer.withOpacity(0.9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Create an image', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Text('Describe what you want and we’ll try to generate it.', style: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.9), fontSize: 12)),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                              child: Icon(Icons.photo_camera, color: theme.colorScheme.onPrimary, size: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _SuggestionChip(label: 'cinematic', onTap: () => _applySuggestion('cinematic')),
                          _SuggestionChip(label: 'photorealistic', onTap: () => _applySuggestion('photorealistic')),
                          _SuggestionChip(label: '16:9', onTap: () => _applySuggestion('16:9')),
                          _SuggestionChip(label: 'vibrant colors', onTap: () => _applySuggestion('vibrant colors')),
                        ],
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 170,
                        child: PageView(
                          controller: PageController(viewportFraction: 0.86),
                          children: [
                            _ExampleCard(
                              asset: 'assets/images/example_1.jpg',
                              title: 'Cozy desktop workspace by a window, warm lamp light, plants',
                              onUse: () => _applyExample('Cozy desktop workspace by a window, warm lamp light, plants, shallow depth of field'),
                            ),
                            _ExampleCard(
                              asset: 'assets/images/example_2.jpg',
                              title: 'Soft clouds over rolling hills at golden hour',
                              onUse: () => _applyExample('Soft clouds over rolling hills at golden hour, high dynamic range, wide angle'),
                            ),
                            _ExampleCard(
                              asset: 'assets/images/example_3.jpg',
                              title: 'Serene river flowing through a forest, misty morning',
                              onUse: () => _applyExample('Serene river flowing through a forest, misty morning, photorealistic'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth - 16),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Describe what you want to see…',
                            prefixIcon: const Icon(Icons.edit, size: 20),
                            suffixIcon: _controller.text.trim().isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      _controller.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          maxLines: 4,
                          onChanged: (s) => setState(() {}),
                        ),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<PromptBloc, PromptState>(builder: (context, state) {
                          final isLoading = state is PromptLoading;
                          return ElevatedButton(
                            onPressed: (hasText && !isLoading)
                                ? () {
                                    final bloc = context.read<PromptBloc>();
                                    bloc.add(GeneratePrompt(_controller.text.trim()));
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 6,
                            ),
                            child: isLoading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.auto_fix_high),
                                      SizedBox(width: 8),
                                      Text('Generate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                          );
                        }),
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
