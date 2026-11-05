import 'package:flutter/material.dart';
import 'package:trovemart_app/core/shared_widgets/tm_button.dart';

/// Consistent error state display with optional retry action.
class TmErrorState extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final String retryLabel;

  const TmErrorState({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.retryLabel = 'Try again',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              TmButton(
                text: retryLabel,
                onPressed: onRetry,
                variant: TmButtonVariant.primary,
                isFullWidth: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}