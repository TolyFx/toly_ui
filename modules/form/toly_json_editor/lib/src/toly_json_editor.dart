import 'dart:convert';
import 'package:flutter/material.dart';
import 'json_editor_style.dart';

/// TolyUI JSON 编辑器
///
/// 支持语法高亮、格式化、压缩、验证的 JSON 编辑组件
///
/// 示例:
/// ```dart
/// TolyJsonEditor(
///   value: '{"key": "value"}',
///   label: 'JSON 配置',
///   onChanged: (json) => print(json),
/// )
/// ```
class TolyJsonEditor extends StatefulWidget {
  /// JSON 文本内容
  final String value;

  /// 标签文本
  final String? label;

  /// 占位提示
  final String? hint;

  /// 最小行数
  final int minLines;

  /// 最大行数
  final int maxLines;

  /// 值变化回调
  final ValueChanged<String>? onChanged;

  /// 样式配置
  final JsonEditorStyle? style;

  /// 是否启用
  final bool enabled;

  /// 是否显示工具栏
  final bool showToolbar;

  /// 是否显示验证状态
  final bool showValidation;

  const TolyJsonEditor({
    super.key,
    required this.value,
    this.label,
    this.hint,
    this.minLines = 4,
    this.maxLines = 12,
    this.onChanged,
    this.style,
    this.enabled = true,
    this.showToolbar = true,
    this.showValidation = true,
  });

  @override
  State<TolyJsonEditor> createState() => _TolyJsonEditorState();
}

class _TolyJsonEditorState extends State<TolyJsonEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isValid = true;
  String? _errorMessage;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _validate(widget.value);
  }

  @override
  void didUpdateWidget(TolyJsonEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isFocused) {
      _controller.text = widget.value;
      _validate(widget.value);
    }
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _validate(String text) {
    if (text.trim().isEmpty) {
      setState(() {
        _isValid = true;
        _errorMessage = null;
      });
      return;
    }
    try {
      jsonDecode(text);
      setState(() {
        _isValid = true;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isValid = false;
        _errorMessage = e.toString().replaceFirst('FormatException: ', '');
      });
    }
  }

  void _formatJson() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    try {
      final decoded = jsonDecode(text);
      final formatted = const JsonEncoder.withIndent('  ').convert(decoded);
      _controller.text = formatted;
      widget.onChanged?.call(formatted);
      _validate(formatted);
    } catch (_) {}
  }

  void _minifyJson() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    try {
      final decoded = jsonDecode(text);
      final minified = jsonEncode(decoded);
      _controller.text = minified;
      widget.onChanged?.call(minified);
      _validate(minified);
    } catch (_) {}
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
        _buildEditor(effectiveStyle),
        if (widget.showValidation && _errorMessage != null && !_isValid)
          _buildError(effectiveStyle),
      ],
    );
  }

  Widget _buildToolbar(JsonEditorStyle style) {
    return Row(
      children: [
        if (widget.label != null) Text(widget.label!, style: style.labelStyle),
        const Spacer(),
        if (widget.showValidation && _controller.text.trim().isNotEmpty)
          _buildValidationBadge(style),
        const SizedBox(width: 8),
        _ToolButton(
          icon: Icons.format_align_left,
          tooltip: 'Format',
          onPressed: widget.enabled && _isValid ? _formatJson : null,
          style: style,
        ),
        _ToolButton(
          icon: Icons.compress,
          tooltip: 'Minify',
          onPressed: widget.enabled && _isValid ? _minifyJson : null,
          style: style,
        ),
      ],
    );
  }

  Widget _buildValidationBadge(JsonEditorStyle style) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _isValid
            ? style.validColor.withValues(alpha: 0.1)
            : style.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isValid ? Icons.check_circle : Icons.error,
            size: 12,
            color: _isValid ? style.validColor : style.errorColor,
          ),
          const SizedBox(width: 4),
          Text(
            _isValid ? 'Valid' : 'Invalid',
            style: TextStyle(
              fontSize: 10,
              color: _isValid ? style.validColor : style.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor(JsonEditorStyle style) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: !_isValid
              ? style.errorColor
              : (_isFocused ? style.focusBorderColor : style.borderColor),
          width: _isFocused ? 2 : 1,
        ),
        borderRadius: style.borderRadius,
        color: widget.enabled ? style.backgroundColor : style.disabledColor,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: style.padding,
              child: _buildHighlightedText(style),
            ),
          ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            maxLines: null,
            minLines: widget.minLines,
            style: style.textStyle.copyWith(color: Colors.transparent),
            cursorColor: style.cursorColor,
            decoration: InputDecoration(
              hintText: widget.hint ?? '{"key": "value"}',
              hintStyle: style.hintStyle,
              border: InputBorder.none,
              contentPadding: style.padding,
            ),
            onChanged: (value) {
              _validate(value);
              widget.onChanged?.call(value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildError(JsonEditorStyle style) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        _errorMessage!,
        style: style.errorStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildHighlightedText(JsonEditorStyle style) {
    final text = _controller.text;
    if (text.isEmpty) return const SizedBox.shrink();

    return RichText(
      text: TextSpan(
        style: style.textStyle,
        children: _highlightJson(text, style),
      ),
    );
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
          text: match.group(1),
          style: TextStyle(color: style.keyColor),
        ));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(
          text: match.group(2),
          style: TextStyle(color: style.stringColor),
        ));
      } else if (match.group(3) != null) {
        spans.add(TextSpan(
          text: match.group(3),
          style: TextStyle(color: style.numberColor),
        ));
      } else if (match.group(4) != null) {
        spans.add(TextSpan(
          text: match.group(4),
          style: TextStyle(color: style.boolColor),
        ));
      } else if (match.group(5) != null) {
        spans.add(TextSpan(
          text: match.group(5),
          style: TextStyle(color: style.nullColor),
        ));
      } else if (match.group(6) != null) {
        spans.add(TextSpan(
          text: match.group(6),
          style: TextStyle(color: style.bracketColor),
        ));
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(color: style.bracketColor),
      ));
    }

    return spans;
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final JsonEditorStyle style;

  const _ToolButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    required this.style,
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
        foregroundColor: onPressed != null
            ? style.toolbarIconColor
            : style.disabledIconColor,
      ),
    );
  }
}
