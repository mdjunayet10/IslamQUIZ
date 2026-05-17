import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool secondary;

  const AppButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: secondary
              ? null
              : const LinearGradient(
                  colors: [AppTheme.gold, AppTheme.softGold],
                ),
          color: secondary ? AppTheme.emeraldDark.withOpacity(0.78) : null,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: secondary ? AppTheme.cardBorder : AppTheme.softGold.withOpacity(0.6),
          ),
          boxShadow: [
            if (!secondary)
              BoxShadow(
                color: AppTheme.gold.withOpacity(0.24),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: secondary ? AppTheme.softGold : AppTheme.midnight),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              label,
              style: TextStyle(
                color: secondary ? AppTheme.text : AppTheme.midnight,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ),
    );
  }
}
