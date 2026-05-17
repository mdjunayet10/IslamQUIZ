import 'package:shared_preferences/shared_preferences.dart';

class ProgressSnapshot {
  final int totalXp;
  final int completedQuizzes;
  final int bestScore;
  final int bestTotal;
  final List<String> wrongQuestionIds;
  final List<String> completedQuestionIds;

  const ProgressSnapshot({
    required this.totalXp,
    required this.completedQuizzes,
    required this.bestScore,
    required this.bestTotal,
    required this.wrongQuestionIds,
    required this.completedQuestionIds,
  });

  double get bestPercent {
    if (bestTotal == 0) return 0;
    return bestScore / bestTotal;
  }

  int get level => (totalXp ~/ 100) + 1;

  int get xpIntoLevel => totalXp % 100;

  int get xpToNextLevel => 100 - xpIntoLevel;
}

class ProgressService {
  static const String _totalXpKey = 'total_xp';
  static const String _completedQuizzesKey = 'completed_quizzes';
  static const String _bestScoreKey = 'best_score';
  static const String _bestTotalKey = 'best_total';
  static const String _wrongQuestionIdsKey = 'wrong_question_ids';
  static const String _completedQuestionIdsKey = 'completed_question_ids';

  static Future<ProgressSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressSnapshot(
      totalXp: prefs.getInt(_totalXpKey) ?? 0,
      completedQuizzes: prefs.getInt(_completedQuizzesKey) ?? 0,
      bestScore: prefs.getInt(_bestScoreKey) ?? 0,
      bestTotal: prefs.getInt(_bestTotalKey) ?? 0,
      wrongQuestionIds: prefs.getStringList(_wrongQuestionIdsKey) ?? <String>[],
      completedQuestionIds: prefs.getStringList(_completedQuestionIdsKey) ?? <String>[],
    );
  }

  static Future<ProgressSnapshot> recordQuiz({
    required int correct,
    required int total,
    List<String> questionIds = const <String>[],
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final oldXp = prefs.getInt(_totalXpKey) ?? 0;
    final oldCompleted = prefs.getInt(_completedQuizzesKey) ?? 0;
    final oldBestScore = prefs.getInt(_bestScoreKey) ?? 0;
    final oldBestTotal = prefs.getInt(_bestTotalKey) ?? 0;

    await prefs.setInt(_totalXpKey, oldXp + (correct * 10));
    await prefs.setInt(_completedQuizzesKey, oldCompleted + 1);

    if (questionIds.isNotEmpty) {
      final completedIds = (prefs.getStringList(_completedQuestionIdsKey) ?? <String>[]).toSet();
      completedIds.addAll(questionIds);
      await prefs.setStringList(_completedQuestionIdsKey, completedIds.toList()..sort());
    }

    final oldPercent = oldBestTotal == 0 ? 0 : oldBestScore / oldBestTotal;
    final newPercent = total == 0 ? 0 : correct / total;
    if (newPercent > oldPercent || (newPercent == oldPercent && correct > oldBestScore)) {
      await prefs.setInt(_bestScoreKey, correct);
      await prefs.setInt(_bestTotalKey, total);
    }

    return load();
  }

  static Future<void> markQuestionWrong(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_wrongQuestionIdsKey) ?? <String>[]).toSet();
    ids.add(id);
    await prefs.setStringList(_wrongQuestionIdsKey, ids.toList()..sort());
  }

  static Future<void> markQuestionCorrect(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_wrongQuestionIdsKey) ?? <String>[]).toSet();
    ids.remove(id);
    await prefs.setStringList(_wrongQuestionIdsKey, ids.toList()..sort());
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_totalXpKey);
    await prefs.remove(_completedQuizzesKey);
    await prefs.remove(_bestScoreKey);
    await prefs.remove(_bestTotalKey);
    await prefs.remove(_wrongQuestionIdsKey);
    await prefs.remove(_completedQuestionIdsKey);
  }
}
