import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prompt_bloc.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth < 480 ? screenWidth * 0.95 : 460.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
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
                        'Result',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      // Image / Error area (uses asset added to assets/images/)
                      Center(
                        child: BlocBuilder<PromptBloc, PromptState>(builder: (context, state) {
                          // When loading, show a visually distinct loader in place of the image
                          if (state is PromptLoading) {
                            return Container(
                              width: maxContentWidth - 24,
                              height: 200,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.12),
                                    theme.colorScheme.primary.withOpacity(0.06),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text('Generating image...', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Error state: show a friendly error card with Retry
                          if (state is PromptError) {
                            return Container(
                              width: maxContentWidth - 24,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.colorScheme.error.withOpacity(0.12)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                                  const SizedBox(height: 8),
                                  Text('Something went wrong', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.onErrorContainer)),
                                  const SizedBox(height: 6),
                                  Text(state.message, textAlign: TextAlign.center, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Retry with the last known prompt if any, otherwise fall back to a default
                                          String retryPrompt = 'A cozy cabin in snowy mountains, warm lighting, 16:9';
                                          final current = context.read<PromptBloc>().state;
                                          if (current is PromptError) {
                                            // No prompt stored in error state; fall back to default
                                          } else if (current is PromptResult) {
                                            retryPrompt = current.prompt;
                                          }
                                          context.read<PromptBloc>().add(GeneratePrompt(retryPrompt));
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                          child: Text('Retry'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () => context.read<PromptBloc>().add(PopResult()),
                                        child: const Text('Back'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state is PromptResult) {
                            // Use the imagePath from state when available
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                state.imagePath,
                                width: maxContentWidth - 24,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          // Placeholder when no result is available
                          return Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.06)),
                            ),
                            child: Center(
                              child: Icon(Icons.image, size: 48, color: theme.colorScheme.onBackground.withOpacity(0.3)),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),

                      const SizedBox(height: 12),

                      // Action buttons (match Generate button style)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth - 24),
                        child: BlocBuilder<PromptBloc, PromptState>(builder: (context, state) {
                          final isLoading = state is PromptLoading;
                          // Reuse prompt if available
                          String currentPrompt = 'A cozy cabin in snowy mountains, warm lighting, 16:9';
                          if (state is PromptResult) currentPrompt = state.prompt;

                          // Error: show Retry + New prompt
                          if (state is PromptError) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.refresh),
                                    label: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.0),
                                      child: Text('Retry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 2,
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            // Retry with fallback prompt
                                            context.read<PromptBloc>().add(GeneratePrompt(currentPrompt));
                                          },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.edit),
                                    label: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.0),
                                      child: Text('New prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 2,
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            // Navigate back to prompt input by popping result state
                                            context.read<PromptBloc>().add(PopResult());
                                          },
                                  ),
                                ),
                              ],
                            );
                          }

                          // Default/result: Try another + New prompt
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  label: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text('Try another', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 2,
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          // Dispatch GeneratePrompt with the existing prompt if available.
                                          context.read<PromptBloc>().add(GeneratePrompt(currentPrompt));
                                        },
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.edit),
                                  label: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text('New prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 2,
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          // Navigate back to prompt input by popping result state
                                          context.read<PromptBloc>().add(PopResult());
                                        },
                                ),
                              ),
                            ],
                          );
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
