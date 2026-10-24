import 'package:flutter/material.dart';

/// 下拉选择值变化回调。
typedef TolyDropSelectChanged<T> = void Function(T value);

/// 下拉选择项。
@immutable
class TolyDropSelectOption<T> {
  /// 选项值。
  final T value;

  /// 展示文本。
  final String label;

  /// 可选前置图标。
  final Widget? leading;

  /// 可选尾缀组件，可用于展示扩展名、快捷键或状态标识。
  final Widget? trailing;

  /// 触发框可使用独立尾缀，未提供时沿用菜单尾缀。
  final Widget? triggerTrailing;

  /// 是否允许选择。
  final bool enabled;

  const TolyDropSelectOption({
    required this.value,
    required this.label,
    this.leading,
    this.trailing,
    this.triggerTrailing,
    this.enabled = true,
  });
}

/// 面向属性面板的紧凑、受控下拉选择器。
class TolyDropSelect<T> extends StatefulWidget {
  /// 当前选中值。
  final T? value;

  /// 可选项。
  final List<TolyDropSelectOption<T>> options;

  /// 未选择时的占位文本。
  final String placeholder;

  /// 触发框固定前置组件；为空时使用选中项的前置图标。
  final Widget? prefix;

  /// 是否允许交互。
  final bool enabled;

  /// 紧凑菜单使用较小行高、字号和内边距，适合工具条。
  final bool compact;

  /// 触发器高度。
  final double height;

  /// 触发框按内容收紧，默认保持填满父级宽度。
  final bool shrinkWrap;

  /// 独立的浮层宽度，未设置时沿用触发框约束。
  final double? menuWidth;

  /// 浮层相对触发框水平居中，靠近屏幕边缘时仍由菜单自动避让。
  final bool centerMenu;

  /// 下拉菜单最大高度。
  final double maxMenuHeight;

  /// 触发框与菜单浮层之间的间距。
  final double menuGap;

  /// 菜单项之间的垂直间距。
  final double itemGap;

  /// 值变化回调。
  final TolyDropSelectChanged<T>? onChanged;

  const TolyDropSelect({
    super.key,
    required this.value,
    required this.options,
    this.placeholder = '请选择',
    this.prefix,
    this.enabled = true,
    this.height = 28,
    this.compact = false,
    this.shrinkWrap = false,
    this.menuWidth,
    this.centerMenu = false,
    this.maxMenuHeight = 280,
    this.menuGap = 4,
    this.itemGap = 4,
    this.onChanged,
  });

  @override
  State<TolyDropSelect<T>> createState() => _TolyDropSelectState<T>();
}

class _TolyDropSelectState<T> extends State<TolyDropSelect<T>> {
  /// 菜单是否处于展开状态。
  bool _open = false;

  /// 打开时读取触发框实际宽度，用于独立宽浮层居中。
  double _anchorWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildWithConstraints);
  }

  Widget _buildWithConstraints(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final double menuWidth = widget.menuWidth ??
        (constraints.hasBoundedWidth && !widget.shrinkWrap
            ? constraints.maxWidth
            : 160);
    return MenuAnchor(
      crossAxisUnconstrained: false,
      alignmentOffset: Offset(
          widget.centerMenu ? (_anchorWidth - menuWidth) / 2 : 0,
          widget.menuGap),
      style: _menuStyle(context, menuWidth),
      onOpen: _opened,
      onClose: () => setState(() => _open = false),
      menuChildren: _buildMenuChildren(),
      builder: _buildTrigger,
    );
  }

  void _opened() {
    final RenderObject? render = context.findRenderObject();
    setState(() {
      if (render is RenderBox && render.hasSize) {
        _anchorWidth = render.size.width;
      }
      _open = true;
    });
  }

  /// 构建带统一间距的菜单项列表。
  List<Widget> _buildMenuChildren() {
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < widget.options.length; index += 1) {
      if (index > 0 && widget.itemGap > 0) {
        children.add(SizedBox(height: widget.itemGap));
      }
      children.add(_buildOption(widget.options[index]));
    }
    return children;
  }

  /// 构建与触发器同宽的浮层样式。
  MenuStyle _menuStyle(BuildContext context, double width) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return MenuStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(colors.surface),
      elevation: const WidgetStatePropertyAll<double>(8),
      visualDensity: VisualDensity.standard,
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.all(widget.compact ? 3 : 4),
      ),
      shadowColor: WidgetStatePropertyAll<Color>(
        colors.shadow.withValues(alpha: 0.16),
      ),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      minimumSize: WidgetStatePropertyAll<Size>(Size(width, 0)),
      maximumSize: WidgetStatePropertyAll<Size>(
        Size(width, widget.maxMenuHeight),
      ),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      side: WidgetStatePropertyAll<BorderSide>(
        BorderSide(color: _antBorderColor(context), width: 0.5),
      ),
    );
  }

  Widget _buildTrigger(
    BuildContext context,
    MenuController controller,
    Widget? child,
  ) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TolyDropSelectOption<T>? selected = _selectedOption();
    final Widget? prefix = widget.prefix ?? selected?.leading;
    final Widget? trailing = selected?.triggerTrailing ?? selected?.trailing;
    final bool enabled = widget.enabled && widget.onChanged != null;
    return SizedBox(
      width: widget.shrinkWrap ? null : double.infinity,
      height: widget.height,
      child: Material(
        color: colors.onSurface.withValues(alpha: 0.045),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const ValueKey<String>('toly-drop-select-trigger'),
          onTap: enabled ? controller.open : null,
          mouseCursor:
              enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize:
                  widget.shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
              children: <Widget>[
                if (prefix != null) ...<Widget>[
                  IconTheme.merge(
                    data: const IconThemeData(size: 14),
                    child: prefix,
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  fit: widget.shrinkWrap ? FlexFit.loose : FlexFit.tight,
                  child: Text(
                    selected?.label ?? widget.placeholder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: enabled
                              ? colors.onSurface
                              : colors.onSurface.withValues(alpha: 0.38),
                        ),
                  ),
                ),
                if (trailing != null) ...<Widget>[
                  const SizedBox(width: 8),
                  _buildTrailing(
                    trailing,
                    enabled
                        ? colors.onSurfaceVariant
                        : colors.onSurface.withValues(alpha: 0.38),
                  ),
                ],
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 120),
                  child: const Icon(Icons.keyboard_arrow_down, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(TolyDropSelectOption<T> option) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool selected = option.value == widget.value;
    return MenuItemButton(
      key: ValueKey<T>(option.value),
      onPressed: option.enabled ? () => _select(option.value) : null,
      leadingIcon: option.leading,
      trailingIcon: widget.compact
          ? null
          : _buildOptionTrailing(option, selected, colors),
      style: ButtonStyle(
        tapTargetSize: widget.compact ? MaterialTapTargetSize.shrinkWrap : null,
        minimumSize:
            WidgetStatePropertyAll<Size>(Size(0, widget.compact ? 24 : 32)),
        maximumSize: WidgetStatePropertyAll<Size>(
          Size(double.infinity, widget.compact ? 24 : 32),
        ),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: widget.compact ? 6 : 8),
        ),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return selected
                ? colors.primary.withValues(alpha: 0.12)
                : _antHoverColor(context);
          }
          if (selected) {
            return colors.primary.withValues(alpha: 0.1);
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStatePropertyAll<Color>(
          option.enabled
              ? selected
                  ? colors.primary
                  : colors.onSurface
              : colors.onSurface.withValues(alpha: 0.38),
        ),
        overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(
              fontSize: widget.compact ? 11 : 13,
              height: 1.25,
              fontWeight: FontWeight.w400),
        ),
      ),
      child: widget.compact
          ? _compactLabel(option, selected, colors)
          : Text(option.label,
              maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis),
    );
  }

  /// 紧凑行自行安排尾缀间距，避免系统菜单额外间隔挤压四字母格式名。
  Widget _compactLabel(
      TolyDropSelectOption<T> option, bool selected, ColorScheme colors) {
    final Widget? trailing = _buildOptionTrailing(option, selected, colors);
    return Row(children: [
      Expanded(
          child: Text(option.label,
              maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis)),
      if (trailing != null) ...[
        const SizedBox(width: 4),
        trailing,
      ],
    ]);
  }

  /// 构建菜单项尾缀，并允许它与选中勾选同时展示。
  Widget? _buildOptionTrailing(
    TolyDropSelectOption<T> option,
    bool selected,
    ColorScheme colors,
  ) {
    if (option.trailing == null && !selected) return null;
    final Color color = option.enabled
        ? selected
            ? colors.primary
            : colors.onSurfaceVariant
        : colors.onSurface.withValues(alpha: 0.38);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (selected) Icon(Icons.check, size: widget.compact ? 12 : 14),
        if (option.trailing != null && selected) const SizedBox(width: 8),
        if (option.trailing != null) _buildTrailing(option.trailing!, color),
      ],
    );
  }

  /// 为自定义尾缀提供适合紧凑下拉框的默认文字与图标样式。
  Widget _buildTrailing(Widget trailing, Color color) {
    return IconTheme.merge(
      data: IconThemeData(size: 14, color: color),
      child: DefaultTextStyle.merge(
        style: TextStyle(fontSize: 11, color: color),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: trailing,
      ),
    );
  }

  TolyDropSelectOption<T>? _selectedOption() {
    for (final TolyDropSelectOption<T> option in widget.options) {
      if (option.value == widget.value) return option;
    }
    return null;
  }

  void _select(T value) {
    widget.onChanged?.call(value);
  }

  Color _antHoverColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xfff5f5f5)
        : Colors.white.withValues(alpha: 0.08);
  }

  Color _antBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xffededed)
        : Colors.white.withValues(alpha: 0.1);
  }
}
