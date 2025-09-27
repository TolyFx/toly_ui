import '../../tolyui_text.dart';

class Rule implements Comparable<String>, Pattern {
  final Pattern pattern;
  final OnMatchTap? onTap;

  Rule(this.pattern, {this.onTap});

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    return pattern.allMatches(string, start);
  }

  @override
  int compareTo(String other) {
    return pattern.toString().compareTo(other);
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    return pattern.matchAsPrefix(string, start);
  }
}
