import 'package:flutter/material.dart';

import '../theme/form_theme.dart';

/// 按钮组点击回调。
typedef TolyButtonGroupPressed<T> = void Function(T value);

/// 紧凑按钮组中的单个按钮配置。
@immutable
class TolyButtonGroupItem<T> {
  /// 按钮对应的业务值。
  final T value;

  /// 按钮图标。
  final Widget icon;

  /// 鼠标悬停提示。
  final String? tooltip;

  /// 是否允许点击。
  final bool enabled;

  const TolyButtonGroupItem({
    required this.value,
    required this.icon,
    this.tooltip,
    this.enabled = true,
  });
}

/// Figma 属性面板风格的紧凑分段按钮组。
class TolyButtonGroup<T> extends StatelessWidget {
  /// 按钮配置列表。
  final List<TolyButtonGroupItem<T>> items;

  /// 当前选中的值；动作按钮组可不传。
  final Set<T> selectedValues;

  /// 按钮点击回调。
  final TolyButtonGroupPressed<T>? onPressed;

  /// 单个按钮宽度；为空时所有按钮均分可用宽度。
  final double? itemWidth;

  /// 按钮之间的分隔线颜色。
  final Color? separatorColor;

  /// 视觉密度。
  final TolyFormDensity density;

  const TolyButtonGroup({
    super.key,
    required this.items,
    this.selectedValues = const {},
    this.onPressed,
    this.itemWidth = 40,
    this.separatorColor,
    this.density = TolyFormDensity.compact,
  });

  @override
  Widget build(BuildContext context) {
    final TolyFormThemeData theme = TolyFormThemeData.of(context);
    return SizedBox(
      height: theme.heightOf(density),
      child: ClipRRect(
        borderRadius: theme.borderRadius,
        child: ColoredBox(
          color: theme.fillColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(items.length, (int index) {
              return _buildItem(context, theme, index);
            }),
          ),
        ),
      ),
    );
  }

  /// 构建按钮及其左侧分隔线。
  Widget _buildItem(
    BuildContext context,
    TolyFormThemeData theme,
    int index,
  ) {
    final TolyButtonGroupItem<T> item = items[index];
    final bool enabled = item.enabled && onPressed != null;
    final bool selected = selectedValues.contains(item.value);
    final Widget button = SizedBox(
      height: theme.heightOf(density),
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          key: ValueKey<T>(item.value),
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? () => onPressed!(item.value) : null,
          child: DecoratedBox(
            key: ValueKey<String>(
              'toly-button-group-selection-${item.value}',
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).colorScheme.surface
                  : Colors.transparent,
              border: selected
                  ? Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.55),
                      width: 0.5,
                    )
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              boxShadow: selected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.shadow.withValues(alpha: 0.08),
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: IconTheme.merge(
              data: IconThemeData(
                size: 14,
                color: enabled
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).disabledColor,
              ),
              child: Center(child: item.icon),
            ),
          ),
        ),
      ),
    );
    final Widget content = item.tooltip == null
        ? button
        : Tooltip(message: item.tooltip!, child: button);
    final Widget decoratedContent = index == 0
        ? content
        : Stack(
            fit: StackFit.expand,
            children: <Widget>[
              content,
              Align(
                alignment: Alignment.centerLeft,
                child: IgnorePointer(
                  child: Container(
                    key: ValueKey<String>(
                      'toly-button-group-separator-$index',
                    ),
                    width: 1,
                    height: theme.heightOf(density),
                    color: separatorColor ??
                        Theme.of(
                          context,
                        ).dividerColor.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ],
          );
    return itemWidth == null
        ? Expanded(child: decoratedContent)
        : SizedBox(width: itemWidth, child: decoratedContent);
  }
}
