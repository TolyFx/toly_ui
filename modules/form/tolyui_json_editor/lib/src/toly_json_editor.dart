/// 提供带语法高亮、校验和 IDE 风格行号槽的 JSON 编辑组件。

library;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'json_fold_layout.dart';
import 'json_highlight_controller.dart';
import 'json_editor_style.dart';
import 'json_scope_guide.dart';

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

  /// 是否在编辑区域左侧显示物理行号
  final bool showLineNumbers;

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
    this.showLineNumbers = false,
  });

  @override
  State<TolyJsonEditor> createState() => _TolyJsonEditorState();
}

class _TolyJsonEditorState extends State<TolyJsonEditor> {
  static const double _gutterWidth = 52;

  late JsonHighlightController _controller;
  late FocusNode _focusNode;
  bool _isValid = true;
  String? _errorMessage;
  bool _isFocused = false;
  int _currentLineIndex = 0;

  /// 已折叠区块的原始起始行。
  final Set<int> _collapsedLineIndexes = {};

  @override
  void initState() {
    super.initState();
    _controller = JsonHighlightController(text: widget.value);
    _controller.addListener(_onControllerChanged);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _validate(widget.value);
  }

  @override
  void didUpdateWidget(TolyJsonEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isFocused) {
      _collapsedLineIndexes.clear();
      _controller.text = widget.value;
      _validate(widget.value);
    }
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  /// 根据光标偏移同步当前物理行，用于绘制 IDE 风格的活动行。
  void _onControllerChanged() {
    final TextSelection selection = _controller.selection;
    final int offset = selection.isValid
        ? selection.baseOffset.clamp(0, _controller.text.length)
        : 0;
    final int lineIndex =
        '\n'.allMatches(_controller.text.substring(0, offset)).length;
    if (lineIndex == _currentLineIndex || !mounted) return;
    setState(() => _currentLineIndex = lineIndex);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
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
    final JsonFoldLayout foldLayout = JsonFoldLayout.fromText(
      _controller.text,
      _collapsedLineIndexes,
    );
    _collapsedLineIndexes
      ..clear()
      ..addAll(foldLayout.collapsedLines);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
          color: !_isValid
              ? style.errorColor
              : (_isFocused ? style.focusBorderColor : style.borderColor),
          width: 1,
        ),
        borderRadius: style.borderRadius,
        color: widget.enabled ? style.backgroundColor : style.disabledColor,
        boxShadow: _isFocused && _isValid
            ? <BoxShadow>[
                BoxShadow(
                  color: style.focusBorderColor.withValues(alpha: 0.14),
                  blurRadius: 0,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: _collapsedLineIndexes.isEmpty
          ? _buildEditableBody(style, foldLayout)
          : _buildCollapsedBody(style, foldLayout),
    );
  }

  /// 构建正常编辑状态，并将输入层限制在 gutter 右侧以释放按钮点击区域。
  Widget _buildEditableBody(
    JsonEditorStyle style,
    JsonFoldLayout foldLayout,
  ) {
    _controller.editorStyle = style;
    return Stack(
      children: <Widget>[
        if (widget.showLineNumbers) _buildGutter(style),
        if (widget.showLineNumbers) _buildCurrentLineHighlight(style),
        _buildScopeGuide(style, foldLayout),
        if (widget.showLineNumbers) _buildLineNumbers(style, foldLayout),
        Padding(
          padding: EdgeInsets.only(
            left: widget.showLineNumbers ? _gutterWidth : 0,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            maxLines: null,
            minLines: widget.minLines,
            style: style.textStyle,
            strutStyle: _textStrut(style),
            cursorColor: style.cursorColor,
            decoration: InputDecoration(
              hintText: widget.hint ?? '{"key": "value"}',
              hintStyle: style.hintStyle,
              border: InputBorder.none,
              contentPadding: _editablePadding(style),
            ),
            onChanged: (String value) {
              _validate(value);
              widget.onChanged?.call(value);
            },
          ),
        ),
      ],
    );
  }

  /// 构建压缩后的只读画面；原始控制器内容始终保持不变。
  Widget _buildCollapsedBody(
    JsonEditorStyle style,
    JsonFoldLayout foldLayout,
  ) {
    final List<JsonFoldLine> visibleLines = foldLayout.visibleLines;
    final double lineHeight = _resolveLineHeight(style);
    final int visualLineCount = visibleLines.length < widget.minLines
        ? widget.minLines
        : visibleLines.length;
    return SizedBox(
      height: style.padding.vertical + visualLineCount * lineHeight,
      child: Stack(
        children: <Widget>[
          if (widget.showLineNumbers) _buildGutter(style),
          _buildScopeGuide(style, foldLayout),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _resumeEditing,
              child: SingleChildScrollView(
                padding: _contentPadding(style),
                child: _buildHighlightedText(
                  style,
                  text: visibleLines
                      .map((JsonFoldLine line) => line.displayText)
                      .join('\n'),
                ),
              ),
            ),
          ),
          if (widget.showLineNumbers) _buildLineNumbers(style, foldLayout),
        ],
      ),
    );
  }

  /// 在正文缩进列上绘制与折叠布局同步的灰色括号作用域线。
  Widget _buildScopeGuide(
    JsonEditorStyle style,
    JsonFoldLayout foldLayout,
  ) {
    return Positioned.fill(
      child: IgnorePointer(
        child: JsonScopeGuide(
          key: const ValueKey<String>('json-editor-scope-guide'),
          foldLayout: foldLayout,
          textStyle: style.textStyle,
          contentLeft:
              widget.showLineNumbers ? _gutterWidth + 12 : style.padding.left,
          contentTop: style.padding.top,
          lineHeight: _resolveLineHeight(style),
          color: style.scopeGuideColor,
        ),
      ),
    );
  }

  /// 清除折叠并在下一帧恢复输入焦点。
  void _resumeEditing() {
    setState(_collapsedLineIndexes.clear);
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  /// 输入层已经位于 gutter 右侧，只需保留正文内部留白。
  EdgeInsets _editablePadding(JsonEditorStyle style) {
    if (!widget.showLineNumbers) return style.padding;
    return EdgeInsets.fromLTRB(
      12,
      style.padding.top,
      style.padding.right,
      style.padding.bottom,
    );
  }

  /// 为行号槽预留固定宽度，保证高亮层与输入层保持相同起点。
  EdgeInsets _contentPadding(JsonEditorStyle style) {
    if (!widget.showLineNumbers) return style.padding;
    return EdgeInsets.fromLTRB(
      _gutterWidth + 12,
      style.padding.top,
      style.padding.right,
      style.padding.bottom,
    );
  }

  /// 绘制独立的浅色行号槽和正文分隔线。
  Widget _buildGutter(JsonEditorStyle style) {
    final Color gutterColor = Color.alphaBlend(
      style.disabledColor.withValues(alpha: 0.58),
      style.backgroundColor,
    );
    return Positioned.fill(
      right: null,
      child: IgnorePointer(
        child: Container(
          width: _gutterWidth,
          decoration: BoxDecoration(
            color: gutterColor,
            border: Border(
              right: BorderSide(
                color: style.borderColor.withValues(alpha: 0.72),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 当前行使用克制的横向底色，覆盖 gutter 与正文区域。
  Widget _buildCurrentLineHighlight(JsonEditorStyle style) {
    final double lineHeight = _resolveLineHeight(style);
    return Positioned(
      key: const ValueKey<String>('json-editor-current-line'),
      left: 0,
      right: 0,
      top: style.padding.top + _currentLineIndex * lineHeight,
      height: lineHeight,
      child: IgnorePointer(
        child: ColoredBox(
          color: style.focusBorderColor.withValues(
            alpha: _isFocused ? 0.09 : 0.045,
          ),
        ),
      ),
    );
  }

  /// 根据当前物理换行数量构建与正文行高一致的行号槽。
  Widget _buildLineNumbers(
    JsonEditorStyle style,
    JsonFoldLayout foldLayout,
  ) {
    final List<JsonFoldLine> lines = foldLayout.visibleLines;
    final double lineHeight = _resolveLineHeight(style);
    return Positioned(
      left: 0,
      top: style.padding.top,
      width: _gutterWidth - 1,
      child: Column(
        children: List<Widget>.generate(lines.length, (int index) {
          final JsonFoldLine line = lines[index];
          final bool isCurrentLine = line.sourceIndex == _currentLineIndex;
          return SizedBox(
            height: lineHeight,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    '${line.sourceIndex + 1}',
                    textAlign: TextAlign.right,
                    style: style.textStyle.copyWith(
                      color: isCurrentLine
                          ? style.focusBorderColor
                          : style.disabledIconColor,
                      fontWeight:
                          isCurrentLine ? FontWeight.w600 : FontWeight.w400,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 19,
                  child: line.foldEnd != null
                      ? _buildFoldButton(style, line)
                      : null,
                ),
                const SizedBox(width: 3),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// 构建可点击折叠按钮，点击只改变显示布局，不修改 JSON 数据。
  Widget _buildFoldButton(JsonEditorStyle style, JsonFoldLine line) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: ValueKey<String>('json-editor-fold-${line.sourceIndex}'),
        behavior: HitTestBehavior.opaque,
        onTap: () => _toggleFold(line.sourceIndex),
        child: Icon(
          line.collapsed
              ? Icons.chevron_right_rounded
              : Icons.keyboard_arrow_down_rounded,
          size: 14,
          color: style.disabledIconColor,
        ),
      ),
    );
  }

  /// 切换指定源码区块的折叠状态。
  void _toggleFold(int sourceLineIndex) {
    setState(() {
      if (!_collapsedLineIndexes.remove(sourceLineIndex)) {
        _collapsedLineIndexes.add(sourceLineIndex);
      }
    });
  }

  /// 使用实际文本度量值统一正文、行号和活动行的垂直节奏。
  double _resolveLineHeight(JsonEditorStyle style) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: 'M', style: style.textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      strutStyle: _textStrut(style),
    )..layout();
    return painter.height;
  }

  /// 强制输入层和语法高亮层使用完全一致的行高与字体度量。
  StrutStyle _textStrut(JsonEditorStyle style) {
    return StrutStyle.fromTextStyle(
      style.textStyle,
      forceStrutHeight: true,
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

  Widget _buildHighlightedText(JsonEditorStyle style, {String? text}) {
    final String source = text ?? _controller.text;
    if (source.isEmpty) return const SizedBox.shrink();

    return RichText(
      strutStyle: _textStrut(style),
      text: TextSpan(
        style: style.textStyle,
        children: JsonHighlightController.highlight(source, style),
      ),
    );
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
