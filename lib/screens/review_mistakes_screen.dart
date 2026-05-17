import 'package:flutter/material.dart';

import '../data/aqeedah_questions.dart';
import '../models/aqeedah_question.dart';
import '../services/language_service.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/premium_card.dart';
import '../widgets/premium_scaffold.dart';
import 'quiz_screen.dart';

class ReviewMistakesScreen extends StatefulWidget {
  const ReviewMistakesScreen({super.key});

  @override
  State<ReviewMistakesScreen> createState() => _ReviewMistakesScreenState();
}

class _ReviewMistakesScreenState extends State<ReviewMistakesScreen> {
  late Future<List<AqeedahQuestion>> _mistakesFuture;

  @override
  void initState() {
    super.initState();
    _mistakesFuture = _loadMistakes();
  }

  Future<List<AqeedahQuestion>> _loadMistakes() async {
    final progress = await ProgressService.load();
    final ids = progress.wrongQuestionIds.toSet();
    return prioritizeAqeedahQuestions(aqeedahQuestions.where((q) => ids.contains(q.id)));
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: context.t('Review Mistakes'),
      subtitle: context.t('Relearn questions you missed'),
      child: FutureBuilder<List<AqeedahQuestion>>(
        future: _mistakesFuture,
        builder: (context, snapshot) {
          final mistakes = snapshot.data ?? <AqeedahQuestion>[];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.gold));
          }

          if (mistakes.isEmpty) {
            return Center(
              child: PremiumCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, size: 54, color: AppTheme.correct),
                    const SizedBox(height: 12),
                    Text(context.t('No saved mistakes yet.'), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      context.t('When you answer incorrectly, the question will appear here for revision.'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            children: [
              AppButton(
                label: context.t('Start Mistake Review'),
                icon: Icons.school_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        customQuestions: mistakes,
                        titleOverride: 'Mistake Review',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              ...mistakes.map(
                (q) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.t(q.category), style: const TextStyle(color: AppTheme.softGold, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text(context.t(q.question), style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(context.isBangla ? 'সঠিক: ${context.t(q.correctAnswer)}' : 'Correct: ${q.correctAnswer}', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
