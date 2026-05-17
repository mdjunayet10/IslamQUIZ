import 'package:flutter/material.dart';

import '../models/aqeedah_question.dart';
import '../services/language_service.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/premium_card.dart';
import '../widgets/premium_scaffold.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  final int correct;
  final int total;
  final List<String> wrongIds;
  final String? category;
  final List<AqeedahQuestion>? reviewedQuestions;
  final bool progressAlreadySaved;

  const ResultScreen({
    super.key,
    required this.correct,
    required this.total,
    required this.wrongIds,
    this.category,
    this.reviewedQuestions,
    this.progressAlreadySaved = false,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;
  Future<ProgressSnapshot>? _progressFuture;

  @override
  void initState() {
    super.initState();
    _save();
  }

  Future<void> _save() async {
    if (!widget.progressAlreadySaved) {
      await ProgressService.recordQuiz(correct: widget.correct, total: widget.total);
    }
    if (mounted) {
      setState(() {
        _saved = true;
        _progressFuture = ProgressService.load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = widget.total == 0 ? 0 : (widget.correct / widget.total * 100).round();
    final xp = widget.correct * 10;

    return PremiumScaffold(
      title: context.t('Quiz Result'),
      subtitle: _saved ? context.t('Progress saved locally') : context.t('Saving progress...'),
      child: ListView(
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                Container(
                  width: 108,
                  height: 108,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [AppTheme.gold, AppTheme.softGold]),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.gold.withOpacity(0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Text(
                    '$percent%',
                    style: const TextStyle(
                      color: AppTheme.midnight,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(context.isBangla ? 'আপনার স্কোর ${widget.correct}/${widget.total}' : 'You scored ${widget.correct}/${widget.total}', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(context.isBangla ? 'অর্জিত XP: $xp' : 'XP earned: $xp', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.softGold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _MiniResult(label: context.t('Correct'), value: '${widget.correct}', color: AppTheme.correct)),
              const SizedBox(width: 12),
              Expanded(child: _MiniResult(label: context.t('Wrong'), value: '${widget.total - widget.correct}', color: AppTheme.wrong)),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<ProgressSnapshot>(
            future: _progressFuture,
            builder: (context, snapshot) {
              final progress = snapshot.data;
              return PremiumCard(
                child: Row(
                  children: [
                    const Icon(Icons.shield_rounded, color: AppTheme.softGold),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        progress == null
                            ? (context.isBangla ? 'এই ডিভাইসে প্রগ্রেস সংরক্ষিত।' : 'Progress saved on this device.')
                            : (context.isBangla ? 'লেভেল ${progress.level} • ${progress.totalXp} XP • ${progress.completedQuizzes}টি সম্পন্ন কুইজ' : 'Level ${progress.level} • ${progress.totalXp} XP • ${progress.completedQuizzes} completed quizzes'),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          AppButton(
            label: context.t('Restart Quiz'),
            icon: Icons.restart_alt_rounded,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    category: widget.category,
                    customQuestions: widget.reviewedQuestions,
                    titleOverride: widget.reviewedQuestions == null ? null : 'Mistake Review',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            label: context.t('Back to Home'),
            icon: Icons.home_rounded,
            secondary: true,
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}

class _MiniResult extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniResult({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
