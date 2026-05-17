import 'package:flutter/material.dart';

import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/premium_card.dart';
import '../widgets/premium_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: context.t('About IslamQUIZ'),
      subtitle: context.t('Methodology and content rules'),
      child: ListView(
        children: [
          PremiumCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(size: 58),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.t('Purpose'), style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(
                        context.t('IslamQUIZ teaches foundational aqeedah through short MCQs, simple explanations, and references. The goal is to help users recognize Tawheed, Sunnah, and common belief errors.'),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _AboutCard(
            title: 'Core approach',
            icon: Icons.balance_rounded,
            text:
                'The app is based on the Qur’an, authentic Sunnah, and the understanding of the Salaf. Worship is for Allah alone. Allah’s Names and Attributes are affirmed without changing the meaning, denying, asking how, or comparing Allah to creation.',
          ),
          const SizedBox(height: 12),
          const _AboutCard(
            title: 'Simple language',
            icon: Icons.translate_rounded,
            text:
                'The questions avoid difficult words where possible. When a topic is serious, the app uses careful wording and short explanations.',
          ),
          const SizedBox(height: 12),
          const _AboutCard(
            title: 'Careful wording',
            icon: Icons.shield_rounded,
            text:
                'The app explains belief errors firmly but avoids reckless takfir or attacking individuals. It focuses on evidence, clarity, and correction.',
          ),
          const SizedBox(height: 12),
          const _AboutCard(
            title: 'Related mistake labels',
            icon: Icons.warning_amber_rounded,
            text:
                'When a result shows a mistake or group label, that label is not the correct belief. It only names the error connected to the wrong answers.',
          ),
          const SizedBox(height: 12),
          const _AboutCard(
            title: 'Review before publishing',
            icon: Icons.fact_check_rounded,
            text:
                'All religious content should be reviewed by qualified people before public release. References should be checked carefully for wording, grading, and context.',
          ),
          const SizedBox(height: 12),
          const _AboutCard(
            title: 'Local progress in v1',
            icon: Icons.lock_outline_rounded,
            text:
                'This first version saves progress only on the device. Level, XP, completed quizzes, completed questions, best score, and mistakes are stored locally.',
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;

  const _AboutCard({required this.title, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.gold.withOpacity(0.35)),
            ),
            child: Icon(icon, color: AppTheme.softGold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.t(title), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(context.t(text), style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
