import 'package:flutter/material.dart';

/// Offline indicator displayed when network connectivity is unavailable.
///
/// Clearly distinguishes cached information from current information
/// (Section 28).
class TmOfflineIndicator extends StatelessWidget {
  final bool isOffline;
  final String? message;

  const TmOfflineIndicator({
    super.key,
    required this.isOffline,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.warning.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            size: 16,
            color: Theme.of(context).colorScheme.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? 'You appear to be offline. Cached content may be displayed.',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}