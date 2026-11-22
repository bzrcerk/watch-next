import 'package:flutter/material.dart';

// R30: shown above the list only when the data came from the offline cache.
class StaleBanner extends StatelessWidget {
  const StaleBanner({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      leading: const Icon(Icons.cloud_off),
      content: const Text('Offline: showing saved results'),
      actions: [TextButton(onPressed: onRetry, child: const Text('Retry'))],
    );
  }
}
