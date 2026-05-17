import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class QuestionOptionCard extends StatelessWidget {
  final String option;
  final int index;
  final bool isLocked;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  const QuestionOptionCard({
    super.key,
    required this.option,
    required this.index,
    required this.isLocked,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showCorrect = isLocked && isCorrect;
    final showWrong = isLocked && isSelected && !isCorrect;
    final borderColor = showCorrect
        ? AppTheme.correct
        : showWrong
            ? AppTheme.wrong
            : isSelected
                ? AppTheme.gold
                : AppTheme.cardBorder;
    final fillColor = showCorrect
        ? AppTheme.correct.withOpacity(0.13)
        : showWrong
            ? AppTheme.wrong.withOpacity(0.13)
            : const Color(0x9911241C);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                fillColor,
                const Color(0x661B3A30),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.35),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(showCorrect || showWrong || isSelected ? 0.18 : 0.06),
                blurRadius: showCorrect || showWrong || isSelected ? 22 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: showCorrect
                      ? LinearGradient(colors: [AppTheme.correct, AppTheme.correct.withOpacity(0.65)])
                      : showWrong
                          ? LinearGradient(colors: [AppTheme.wrong, AppTheme.wrong.withOpacity(0.65)])
                          : const LinearGradient(colors: [AppTheme.gold, AppTheme.softGold]),
                  boxShadow: [
                    BoxShadow(
                      color: borderColor.withOpacity(0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: const TextStyle(
                    color: AppTheme.midnight,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    option,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              if (showCorrect) const Icon(Icons.check_circle_rounded, color: AppTheme.correct),
              if (showWrong) const Icon(Icons.cancel_rounded, color: AppTheme.wrong),
            ],
          ),
        ),
      ),
    );
  }
}
