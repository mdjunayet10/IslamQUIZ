import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showGlow;

  const AppLogo({
    super.key,
    this.size = 56,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.24),
        boxShadow: [
          if (showGlow)
            BoxShadow(
              color: AppTheme.gold.withOpacity(0.25),
              blurRadius: size * 0.42,
              offset: Offset(0, size * 0.14),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/logo/islamquiz_logo.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
