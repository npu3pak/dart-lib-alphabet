import 'phrases_snippets.dart';

class Resources {
  static final example = n(
    "Hi. What do you want, mister?",
    id: "A1",
    a: [
      p(
        "Who are you?",
        n(
          "I am Johnny.",
          a: [
            p("Johnny... Johnson?", null),
            p("Well, ok", null, goTo: "A1"),
          ],
        ),
      ),
      p(
        "Where are you from?",
        n("I'm living here.", r: "A1"),
      ),
      p(
        "Where can I find a library?",
        n("I don't know.", r: "A1"),
      ),
      p("Bye.", null),
    ],
  );
}
