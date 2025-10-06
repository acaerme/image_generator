import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prompt_bloc.dart';

/// Result screen: shows loading, error, or generated image based on `PromptBloc` state.
/// - UI is composed of header, image/error area, and actions.
/// - `_promptFromState` centralizes logic to pick a retry prompt from current bloc state.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  String _promptFromState(PromptState state) {
    String defaultPrompt = 'A cozy cabin in snowy mountains, warm lighting, 16:9';
    if (state is PromptError && state.prompt.isNotEmpty) return state.prompt;
    if (state is PromptResult) return state.prompt;
    return defaultPrompt;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth < 480 ? screenWidth * 0.95 : 460.0;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
          child: Text('Result', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
        ),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Notify bloc and let RouterDelegate handle popping
            context.read<PromptBloc>().add(PopResult());
          },
        ),
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
                    boxShadow: [BoxShadow(color: theme.shadowColor.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6))],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Gradient header (mirrors PromptScreen)
                      Container(
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer.withOpacity(0.9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Result', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text('Here is what we generated for your prompt', style: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.95), fontSize: 12)),
                                ],
                              ),
                            ),
                            CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.18), child: Icon(Icons.image, color: theme.colorScheme.onPrimary, size: 18)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Image / Error area
                      Center(
                        child: BlocBuilder<PromptBloc, PromptState>(builder: (context, state) {
                          if (state is PromptLoading) {
                            return Container(
                              width: maxContentWidth - 24,
                              height: 220,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [theme.colorScheme.primary.withOpacity(0.12), theme.colorScheme.primary.withOpacity(0.06)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 52, height: 52, child: CircularProgressIndicator(strokeWidth: 4, valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary))),
                                    const SizedBox(height: 12),
                                    Text('Generating image...', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (state is PromptError) {
                            return Container(
                              width: maxContentWidth - 24,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                                  const SizedBox(height: 8),
                                  Text('Something went wrong', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.onErrorContainer)),
                                  const SizedBox(height: 6),
                                  Text(state.message, textAlign: TextAlign.center, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                                  const SizedBox(height: 12),
                                  Row(mainAxisSize: MainAxisSize.min, children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          final current = context.read<PromptBloc>().state;
                                          context.read<PromptBloc>().add(GeneratePrompt(_promptFromState(current)));
                                        },
                                      child: const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), child: Text('Retry')),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(onPressed: () => context.read<PromptBloc>().add(PopResult()), child: const Text('Back'))
                                  ])
                                ],
                              ),
                            );
                          }

                          if (state is PromptResult) {
                            return Column(
                              children: [
                                // Image with a small share button overlaid in the top-right corner
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      Image.asset(state.imagePath, width: maxContentWidth - 24, height: 220, fit: BoxFit.cover),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: SizedBox(
                                          width: 36,
                                          height: 36,
                                          child: Material(
                                            color: Colors.white,
                                            elevation: 2,
                                            shape: const CircleBorder(),
                                            child: IconButton(
                                              iconSize: 18,
                                              padding: const EdgeInsets.all(6),
                                              icon: Icon(Icons.share, color: theme.colorScheme.primary),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: const Text('Share'),
                                                    content: const Text('Image has been shared successfully.'),
                                                    actions: [
                                                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Styled prompt info
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.04))),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                                        child: Icon(Icons.text_snippet, size: 18, color: theme.colorScheme.primary),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Prompt', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: theme.textTheme.bodyLarge?.color)),
                                            const SizedBox(height: 4),
                                            Text(state.prompt, style: TextStyle(fontSize: 13, color: theme.textTheme.bodySmall?.color), maxLines: 2, overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          return Container(
                            height: 180,
                            decoration: BoxDecoration(color: theme.colorScheme.background, borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Icon(Icons.image, size: 48, color: theme.colorScheme.onBackground.withOpacity(0.3))),
                          );
                        }),
                      ),

                      const SizedBox(height: 14),

                      // Actions
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth - 24),
                        child: BlocBuilder<PromptBloc, PromptState>(builder: (context, state) {
                          final isLoading = state is PromptLoading;
                          final currentPrompt = _promptFromState(state);

                          if (state is PromptError) {
                            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: isLoading ? null : () => context.read<PromptBloc>().add(GeneratePrompt(currentPrompt)),
                                  icon: const Icon(Icons.refresh),
                                  label: const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Text('Retry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isLoading ? null : () => context.read<PromptBloc>().add(PopResult()),
                                      icon: const Icon(Icons.edit),
                                      label: const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Text('New prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
                                    ),
                                  ),
                                ],
                              )
                            ]);
                          }

                          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: isLoading ? null : () => context.read<PromptBloc>().add(GeneratePrompt(currentPrompt)),
                                icon: const Icon(Icons.refresh),
                                label: const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Text('Try another', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isLoading ? null : () => context.read<PromptBloc>().add(PopResult()),
                                    icon: const Icon(Icons.edit),
                                    label: const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Text('New prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ]);
                        }),
                      ),
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
