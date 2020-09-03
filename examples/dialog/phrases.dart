class PlayerPhrase {
  final String text;
  final String action;
  final String goTo;
  final NpcPhrase answer;

  PlayerPhrase(
    this.text, {
    this.action,
    this.goTo,
    this.answer,
  });
}

class NpcPhrase {
  final String id;
  final String text;
  final List<PlayerPhrase> answers;
  final String answersFrom;

  NpcPhrase(
    this.text, {
    this.id,
    this.answers,
    this.answersFrom,
  });
}
