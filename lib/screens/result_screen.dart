import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prompt_bloc.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      body: Center(
        child: BlocBuilder<PromptBloc, PromptState>(builder: (context, state) {
          if (state is PromptResult) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(state.prompt, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            );
          }
          return Text('No result', style: theme.textTheme.titleLarge);
        }),
      ),
    );
  }
}
