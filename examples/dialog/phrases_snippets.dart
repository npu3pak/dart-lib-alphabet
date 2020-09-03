import 'phrases.dart';

PlayerPhrase p(
  String text,
  NpcPhrase answer, {
  String action,
  String goTo,
}) =>
    PlayerPhrase(
      text,
      action: action,
      goTo: goTo,
      answer: answer,
    );

NpcPhrase n(
  String text, {
  String id,
  List<PlayerPhrase> a,
  String r,
}) =>
    NpcPhrase(
      text,
      id: id,
      answers: a,
      answersFrom: r,
    );
