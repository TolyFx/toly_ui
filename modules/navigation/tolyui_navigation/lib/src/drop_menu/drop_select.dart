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

  /// 是否允许选择。
  final bool enabled;

  const TolyDropSelectOption({
    required this.value,
    required this.label,
    this.leading,
    this.trailing,
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

  /// 触发器高度。
  final double height;

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildWithConstraints);
  }

  Widget _buildWithConstraints(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final double menuWidth =
        constraints.hasBoundedWidth ? constraints.maxWidth : 160;
    return MenuAnchor(
      crossAxisUnconstrained: false,
      alignmentOffset: Offset(0, widget.menuGap),
      style: _menuStyle(context, menuWidth),
      onOpen: () => setState(() => _open = true),
      onClose: () => setState(() => _open = false),
      menuChildren: _buildMenuChildren(),
      builder: _buildTrigger,
    );
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
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.all(4),
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
    final bool enabled = widget.enabled && widget.onChanged != null;
    return SizedBox(
      width: double.infinity,
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
              children: <Widget>[
                if (prefix != null) ...<Widget>[
                  IconTheme.merge(
                    data: const IconThemeData(size: 14),
                    child: prefix,
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(
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
                if (selected?.trailing != null) ...<Widget>[
                  const SizedBox(width: 8),
                  _buildTrailing(
                    selected!.trailing!,
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
      trailingIcon: _buildOptionTrailing(option, selected, colors),
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll<Size>(Size(0, 32)),
        maximumSize: const WidgetStatePropertyAll<Size>(
          Size(double.infinity, 32),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 8),
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
        textStyle: const WidgetStatePropertyAll<TextStyle>(
          TextStyle(fontSize: 13, height: 1.25, fontWeight: FontWeight.w400),
        ),
      ),
      child: Text(option.label),
    );
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
        if (selected) const Icon(Icons.check, size: 14),
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
