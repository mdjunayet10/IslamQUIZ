import 'package:flutter/material.dart';

import '../data/aqeedah_questions.dart';
import '../services/language_service.dart';
import '../services/progress_service.dart';
import '../services/app_route_observer.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/premium_card.dart';
import '../widgets/premium_scaffold.dart';
import 'about_screen.dart';
import 'category_screen.dart';
import 'core_beliefs_screen.dart';
import 'quiz_screen.dart';
import 'review_mistakes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  late Future<ProgressSnapshot> _progressFuture;

  @override
  void initState() {
    super.initState();
    _progressFuture = ProgressService.load();
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {
      _progressFuture = ProgressService.load();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    _refresh();
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: LanguageService.appName,
      subtitle: context.t('Correct aqeedah MCQs with evidence'),
      showBackButton: false,
      child: ListView(
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 720;
                final hero = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLogo(size: 88),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(999),
                        border:
                            Border.all(color: AppTheme.gold.withOpacity(0.38)),
                      ),
                      child: Text(
                        context.t(
                            'Qur’an • Authentic Sunnah • Understanding of the Salaf'),
                        style: TextStyle(
                          color: AppTheme.softGold,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(context.t('Learn correct aqeedah step by step.'),
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 12),
                    Text(
                      context.t(
                          'Start with the most important foundations first: where Allah is, Allah’s Names and Attributes, the Qur’an, Salah, Tawheed, shirk, the Salaf, and the danger of bid‘ah.'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppTheme.mutedText),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TopicChip(label: context.t('Where is Allah?')),
                        _TopicChip(label: context.t('Allah’s Attributes')),
                        _TopicChip(
                            label: context.t('Qur’an is Allah’s Speech')),
                        _TopicChip(label: context.t('Salah and Iman')),
                        _TopicChip(label: context.t('Tawheed of Worship')),
                      ],
                    ),
                  ],
                );
                final stats = FutureBuilder<ProgressSnapshot>(
                  future: _progressFuture,
                  builder: (context, snapshot) {
                    final progress = snapshot.data;
                    return _StatsPanel(progress: progress);
                  },
                );

                if (wide) {
                  return Row(
                    children: [
                      Expanded(flex: 3, child: hero),
                      const SizedBox(width: 22),
                      Expanded(flex: 2, child: stats),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [hero, const SizedBox(height: 20), stats],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: context.t('Start Essential Foundations'),
            icon: Icons.workspace_premium_rounded,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    titleOverride: 'Essential Foundations',
                    customQuestions:
                        prioritizeAqeedahQuestions(aqeedahQuestions)
                            .take(12)
                            .toList(),
                  ),
                ),
              );
              _refresh();
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            label: context.t('Start Full Quiz'),
            icon: Icons.play_arrow_rounded,
            secondary: true,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizScreen()),
              );
              _refresh();
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            label: context.t('Choose Category'),
            icon: Icons.grid_view_rounded,
            secondary: true,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoryScreen()),
              );
              _refresh();
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            label: context.t('Core Beliefs of Aqeedah'),
            icon: Icons.menu_book_rounded,
            secondary: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CoreBeliefsScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            label: context.t('Review Mistakes'),
            icon: Icons.history_edu_rounded,
            secondary: true,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReviewMistakesScreen()),
              );
              _refresh();
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            label: context.t('About Aqeedah Methodology'),
            icon: Icons.info_outline_rounded,
            secondary: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;

  const _TopicChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x661B3A30),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.text,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  final ProgressSnapshot? progress;

  const _StatsPanel({this.progress});

  @override
  Widget build(BuildContext context) {
    final p = progress;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.gold.withOpacity(0.12),
            const Color(0x5511261E),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.gold.withOpacity(0.22)),
      ),
      child: Column(
        children: [
          _StatTile(
              label: context.t('Level'),
              value: '${p?.level ?? 1}',
              icon: Icons.shield_rounded),
          const Divider(color: AppTheme.cardBorder),
          _StatTile(
              label: context.t('Total XP'),
              value: '${p?.totalXp ?? 0}',
              icon: Icons.bolt_rounded),
          const Divider(color: AppTheme.cardBorder),
          _StatTile(
              label: context.t('Completed Quizzes'),
              value: '${p?.completedQuizzes ?? 0}',
              icon: Icons.task_alt_rounded),
          const Divider(color: AppTheme.cardBorder),
          _StatTile(
            label: context.t('Best Score'),
            value: p == null || p.bestTotal == 0
                ? '0%'
                : '${(p.bestPercent * 100).round()}%',
            icon: Icons.workspace_premium_rounded,
          ),
          const Divider(color: AppTheme.cardBorder),
          _StatTile(
              label: context.t('Questions Completed'),
              value: '${p?.completedQuestionIds.length ?? 0}',
              icon: Icons.checklist_rounded),
          const Divider(color: AppTheme.cardBorder),
          _StatTile(
              label: context.t('Mistakes'),
              value: '${p?.wrongQuestionIds.length ?? 0}',
              icon: Icons.edit_note_rounded),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
            ),
            child: Icon(icon, color: AppTheme.softGold, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
              child:
                  Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
