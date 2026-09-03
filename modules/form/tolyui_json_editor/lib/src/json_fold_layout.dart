/// 负责分析 JSON 文本中的可折叠区间，并生成无损的可见行布局。

library;

/// JSON 折叠后的单行显示信息。
class JsonFoldLine {
  /// 原始文本中的物理行索引。
  final int sourceIndex;

  /// 当前行的原始文本。
  final String text;

  /// 当前行对应的折叠结束行；不可折叠时为空。
  final int? foldEnd;

  /// 当前行是否处于折叠状态。
  final bool collapsed;

  const JsonFoldLine({
    required this.sourceIndex,
    required this.text,
    required this.foldEnd,
    required this.collapsed,
  });

  /// 折叠后被隐藏的内部行数。
  int get hiddenLineCount {
    final int? end = foldEnd;
    if (!collapsed || end == null) return 0;
    return end - sourceIndex - 1;
  }

  /// 用于界面展示的文本，不会回写到原始 JSON。
  String get displayText {
    if (!collapsed) return text;
    return '$text  …  $hiddenLineCount 行';
  }
}

/// JSON 源码的折叠区间及当前可见行布局。
class JsonFoldLayout {
  /// 原始物理行。
  final List<String> sourceLines;

  /// 起始行到结束行的可折叠区间。
  final Map<int, int> foldRanges;

  /// 当前已折叠的起始行集合。
  final Set<int> collapsedLines;

  const JsonFoldLayout({
    required this.sourceLines,
    required this.foldRanges,
    required this.collapsedLines,
  });

  /// 从原始 JSON 文本创建折叠布局。
  factory JsonFoldLayout.fromText(String text, Set<int> collapsedLines) {
    final List<String> sourceLines = text.split('\n');
    final Map<int, int> foldRanges = _resolveFoldRanges(sourceLines);
    final Set<int> validCollapsedLines = collapsedLines
        .where((int lineIndex) => foldRanges.containsKey(lineIndex))
        .toSet();
    return JsonFoldLayout(
      sourceLines: sourceLines,
      foldRanges: foldRanges,
      collapsedLines: validCollapsedLines,
    );
  }

  /// 按折叠状态跳过隐藏区间，生成界面实际需要渲染的行。
  List<JsonFoldLine> get visibleLines {
    final List<JsonFoldLine> result = [];
    int lineIndex = 0;
    while (lineIndex < sourceLines.length) {
      final int? foldEnd = foldRanges[lineIndex];
      final bool collapsed = collapsedLines.contains(lineIndex);
      result.add(
        JsonFoldLine(
          sourceIndex: lineIndex,
          text: sourceLines[lineIndex],
          foldEnd: foldEnd,
          collapsed: collapsed,
        ),
      );
      lineIndex = collapsed && foldEnd != null ? foldEnd + 1 : lineIndex + 1;
    }
    return result;
  }

  /// 分析括号配对；字符串内部的括号不参与折叠区间计算。
  static Map<int, int> _resolveFoldRanges(List<String> lines) {
    final Map<int, int> result = {};
    final List<int> stack = [];
    bool inString = false;
    bool escaped = false;
    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final String line = lines[lineIndex];
      for (int characterIndex = 0;
          characterIndex < line.length;
          characterIndex++) {
        final String character = line[characterIndex];
        if (escaped) {
          escaped = false;
          continue;
        }
        if (character == '\\' && inString) {
          escaped = true;
          continue;
        }
        if (character == '"') {
          inString = !inString;
          continue;
        }
        if (inString) continue;
        if (character == '{' || character == '[') {
          stack.add(lineIndex);
          continue;
        }
        if ((character == '}' || character == ']') && stack.isNotEmpty) {
          final int startLine = stack.removeLast();
          if (lineIndex > startLine + 1) result[startLine] = lineIndex;
        }
      }
    }
    return result;
  }
}
