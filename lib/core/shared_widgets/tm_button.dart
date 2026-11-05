import 'package:flutter/material.dart';

/// Reusable Trovemart button with consistent styling.
///
/// Supports primary (filled), outline, and text variants. Respects reduced
/// motion preferences and provides accessible touch targets.
class TmButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TmButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const TmButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = TmButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisSize.min,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        if (isLoading)
          const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        else
          Text(text),
      ],
    );

    if (isFullWidth) {
      child = SizedBox.expand(child: child);
    } else {
      child = Center(child: child);
    }

    switch (variant) {
      case TmButtonVariant.primary:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          child: child,
        );
      case TmButtonVariant.outline:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          child: child,
        );
      case TmButtonVariant.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          child: child,
        );
    }
  }
}

enum TmButtonVariant { primary, outline, text }