import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'json_editor_style.dart';

/// TolyUI JSON 预览组件
///
/// 只读的 JSON 源码查看器，支持语法高亮、行号、区块折叠和复制。
///
/// 示例:
/// ```dart
/// TolyJsonViewer(
///   data: {'name': 'John', 'age': 30},
///   style: JsonEditorStyle.fromTheme(theme),
/// )
/// ```
class TolyJsonViewer extends StatefulWidget {
  /// JSON 数据（可以是 Map、List 或已解析的 JSON 对象）
  final dynamic data;

  /// JSON 字符串（如果 data 为 null，则使用此字符串）
  final String? jsonString;

  /// 样式配置
  final JsonEditorStyle? style;

  /// 是否显示工具栏
  final bool showToolbar;

  /// 是否显示行号
  final bool showLineNumbers;

  /// 是否使用滚动容器（false 时自适应高度）
  final bool scrollable;

  /// JSON 复制到剪贴板后的回调。
  final VoidCallback? onCopied;

  const TolyJsonViewer({
    super.key,
    this.data,
    this.jsonString,
    this.style,
    this.showToolbar = true,
    this.showLineNumbers = false,
    this.scrollable = true,
    this.onCopied,
  });

  @override
  State<TolyJsonViewer> createState() => _TolyJsonViewerState();
}

class _TolyJsonViewerState extends State<TolyJsonViewer> {
  late dynamic _parsedData;
  String? _errorMessage;
  final Set<String> _collapsedPaths = <String>{};
  final Set<int> _collapsedSourceLines = <int>{};
  late bool _showLineNumbers;

  @override
  void initState() {
    super.initState();
    _showLineNumbers = widget.showLineNumbers;
    _parseData();
  }

  @override
  void didUpdateWidget(TolyJsonViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.jsonString != widget.jsonString) {
      _parseData();
    }
    if (oldWidget.showLineNumbers != widget.showLineNumbers) {
      _showLineNumbers = widget.showLineNumbers;
    }
  }

  void _parseData() {
    _errorMessage = null;
    if (widget.data != null) {
      _parsedData = widget.data;
    } else if (widget.jsonString != null && widget.jsonString!.isNotEmpty) {
      try {
        _parsedData = jsonDecode(widget.jsonString!);
      } catch (e) {
        _errorMessage = e.toString().replaceFirst('FormatException: ', '');
        _parsedData = null;
      }
    } else {
      _parsedData = null;
    }
  }

  Future<void> _copyToClipboard() async {
    final String text = _parsedData != null
        ? const JsonEncoder.withIndent('  ').convert(_parsedData)
        : widget.jsonString ?? '';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    final VoidCallback? onCopied = widget.onCopied;
    if (onCopied != null) {
      onCopied();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制到剪贴板'), duration: Duration(seconds: 1)),
    );
  }

  void _expandAll() {
    setState(() {
      _collapsedSourceLines.clear();
    });
  }

  void _collapseAll() {
    setState(() {
      final List<String> lines = _formattedSourceLines;
      _collapsedSourceLines
        ..clear()
        ..addAll(_sourceFoldRanges(lines).keys);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final JsonEditorStyle effectiveStyle =
        widget.style ?? JsonEditorStyle.fromTheme(theme);
    final List<Widget> children = <Widget>[
      if (widget.showToolbar) _buildToolbar(effectiveStyle),
      if (widget.showToolbar) const SizedBox(height: 10),
      if (widget.scrollable)
        Expanded(child: _buildContent(effectiveStyle))
      else
        _buildContent(effectiveStyle),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: widget.scrollable ? MainAxisSize.max : MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildToolbar(JsonEditorStyle style) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          _ToolButton(
            icon: Icons.format_list_numbered_rounded,
            label: '行号',
            tooltip: _showLineNumbers ? '隐藏行号' : '显示行号',
            isActive: _showLineNumbers,
            onPressed: () => setState(() {
              _showLineNumbers = !_showLineNumbers;
            }),
            style: style,
          ),
          const SizedBox(width: 6),
          Container(
            width: 1,
            height: 18,
            color: colors.outlineVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 6),
          _ToolButton(
            icon: Icons.unfold_more_rounded,
            tooltip: '全部展开',
            onPressed: _expandAll,
            style: style,
          ),
          _ToolButton(
            icon: Icons.unfold_less_rounded,
            tooltip: '全部折叠',
            onPressed: _collapseAll,
            style: style,
          ),
          const Spacer(),
          _ToolButton(
            icon: Icons.copy_all_outlined,
            tooltip: '复制 JSON',
            onPressed: _copyToClipboard,
            style: style,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(JsonEditorStyle style) {
    if (_errorMessage != null) {
      return Padding(
        padding: style.padding,
        child: Text(_errorMessage!, style: style.errorStyle),
      );
    }

    if (_parsedData == null) {
      return Padding(
        padding: style.padding,
        child: Text('No data', style: style.hintStyle),
      );
    }

    final Widget content = _buildRawView(style);

    if (widget.scrollable) {
      return SingleChildScrollView(
        padding: style.padding,
        child: content,
      );
    }

    return Padding(
      padding: style.padding,
      child: content,
    );
  }

  Widget _buildRawView(JsonEditorStyle style) {
    final List<String> lines = _formattedSourceLines;
    final Map<int, int> foldRanges = _sourceFoldRanges(lines);
    final List<Widget> rows = <Widget>[];
    int lineIndex = 0;
    while (lineIndex < lines.length) {
      final int currentLine = lineIndex;
      final int? foldEnd = foldRanges[currentLine];
      final bool collapsed = _collapsedSourceLines.contains(currentLine);
      rows.add(
        _SourceLine(
          lineNumber: currentLine + 1,
          showLineNumber: _showLineNumbers,
          spans: _highlightJson(lines[currentLine], style),
          style: style,
          foldable: foldEnd != null,
          collapsed: collapsed,
          hiddenLineCount:
              collapsed && foldEnd != null ? foldEnd - currentLine - 1 : 0,
          onToggleFold:
              foldEnd == null ? null : () => _toggleSourceFold(currentLine),
        ),
      );
      lineIndex = collapsed && foldEnd != null ? foldEnd + 1 : lineIndex + 1;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  List<String> get _formattedSourceLines {
    final String source =
        const JsonEncoder.withIndent('  ').convert(_parsedData);
    return source.split('\n');
  }

  /// 分析格式化 JSON 中可折叠括号的起止行。
  Map<int, int> _sourceFoldRanges(List<String> lines) {
    final Map<int, int> result = <int, int>{};
    final List<int> stack = <int>[];
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

  void _toggleSourceFold(int lineIndex) {
    setState(() {
      if (!_collapsedSourceLines.remove(lineIndex)) {
        _collapsedSourceLines.add(lineIndex);
      }
    });
  }

  Widget _buildTreeView(
      dynamic data, String path, int depth, JsonEditorStyle style) {
    if (data is Map) {
      return _buildMapNode(data, path, depth, style);
    } else if (data is List) {
      return _buildListNode(data, path, depth, style);
    } else {
      return _buildValueNode(data, style);
    }
  }

  Widget _buildMapNode(
      Map data, String path, int depth, JsonEditorStyle style) {
    final isCollapsed = _collapsedPaths.contains(path);
    final isEmpty = data.isEmpty;

    if (isEmpty) {
      return Text('{}', style: TextStyle(color: style.bracketColor));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            if (isCollapsed) {
              _collapsedPaths.remove(path);
            } else {
              _collapsedPaths.add(path);
            }
          }),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCollapsed ? Icons.chevron_right : Icons.expand_more,
                size: 14,
                color: style.bracketColor,
              ),
              Text('{', style: TextStyle(color: style.bracketColor)),
              if (isCollapsed)
                Text(' ${data.length} items }',
                    style: TextStyle(
                        color: style.bracketColor.withValues(alpha: 0.6))),
            ],
          ),
        ),
        if (!isCollapsed) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.entries.map((entry) {
                final childPath = '$path/${entry.key}';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('"${entry.key}"',
                          style: TextStyle(color: style.keyColor)),
                      Text(': ', style: TextStyle(color: style.bracketColor)),
                      Flexible(
                          child: _buildTreeView(
                              entry.value, childPath, depth + 1, style)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Text('}', style: TextStyle(color: style.bracketColor)),
        ],
      ],
    );
  }

  Widget _buildListNode(
      List data, String path, int depth, JsonEditorStyle style) {
    final isCollapsed = _collapsedPaths.contains(path);
    final isEmpty = data.isEmpty;

    if (isEmpty) {
      return Text('[]', style: TextStyle(color: style.bracketColor));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            if (isCollapsed) {
              _collapsedPaths.remove(path);
            } else {
              _collapsedPaths.add(path);
            }
          }),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCollapsed ? Icons.chevron_right : Icons.expand_more,
                size: 14,
                color: style.bracketColor,
              ),
              Text('[', style: TextStyle(color: style.bracketColor)),
              if (isCollapsed)
                Text(' ${data.length} items ]',
                    style: TextStyle(
                        color: style.bracketColor.withValues(alpha: 0.6))),
            ],
          ),
        ),
        if (!isCollapsed) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(data.length, (index) {
                final childPath = '$path[$index]';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$index: ',
                          style: TextStyle(
                              color: style.bracketColor.withValues(alpha: 0.6),
                              fontSize: 10)),
                      Flexible(
                          child: _buildTreeView(
                              data[index], childPath, depth + 1, style)),
                    ],
                  ),
                );
              }),
            ),
          ),
          Text(']', style: TextStyle(color: style.bracketColor)),
        ],
      ],
    );
  }

  Widget _buildValueNode(dynamic value, JsonEditorStyle style) {
    if (value == null) {
      return Text('null', style: TextStyle(color: style.nullColor));
    } else if (value is bool) {
      return Text(value.toString(), style: TextStyle(color: style.boolColor));
    } else if (value is num) {
      return Text(value.toString(), style: TextStyle(color: style.numberColor));
    } else if (value is String) {
      return SelectableText('"$value"',
          style: TextStyle(color: style.stringColor));
    }
    return Text(value.toString(), style: style.textStyle);
  }

  List<TextSpan> _highlightJson(String text, JsonEditorStyle style) {
    final spans = <TextSpan>[];
    final regex = RegExp(
      r'("(?:[^"\\]|\\.)*")\s*:|("(?:[^"\\]|\\.)*")|(-?\d+\.?\d*(?:[eE][+-]?\d+)?)|(\btrue\b|\bfalse\b)|(\bnull\b)|([\[\]{}:,])',
    );

    int lastEnd = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(color: style.bracketColor),
        ));
      }

      if (match.group(1) != null) {
        spans.add(TextSpan(
            text: match.group(1), style: TextStyle(color: style.keyColor)));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(
            text: match.group(2), style: TextStyle(color: style.stringColor)));
      } else if (match.group(3) != null) {
        spans.add(TextSpan(
            text: match.group(3), style: TextStyle(color: style.numberColor)));
      } else if (match.group(4) != null) {
        spans.add(TextSpan(
            text: match.group(4), style: TextStyle(color: style.boolColor)));
      } else if (match.group(5) != null) {
        spans.add(TextSpan(
            text: match.group(5), style: TextStyle(color: style.nullColor)));
      } else if (match.group(6) != null) {
        spans.add(TextSpan(
            text: match.group(6), style: TextStyle(color: style.bracketColor)));
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(
          text: text.substring(lastEnd),
          style: TextStyle(color: style.bracketColor)));
    }

    return spans;
  }
}

class _SourceLine extends StatelessWidget {
  /// 源码行号。
  final int lineNumber;

  /// 是否显示行号。
  final bool showLineNumber;

  /// 高亮后的行内容。
  final List<TextSpan> spans;

  /// JSON 显示样式。
  final JsonEditorStyle style;

  /// 当前行是否可折叠。
  final bool foldable;

  /// 当前行是否已折叠。
  final bool collapsed;

  /// 折叠时隐藏的行数。
  final int hiddenLineCount;

  /// 切换折叠状态动作。
  final VoidCallback? onToggleFold;

  const _SourceLine({
    required this.lineNumber,
    required this.showLineNumber,
    required this.spans,
    required this.style,
    required this.foldable,
    required this.collapsed,
    required this.hiddenLineCount,
    required this.onToggleFold,
  });

  @override
  Widget build(BuildContext context) {
    final Color gutterColor = Theme.of(
      context,
    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.52);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showLineNumber)
          SizedBox(
            width: 34,
            child: Text(
              '$lineNumber',
              textAlign: TextAlign.right,
              style: style.textStyle.copyWith(color: gutterColor),
            ),
          ),
        SizedBox(
          width: 24,
          height: (style.textStyle.fontSize ?? 13) *
              (style.textStyle.height ?? 1.5),
          child: foldable
              ? InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: onToggleFold,
                  child: Icon(
                    collapsed
                        ? Icons.chevron_right_rounded
                        : Icons.expand_more_rounded,
                    size: 16,
                    color: gutterColor,
                  ),
                )
              : null,
        ),
        SelectableText.rich(
          TextSpan(
            style: style.textStyle,
            children: <InlineSpan>[
              ...spans,
              if (collapsed)
                TextSpan(
                  text: '  …  $hiddenLineCount 行',
                  style: style.hintStyle,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  /// 按钮图标。
  final IconData icon;

  /// 可选文字。
  final String? label;

  /// 悬浮提示。
  final String tooltip;

  /// 点击动作。
  final VoidCallback? onPressed;

  /// JSON 样式。
  final JsonEditorStyle style;

  /// 是否为选中状态。
  final bool isActive;

  const _ToolButton({
    required this.icon,
    this.label,
    required this.tooltip,
    this.onPressed,
    required this.style,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color foreground =
        isActive ? colors.onSurface : colors.onSurfaceVariant;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          height: 34,
          padding: EdgeInsets.symmetric(horizontal: label == null ? 9 : 10),
          decoration: BoxDecoration(
            color: isActive ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 17, color: foreground),
              if (label != null) ...<Widget>[
                const SizedBox(width: 5),
                Text(
                  label!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: foreground,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
