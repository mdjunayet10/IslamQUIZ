import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/language_service.dart';
import '../theme/app_theme.dart';
import 'app_logo.dart';

class PremiumScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool showBackButton;
  final Widget? trailing;

  const PremiumScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.showBackButton = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF04100D),
              AppTheme.deepNavy,
              AppTheme.midnight,
              Color(0xFF082E24),
            ],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _PatternOverlay()),
            const _Glow(
                top: -90, left: -60, size: 230, color: Color(0x661FBF75)),
            const _Glow(
                bottom: -120, right: -70, size: 280, color: Color(0x55C9A227)),
            const _Glow(
                top: 210, right: -140, size: 230, color: Color(0x33267FFF)),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1020),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0x8811241C),
                                    AppTheme.emeraldDark.withOpacity(0.52),
                                  ],
                                ),
                                border: Border.all(
                                    color: AppTheme.gold.withOpacity(0.18)),
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.28),
                                    blurRadius: 34,
                                    offset: const Offset(0, 18),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  if (showBackButton)
                                    IconButton.filledTonal(
                                      onPressed: () =>
                                          Navigator.maybePop(context),
                                      icon:
                                          const Icon(Icons.arrow_back_rounded),
                                    )
                                  else
                                    const AppLogo(size: 50),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(context.t(title),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                        if (subtitle != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            context.t(subtitle!),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (trailing != null) ...[
                                        trailing!,
                                        const SizedBox(width: 8),
                                      ],
                                      const _LanguageToggle(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.current,
      builder: (context, language, _) {
        final isBangla = language == AppLanguage.bangla;
        return Tooltip(
          message: isBangla ? 'ইংরেজি ভাষা চালু করুন' : 'বাংলা ভাষা চালু করুন',
          child: TextButton.icon(
            onPressed: LanguageService.toggle,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.softGold,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              backgroundColor: AppTheme.gold.withOpacity(0.10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
                side: BorderSide(color: AppTheme.gold.withOpacity(0.25)),
              ),
            ),
            icon: const Icon(Icons.translate_rounded, size: 18),
            label: Text(
              isBangla ? 'English' : 'বাংলা',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        );
      },
    );
  }
}

class _PatternOverlay extends StatelessWidget {
  const _PatternOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _PatternPainter(),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppTheme.softGold.withOpacity(0.035)
      ..strokeWidth = 1;

    for (double x = -80; x < size.width + 80; x += 72) {
      canvas.drawLine(Offset(x, 0), Offset(x + 210, size.height), linePaint);
    }

    for (double y = 80; y < size.height; y += 130) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 80), linePaint);
    }

    final ringPaint = Paint()
      ..color = AppTheme.gold.withOpacity(0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(
        Offset(size.width * 0.84, size.height * 0.18), 84, ringPaint);
    canvas.drawCircle(
        Offset(size.width * 0.84, size.height * 0.18), 116, ringPaint);
    canvas.drawCircle(
        Offset(size.width * 0.16, size.height * 0.82), 72, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Glow extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;

  const _Glow({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color,
                blurRadius: 130,
                spreadRadius: 62,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
