import 'package:flutter/material.dart';

import '../theme/form_theme.dart';
import 'type_action_option.dart';
import 'type_action_target.dart';

export 'type_action_option.dart';

/// 组合控件使用细边线，避免缩放画布后线条过重。
const double _typeActionBorderWidth = .5;

/// 将类型选择与纯图标动作合为一行的受控表单组件。
///
/// 业务负责接收新类型、执行动作和维护 [actionRunning]；组件不访问平台能力。
class TolyTypeActionSelector<T extends Object> extends StatefulWidget {
  /// 当前类型；为空或不在选项中时显示占位内容并禁用动作。
  final T? value;

  /// 类型及其对应的动作配置，类型值必须唯一。
  final List<TolyTypeActionOption<T>> options;

  /// 用户选择不同类型时通知宿主，由宿主更新 [value]。
  final ValueChanged<T>? onTypeChanged;

  /// 手动或自动执行动作，参数始终为本次动作对应的类型。
  final ValueChanged<T>? onAction;

  /// 用户选择菜单项后是否执行一次动作，重复选择当前项也可执行，默认关闭。
  final bool autoTriggerOnSelect;

  /// 是否允许组件交互。
  final bool enabled;

  /// 是否允许执行动作；关闭时仍可切换类型。
  final bool actionEnabled;

  /// 宿主动作是否正在执行；忙碌时禁用两区，避免重复请求。
  final bool actionRunning;

  /// 没有合法选中类型时的占位文案。
  final String placeholder;

  /// 视觉密度；具体高度由表单主题提供。
  final TolyFormDensity density;

  /// 固定动作区域宽度，窄容器优先保留动作入口。
  final double actionWidth;

  /// 类型区可单独设置底色；为空时沿用整体字段底色。
  final Color? typeBackgroundColor;

  /// 类型文字字号。
  final double fontSize;

  const TolyTypeActionSelector({
    super.key,
    required this.value,
    required this.options,
    this.onTypeChanged,
    this.onAction,
    this.autoTriggerOnSelect = false,
    this.enabled = true,
    this.actionEnabled = true,
    this.actionRunning = false,
    this.placeholder = '请选择类型',
    this.density = TolyFormDensity.compact,
    this.actionWidth = 26,
    this.fontSize = 11,
    this.typeBackgroundColor,
  })  : assert(actionWidth > 0),
        assert(fontSize > 0);

  @override
  State<TolyTypeActionSelector<T>> createState() =>
      _TolyTypeActionSelectorState<T>();
}

class _TolyTypeActionSelectorState<T extends Object>
    extends State<TolyTypeActionSelector<T>> {
  /// 类型菜单由组件持有，不参与业务动作状态。
  final MenuController _menu = MenuController();

  /// 用实际屏幕尺寸计算画布缩放后的菜单宽度。
  final GlobalKey _fieldKey = GlobalKey();

  /// 弹层跟随锚点的缩放，避免画布放大后菜单仍保持原始大小。
  double _menuScale = 1;

  /// 任一区域获得焦点时，共同显示外边框反馈。
  bool _focused = false;

  TolyTypeActionOption<T>? get _selected {
    for (final TolyTypeActionOption<T> option in widget.options) {
      if (option.value == widget.value) return option;
    }
    return null;
  }

  bool get _canSelect =>
      widget.enabled &&
      !widget.actionRunning &&
      widget.onTypeChanged != null &&
      widget.options.any((TolyTypeActionOption<T> item) => item.enabled);

  bool _canAct(TolyTypeActionOption<T>? option) =>
      widget.enabled &&
      widget.actionEnabled &&
      !widget.actionRunning &&
      widget.onAction != null &&
      option != null &&
      option.enabled;

  /// 类型变化先通知宿主，再按配置触发同一个动作入口。
  void _choose(TolyTypeActionOption<T> option) {
    _menu.close();
    if (!_canSelect || !option.enabled) return;
    if (option.value != widget.value) widget.onTypeChanged!(option.value);
    if (widget.autoTriggerOnSelect) _act(option);
  }

  void _act(TolyTypeActionOption<T>? option) {
    if (_canAct(option)) widget.onAction!(option!.value);
  }

  /// 弹层位于 Overlay，展开时同步锚点当前的屏幕缩放。
  void _toggleMenu() {
    if (_menu.isOpen) {
      _menu.close();
      return;
    }
    final RenderObject? render = _fieldKey.currentContext?.findRenderObject();
    if (render is RenderBox && render.hasSize && render.size.width > 0) {
      final Offset origin = render.localToGlobal(Offset.zero);
      final double width =
          (render.localToGlobal(Offset(render.size.width, 0)) - origin)
              .distance;
      setState(() => _menuScale = width / render.size.width);
    }
    _menu.open();
  }

  void _focusChanged(bool focused) => setState(() => _focused = focused);

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(key: _fieldKey, builder: _buildField);

  /// 菜单使用完整组合控件的宽度，包含右侧动作区。
  Widget _buildField(BuildContext context, BoxConstraints constraints) {
    assert(
      widget.options
              .map((TolyTypeActionOption<T> item) => item.value)
              .toSet()
              .length ==
          widget.options.length,
      '类型动作选择器的类型值必须唯一',
    );
    final TolyFormThemeData theme = TolyFormThemeData.of(context);
    final TolyTypeActionOption<T>? option = _selected;
    final double height = theme.heightOf(widget.density);
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _focusChanged,
      child: Container(
        key: const ValueKey<String>('toly-type-action-frame'),
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.enabled ? theme.fillColor : theme.disabledFillColor,
          borderRadius: theme.borderRadius,
          border: Border.all(
            color: _focused ? theme.focusBorderColor : theme.borderColor,
            width: _typeActionBorderWidth,
          ),
        ),
        child: Row(
          children: [
            Expanded(
                child: ColoredBox(
              color: widget.enabled
                  ? widget.typeBackgroundColor ?? theme.fillColor
                  : theme.disabledFillColor,
              child: _buildSelect(context, theme, height, option,
                  constraints.maxWidth * _menuScale),
            )),
            VerticalDivider(
                width: _typeActionBorderWidth,
                thickness: _typeActionBorderWidth,
                color: theme.borderColor),
            SizedBox(
              width: widget.actionWidth,
              child: TypeActionTarget(
                key: const ValueKey<String>('toly-type-action-execute'),
                enabled: _canAct(option),
                label: widget.actionRunning
                    ? '动作执行中'
                    : option?.actionLabel ?? '请先选择类型',
                accent: theme.focusBorderColor,
                onPressed: () => _act(option),
                child: IconTheme.merge(
                  data: IconThemeData(
                      color: _canAct(option)
                          ? theme.focusBorderColor
                          : Theme.of(context).disabledColor),
                  child: option?.actionIcon ??
                      const SizedBox.square(dimension: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelect(
    BuildContext context,
    TolyFormThemeData theme,
    double height,
    TolyTypeActionOption<T>? selected,
    double menuWidth,
  ) {
    return MenuAnchor(
      controller: _menu,
      alignmentOffset:
          Offset(-_typeActionBorderWidth * _menuScale, 4 * _menuScale),
      crossAxisUnconstrained: false,
      style: MenuStyle(
        minimumSize: WidgetStatePropertyAll<Size>(Size(menuWidth, 0)),
        maximumSize:
            WidgetStatePropertyAll<Size>(Size(menuWidth, double.infinity)),
        elevation: const WidgetStatePropertyAll<double>(4),
        shadowColor: const WidgetStatePropertyAll<Color>(Color(0x18243B5A)),
        backgroundColor: WidgetStatePropertyAll<Color>(
          Theme.of(context).colorScheme.surface,
        ),
        surfaceTintColor:
            const WidgetStatePropertyAll<Color>(Colors.transparent),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.all(4 * _menuScale)),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: theme.borderRadius,
            side: BorderSide(
                color: theme.borderColor, width: _typeActionBorderWidth),
          ),
        ),
      ),
      menuChildren: widget.options
          .map((TolyTypeActionOption<T> option) =>
              _buildOption(option, menuWidth))
          .toList(growable: false),
      child: SizedBox(
        height: height,
        child: TypeActionTarget(
          key: const ValueKey<String>('toly-type-action-select'),
          enabled: _canSelect,
          label: selected?.label ?? widget.placeholder,
          accent: theme.focusBorderColor,
          onPressed: _toggleMenu,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected?.label ?? widget.placeholder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: widget.fontSize),
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 菜单项左对齐，选中项使用主色浅底和勾选标记。
  Widget _buildOption(TolyTypeActionOption<T> option, double menuWidth) {
    final TolyFormThemeData theme = TolyFormThemeData.of(context);
    final bool selected = option.value == widget.value;
    return Semantics(
      selected: selected,
      child: SizedBox(
        width: menuWidth - 8 * _menuScale,
        height: theme.heightOf(widget.density) * _menuScale,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected
                ? theme.focusBorderColor.withValues(alpha: .08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
          child: TypeActionTarget(
            enabled: _canSelect && option.enabled,
            label: option.label,
            accent: theme.focusBorderColor,
            onPressed: () => _choose(option),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8 * _menuScale),
              child: Row(children: [
                Expanded(
                    child: Text(option.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: widget.fontSize * _menuScale,
                            color: selected && option.enabled
                                ? theme.focusBorderColor
                                : null))),
                if (selected)
                  Icon(Icons.check_rounded,
                      size: 12 * _menuScale, color: theme.focusBorderColor),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
