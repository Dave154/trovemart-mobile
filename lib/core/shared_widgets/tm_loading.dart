import 'package:flutter/material.dart';

/// Consistent loading indicator used across the app.
///
/// Respects reduced-motion preferences (animations still run but can be
/// simplified by the platform).
class TmLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const TmLoadingIndicator({
    super.key,
    this.size = 36,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation(
            color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Full-page loading state with optional message.
class TmLoadingPage extends StatelessWidget {
  final String? message;

  const TmLoadingPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TmLoadingIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}