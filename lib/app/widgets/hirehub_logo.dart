import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// HireHub logo — work briefcase icon inside a rounded square.
/// Clean, uses Flutter's built-in icon — no custom painter needed.
class HireHubLogo extends StatelessWidget {
  final double size;

  const HireHubLogo({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(size * 0.24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.40),
            blurRadius: size * 0.45,
            offset: Offset(0, size * 0.10),
          ),
        ],
      ),
      child: Icon(
        Icons.work_rounded,
        color: Colors.white,
        size: size * 0.52,
      ),
    );
  }
}
