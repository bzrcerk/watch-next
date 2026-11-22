import 'package:flutter/material.dart';

// The screen picks the message in its exhaustive switch on ApiException;
// onRetry is null when retrying cannot help (BadResponseException).
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final retry = onRetry;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (retry != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: retry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
