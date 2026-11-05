import 'package:flutter/material.dart';

/// Trovemart brand logo.
///
/// Renders the logo asset from `assets/images/logo.png` when the file exists.
/// Falls back to a programmatic rendering of the brand mark (pink shopping
/// cart on a black rounded square — matching the supplied logo) so the brand
/// identity holds until the asset file is added.
class TmLogo extends StatelessWidget {
  final double size;

  const TmLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _FallbackLogo(size: size),
    );
  }
}

/// Programmatic fallback matching the supplied Trovemart logo:
/// pink shopping cart outline on a black rounded square.
class _FallbackLogo extends StatelessWidget {
  final double size;

  const _FallbackLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Icon(
        Icons.shopping_cart_outlined,
        size: size * 0.48,
        color: const Color(0xFFE62E5C),
      ),
    );
  }
}