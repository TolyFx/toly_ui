part of 'highlight_text.dart';

typedef OnMatchTap = void Function(HighlightMatch match);

class HighlightMatch {
  final String pattern;
  final String matchedText;
  final int startIndex;
  final int endIndex;
  final int matchIndex;

  HighlightMatch(
    this.pattern,
    this.matchedText,
    this.startIndex,
    this.endIndex,
    this.matchIndex,
  );
}

// 内部类，用于存储高亮的信息
class _Highlight {
  final int start;
  final String text;
  final TextStyle style;
  final VoidCallback? onTap;

  _Highlight(this.start, this.text, this.style, this.onTap);
}
