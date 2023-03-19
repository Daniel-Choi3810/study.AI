class FlashCardModel {
  const FlashCardModel(
      {required this.term,
      required this.definition,
      required this.regenerations,
      required this.isStarred});

  final String term;
  final String definition;
  final int regenerations;
  final bool isStarred;

  static List<Map> convertFlashcardsToMap(
      {required List<FlashCardModel> flashcardList}) {
    List<Map> steps = [];
    for (var flashcard in flashcardList) {
      Map step = {
        'term': flashcard.term,
        'definition': flashcard.definition,
        'regenerations': flashcard.regenerations,
        'isStarred': flashcard.isStarred,
      };
      steps.add(step);
    }
    return steps;
  }
}
