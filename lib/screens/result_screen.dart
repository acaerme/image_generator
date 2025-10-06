import 'package:flutter/material.dart';

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
      ),
      body: Center(
        child: Text(
          'Placeholder',
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
