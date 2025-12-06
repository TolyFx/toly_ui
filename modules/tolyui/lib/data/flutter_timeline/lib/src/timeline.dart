import 'package:flutter/material.dart';
import 'timeline_item.dart';
import 'types.dart';

/// Ant Design Timeline 组件的 Flutter 实现
class AntTimeline extends StatelessWidget {
  const AntTimeline({
    super.key,
    this.items = const [],
    this.children,
    this.mode = TimelineMode.start,
    this.orientation = TimelineOrientation.vertical,
    this.variant = TimelineVariant.outlined,
    this.reverse = false,
    this.pending,
    this.pendingDot,
    this.className,
    this.style,
    this.classNames,
    this.styles,
  });

  /// Timeline 项目列表
  final List<TimelineItemType> items;
  
  /// 子组件（已废弃，请使用 items）
  @Deprecated('Please use items instead')
  final List<Widget>? children;
  
  /// 显示模式
  final TimelineMode mode;
  
  /// 方向
  final TimelineOrientation orientation;
  
  /// 变体样式
  final TimelineVariant variant;
  
  /// 是否反向显示
  final bool reverse;
  
  /// 等待中的内容（已废弃）
  @Deprecated('Please add pending item in items directly')
  final Widget? pending;
  
  /// 等待中的图标（已废弃）
  @Deprecated('Please add pending item in items directly')
  final Widget? pendingDot;
  
  /// 类名（保持 API 一致性）
  final String? className;
  
  /// 根容器样式
  final BoxDecoration? style;
  
  /// 类名配置
  final TimelineClassNames? classNames;
  
  /// 样式配置
  final TimelineStyles? styles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // 处理项目列表
    List<TimelineItemType> processedItems = _processItems();
    
    if (reverse) {
      processedItems = processedItems.reversed.toList();
    }

    return Container(
      decoration: style ?? styles?.root,
      child: orientation == TimelineOrientation.horizontal
          ? _buildHorizontalTimeline(context, theme, processedItems)
          : _buildVerticalTimeline(context, theme, processedItems),
    );
  }

  List<TimelineItemType> _processItems() {
    List<TimelineItemType> processedItems = List.from(items);
    
    // 添加 pending 项目（向后兼容）
    if (pending != null) {
      processedItems.add(
        TimelineItemType(
          content: pending,
          icon: pendingDot,
          loading: pendingDot == null,
        ),
      );
    }
    
    return processedItems;
  }

  Widget _buildVerticalTimeline(
    BuildContext context,
    ThemeData theme,
    List<TimelineItemType> processedItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: processedItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == processedItems.length - 1;

        return Padding(
          padding: EdgeInsets.only(
            bottom: isLast ? 0 : 16,
          ),
          child: AntTimelineItem(
            key: item.key,
            item: item,
            isLast: isLast,
            mode: mode,
            orientation: orientation,
            index: index,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHorizontalTimeline(
    BuildContext context,
    ThemeData theme,
    List<TimelineItemType> processedItems,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: processedItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == processedItems.length - 1;

          return Row(
            children: [
              AntTimelineItem(
                key: item.key,
                item: item,
                isLast: isLast,
                mode: mode,
                orientation: orientation,
                index: index,
              ),
              if (!isLast) ...[
                Container(
                  width: 48,
                  height: 2,
                  margin: const EdgeInsets.only(top: 16),
                  color: theme.dividerColor,
                ),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}