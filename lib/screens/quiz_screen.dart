import 'dart:math';

import 'package:flutter/material.dart';

import '../data/aqeedah_questions.dart';
import '../models/aqeedah_question.dart';
import '../services/language_service.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/premium_card.dart';
import '../widgets/premium_scaffold.dart';
import '../widgets/question_option_card.dart';
import '../widgets/reference_box.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String? category;
  final List<AqeedahQuestion>? customQuestions;
  final String? titleOverride;

  const QuizScreen({
    super.key,
    this.category,
    this.customQuestions,
    this.titleOverride,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<AqeedahQuestion> _questions;
  late final Map<String, List<_PresentedOption>> _presentedOptions;
  int _index = 0;
  int? _selectedIndex;
  int _correct = 0;
  final Set<String> _wrongIds = <String>{};
  bool _finishing = false;

  AqeedahQuestion get _current => _questions[_index];
  bool get _answered => _selectedIndex != null;

  @override
  void initState() {
    super.initState();
    if (widget.customQuestions != null) {
      _questions = prioritizeAqeedahQuestions(widget.customQuestions!);
    } else if (widget.category != null) {
      _questions = prioritizeAqeedahQuestions(
        aqeedahQuestions.where((q) => q.category == widget.category),
      );
    } else {
      _questions = prioritizeAqeedahQuestions(aqeedahQuestions);
    }

    final random = Random();
    _presentedOptions = <String, List<_PresentedOption>>{
      for (final question in _questions) question.id: _shuffleOptions(question, random),
    };
  }

  List<_PresentedOption> _shuffleOptions(AqeedahQuestion question, Random random) {
    final options = <_PresentedOption>[
      for (var i = 0; i < question.options.length; i++)
        _PresentedOption(
          text: question.options[i],
          isCorrect: i == question.correctIndex,
        ),
    ]..shuffle(random);

    return options;
  }

  List<_PresentedOption> get _currentOptions => _presentedOptions[_current.id]!;

  Future<void> _select(int optionIndex) async {
    if (_answered) return;
    final correct = _currentOptions[optionIndex].isCorrect;
    setState(() {
      _selectedIndex = optionIndex;
      if (correct) {
        _correct += 1;
      } else {
        _wrongIds.add(_current.id);
      }
    });

    if (correct) {
      await ProgressService.markQuestionCorrect(_current.id);
    } else {
      await ProgressService.markQuestionWrong(_current.id);
    }
  }

  Future<void> _next() async {
    if (_index == _questions.length - 1) {
      if (_finishing) return;
      setState(() {
        _finishing = true;
      });

      await ProgressService.recordQuiz(
        correct: _correct,
        total: _questions.length,
        questionIds: _questions.map((q) => q.id).toList(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            correct: _correct,
            total: _questions.length,
            wrongIds: _wrongIds.toList(),
            category: widget.category,
            reviewedQuestions: widget.customQuestions,
            progressAlreadySaved: true,
          ),
        ),
      );
      return;
    }

    setState(() {
      _index += 1;
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return PremiumScaffold(
        title: context.t(widget.titleOverride ?? widget.category ?? 'Quiz'),
        child: Center(
          child: PremiumCard(
            child: Text(context.t('No questions found.'), style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      );
    }

    final progress = (_index + 1) / _questions.length;
    final selectedCorrect = _selectedIndex == null ? false : _currentOptions[_selectedIndex!].isCorrect;

    return PremiumScaffold(
      title: context.t(widget.titleOverride ?? widget.category ?? 'Full Quiz'),
      subtitle: context.isBangla ? '${_questions.length}টির মধ্যে ${_index + 1} নম্বর প্রশ্ন' : 'Question ${_index + 1} of ${_questions.length}',
      child: ListView(
        children: [
          _QuizProgressHeader(
            progress: progress,
            index: _index,
            total: _questions.length,
            correct: _correct,
          ),
          const SizedBox(height: 16),
          PremiumCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pill(text: context.t(_current.category), icon: Icons.category_rounded),
                    _Pill(text: context.t(_current.difficulty), icon: Icons.speed_rounded),
                    if (featuredAqeedahQuestionOrder.contains(_current.id))
                      _Pill(text: context.t('Core foundation'), icon: Icons.workspace_premium_rounded),
                  ],
                ),
                const SizedBox(height: 18),
                Text(context.t(_current.question), style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(
                  context.t('Choose the answer that best matches Qur’an, authentic Sunnah, and the understanding of the Salaf.'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(_currentOptions.length, (i) {
            final option = _currentOptions[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: QuestionOptionCard(
                option: context.t(option.text),
                index: i,
                isLocked: _answered,
                isSelected: _selectedIndex == i,
                isCorrect: option.isCorrect,
                onTap: () => _select(i),
              ),
            );
          }),
          if (_answered) ...[
            const SizedBox(height: 8),
            ReferenceBox(question: _current, answeredCorrectly: selectedCorrect),
            const SizedBox(height: 14),
            AppButton(
              label: _index == _questions.length - 1 ? context.t('See Result') : context.t('Next Question'),
              icon: _index == _questions.length - 1 ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded,
              onPressed: _finishing ? null : _next,
            ),
          ],
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

class _PresentedOption {
  final String text;
  final bool isCorrect;

  const _PresentedOption({
    required this.text,
    required this.isCorrect,
  });
}

class _QuizProgressHeader extends StatelessWidget {
  final double progress;
  final int index;
  final int total;
  final int correct;

  const _QuizProgressHeader({
    required this.progress,
    required this.index,
    required this.total,
    required this.correct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x9911241C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _MiniStat(label: context.t('Progress'), value: '${index + 1}/$total'),
              const SizedBox(width: 10),
              _MiniStat(label: context.t('Correct'), value: '$correct'),
              const SizedBox(width: 10),
              _MiniStat(label: context.t('XP ready'), value: '+${correct * 10}'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 11,
              backgroundColor: AppTheme.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.gold),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.gold.withOpacity(0.08),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppTheme.gold.withOpacity(0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: AppTheme.mutedText,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 3),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final IconData icon;

  const _Pill({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.gold.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.gold.withOpacity(0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppTheme.softGold),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.softGold,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
