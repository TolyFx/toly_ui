import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'json_editor_style.dart';

/// TolyUI JSON 预览组件
///
/// 只读的 JSON 查看器，支持语法高亮、可折叠树形结构、复制功能
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

  /// 初始展开深度（-1 表示全部展开）
  final int initialExpandDepth;

  /// 是否显示工具栏
  final bool showToolbar;

  /// 是否显示行号
  final bool showLineNumbers;

  /// 缩进大小
  final int indentSize;

  /// 是否显示边框
  final bool showBorder;

  /// 是否使用滚动容器（false 时自适应高度）
  final bool scrollable;

  const TolyJsonViewer({
    super.key,
    this.data,
    this.jsonString,
    this.style,
    this.initialExpandDepth = 2,
    this.showToolbar = true,
    this.showLineNumbers = false,
    this.indentSize = 2,
    this.showBorder = true,
    this.scrollable = true,
  });

  @override
  State<TolyJsonViewer> createState() => _TolyJsonViewerState();
}

class _TolyJsonViewerState extends State<TolyJsonViewer> {
  late dynamic _parsedData;
  String? _errorMessage;
  final Set<String> _collapsedPaths = {};
  bool _isTreeView = true;

  @override
  void initState() {
    super.initState();
    _parseData();
  }

  @override
  void didUpdateWidget(TolyJsonViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data || oldWidget.jsonString != widget.jsonString) {
      _parseData();
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

  void _copyToClipboard() {
    final text = _parsedData != null
        ? const JsonEncoder.withIndent('  ').convert(_parsedData)
        : widget.jsonString ?? '';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制到剪贴板'), duration: Duration(seconds: 1)),
    );
  }

  void _expandAll() {
    setState(() => _collapsedPaths.clear());
  }

  void _collapseAll() {
    setState(() {
      _collapsedPaths.clear();
      _collectAllPaths(_parsedData, '', _collapsedPaths);
    });
  }

  void _collectAllPaths(dynamic data, String path, Set<String> paths) {
    if (data is Map) {
      paths.add(path);
      data.forEach((key, value) {
        _collectAllPaths(value, '$path/$key', paths);
      });
    } else if (data is List) {
      paths.add(path);
      for (int i = 0; i < data.length; i++) {
        _collectAllPaths(data[i], '$path[$i]', paths);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = widget.style ?? JsonEditorStyle.fromTheme(theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showToolbar) _buildToolbar(effectiveStyle),
        if (widget.showToolbar) const SizedBox(height: 8),
        _buildContent(effectiveStyle),
      ],
    );
  }

  Widget _buildToolbar(JsonEditorStyle style) {
    return Row(
      children: [
        // 视图切换
        _ToolButton(
          icon: Icons.account_tree,
          tooltip: '树形视图',
          isActive: _isTreeView,
          onPressed: () => setState(() => _isTreeView = true),
          style: style,
        ),
        _ToolButton(
          icon: Icons.code,
          tooltip: '原始视图',
          isActive: !_isTreeView,
          onPressed: () => setState(() => _isTreeView = false),
          style: style,
        ),
        const SizedBox(width: 8),
        Container(width: 1, height: 16, color: style.borderColor),
        const SizedBox(width: 8),
        // 展开/折叠
        _ToolButton(
          icon: Icons.unfold_more,
          tooltip: '全部展开',
          onPressed: _expandAll,
          style: style,
        ),
        _ToolButton(
          icon: Icons.unfold_less,
          tooltip: '全部折叠',
          onPressed: _collapseAll,
          style: style,
        ),
        const Spacer(),
        // 复制
        _ToolButton(
          icon: Icons.copy,
          tooltip: '复制',
          onPressed: _copyToClipboard,
          style: style,
        ),
      ],
    );
  }

  Widget _buildContent(JsonEditorStyle style) {
    if (_errorMessage != null) {
      return Container(
        padding: style.padding,
        decoration: widget.showBorder ? BoxDecoration(
          border: Border.all(color: style.errorColor),
          borderRadius: style.borderRadius,
          color: style.errorColor.withValues(alpha: 0.1),
        ) : null,
        child: Text(_errorMessage!, style: style.errorStyle),
      );
    }

    if (_parsedData == null) {
      return Container(
        padding: style.padding,
        decoration: widget.showBorder ? BoxDecoration(
          border: Border.all(color: style.borderColor),
          borderRadius: style.borderRadius,
          color: style.backgroundColor,
        ) : null,
        child: Text('No data', style: style.hintStyle),
      );
    }

    final content = _isTreeView
        ? _buildTreeView(_parsedData, '', 0, style)
        : _buildRawView(style);

    if (widget.scrollable) {
      return Container(
        decoration: widget.showBorder ? BoxDecoration(
          border: Border.all(color: style.borderColor),
          borderRadius: style.borderRadius,
          color: style.backgroundColor,
        ) : null,
        child: SingleChildScrollView(
          padding: style.padding,
          child: content,
        ),
      );
    }

    // 不使用滚动容器，自适应高度
    return Container(
      padding: style.padding,
      decoration: widget.showBorder ? BoxDecoration(
        border: Border.all(color: style.borderColor),
        borderRadius: style.borderRadius,
        color: style.backgroundColor,
      ) : null,
      child: content,
    );
  }

  Widget _buildRawView(JsonEditorStyle style) {
    final text = const JsonEncoder.withIndent('  ').convert(_parsedData);
    return SelectableText.rich(
      TextSpan(
        style: style.textStyle,
        children: _highlightJson(text, style),
      ),
    );
  }

  Widget _buildTreeView(dynamic data, String path, int depth, JsonEditorStyle style) {
    if (data is Map) {
      return _buildMapNode(data, path, depth, style);
    } else if (data is List) {
      return _buildListNode(data, path, depth, style);
    } else {
      return _buildValueNode(data, style);
    }
  }

  Widget _buildMapNode(Map data, String path, int depth, JsonEditorStyle style) {
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
                    style: TextStyle(color: style.bracketColor.withValues(alpha: 0.6))),
            ],
          ),
        ),
        if (!isCollapsed) ...[
          Padding(
            padding: EdgeInsets.only(left: widget.indentSize * 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.entries.map((entry) {
                final childPath = '$path/${entry.key}';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('"${entry.key}"', style: TextStyle(color: style.keyColor)),
                      Text(': ', style: TextStyle(color: style.bracketColor)),
                      Flexible(child: _buildTreeView(entry.value, childPath, depth + 1, style)),
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

  Widget _buildListNode(List data, String path, int depth, JsonEditorStyle style) {
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
                    style: TextStyle(color: style.bracketColor.withValues(alpha: 0.6))),
            ],
          ),
        ),
        if (!isCollapsed) ...[
          Padding(
            padding: EdgeInsets.only(left: widget.indentSize * 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(data.length, (index) {
                final childPath = '$path[$index]';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$index: ', style: TextStyle(color: style.bracketColor.withValues(alpha: 0.6), fontSize: 10)),
                      Flexible(child: _buildTreeView(data[index], childPath, depth + 1, style)),
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
      return SelectableText('"$value"', style: TextStyle(color: style.stringColor));
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
        spans.add(TextSpan(text: match.group(1), style: TextStyle(color: style.keyColor)));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(text: match.group(2), style: TextStyle(color: style.stringColor)));
      } else if (match.group(3) != null) {
        spans.add(TextSpan(text: match.group(3), style: TextStyle(color: style.numberColor)));
      } else if (match.group(4) != null) {
        spans.add(TextSpan(text: match.group(4), style: TextStyle(color: style.boolColor)));
      } else if (match.group(5) != null) {
        spans.add(TextSpan(text: match.group(5), style: TextStyle(color: style.nullColor)));
      } else if (match.group(6) != null) {
        spans.add(TextSpan(text: match.group(6), style: TextStyle(color: style.bracketColor)));
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: TextStyle(color: style.bracketColor)));
    }

    return spans;
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final JsonEditorStyle style;
  final bool isActive;

  const _ToolButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    required this.style,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 16),
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      style: IconButton.styleFrom(
        foregroundColor: isActive ? style.focusBorderColor : style.toolbarIconColor,
        backgroundColor: isActive ? style.focusBorderColor.withValues(alpha: 0.1) : null,
      ),
    );
  }
}
