class AqeedahQuestion {
  final String id;
  final String category;
  final String difficulty;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String correctAnswer;
  final String reference;
  final String explanation;
  final String commonMistake;
  final String relatedBeliefGroup;

  const AqeedahQuestion({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.correctAnswer,
    required this.reference,
    required this.explanation,
    required this.commonMistake,
    required this.relatedBeliefGroup,
  });
}
