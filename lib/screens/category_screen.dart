import 'package:flutter/material.dart';

import '../data/aqeedah_questions.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_card.dart';
import '../widgets/premium_scaffold.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: context.t('Categories'),
      subtitle: context.t('Choose one topic and begin'),
      child: GridView.builder(
        itemCount: aqeedahCategories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.sizeOf(context).width > 760 ? 2 : 1,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: MediaQuery.sizeOf(context).width > 760 ? 3.5 : 3.1,
        ),
        itemBuilder: (context, index) {
          final category = aqeedahCategories[index];
          final count = aqeedahQuestions.where((q) => q.category == category).length;
          return PremiumCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QuizScreen(category: category)),
              );
            },
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.gold.withOpacity(0.35)),
                  ),
                  child: const Icon(Icons.auto_stories_rounded, color: AppTheme.softGold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.t(category), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(context.isBangla ? '$count প্রশ্ন' : '$count questions', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppTheme.softGold),
              ],
            ),
          );
        },
      ),
    );
  }
}
