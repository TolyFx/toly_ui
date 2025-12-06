import 'package:flutter/material.dart';
import 'types.dart';

/// Timeline 单个项目组件
class AntTimelineItem extends StatelessWidget {
  const AntTimelineItem({
    super.key,
    required this.item,
    required this.isLast,
    required this.mode,
    required this.orientation,
    this.index = 0,
  });

  final TimelineItemType item;
  final bool isLast;
  final TimelineMode mode;
  final TimelineOrientation orientation;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAlternate = mode == TimelineMode.alternate;
    final isEnd = mode == TimelineMode.end || 
        (isAlternate && index % 2 == 1);

    if (orientation == TimelineOrientation.horizontal) {
      return _buildHorizontalItem(context, theme);
    }

    return _buildVerticalItem(context, theme, isEnd);
  }

  Widget _buildVerticalItem(BuildContext context, ThemeData theme, bool isEnd) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isEnd) ...[
          _buildContent(context, theme),
          const SizedBox(width: 16),
        ],
        _buildIconSection(context, theme),
        if (isEnd) ...[
          const SizedBox(width: 16),
          _buildContent(context, theme),
        ],
      ],
    );
  }

  Widget _buildHorizontalItem(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        _buildIconSection(context, theme),
        const SizedBox(height: 8),
        _buildContent(context, theme),
      ],
    );
  }

  Widget _buildIconSection(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        _buildIcon(context, theme),
        if (!isLast && orientation == TimelineOrientation.vertical)
          _buildRail(context, theme),
      ],
    );
  }

  Widget _buildIcon(BuildContext context, ThemeData theme) {
    Widget iconWidget;
    
    if (item.loading) {
      iconWidget = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            item.color ?? theme.colorScheme.primary,
          ),
        ),
      );
    } else if (item.icon != null) {
      iconWidget = item.icon!;
    } else {
      iconWidget = Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: item.color ?? theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
      );
    }

    return RepaintBoundary(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: item.color ?? theme.colorScheme.primary,
            width: 2,
          ),
        ),
        child: Center(child: iconWidget),
      ),
    );
  }

  Widget _buildRail(BuildContext context, ThemeData theme) {
    return Container(
      width: 2,
      height: 24,
      color: theme.dividerColor,
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.title != null) ...[
              DefaultTextStyle(
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                child: item.title!,
              ),
              const SizedBox(height: 4),
            ],
            if (item.content != null)
              DefaultTextStyle(
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                ),
                child: item.content!,
              ),
          ],
        ),
      ),
    );
  }
}