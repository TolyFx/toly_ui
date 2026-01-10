import 'package:flutter/material.dart';

class TolyTimeline extends StatelessWidget {
  final List<TimelineItemData> items;
  final TimelineMode mode;
  final bool reverse;

  const TolyTimeline({
    super.key,
    required this.items,
    this.mode = TimelineMode.start,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = reverse ? items.reversed.toList() : items;

    return Column(
      crossAxisAlignment: mode == TimelineMode.alternate
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < displayItems.length; i++)
          _TimelineItem(
            item: displayItems[i],
            isLast: i == displayItems.length - 1,
            mode: mode,
            index: i,
          ),
      ],
    );
  }
}

enum TimelineMode { start, end, alternate }

class TimelineItemData {
  final String? content;
  final Widget? title;
  final Widget? icon;
  final Color? color;
  final bool loading;

  const TimelineItemData({
    this.content,
    this.title,
    this.icon,
    this.color,
    this.loading = false,
  });
}

class _TimelineItem extends StatelessWidget {
  final TimelineItemData item;
  final bool isLast;
  final TimelineMode mode;
  final int index;

  const _TimelineItem({
    required this.item,
    required this.isLast,
    required this.mode,
    required this.index,
  });

  Color _getColor() {
    if (item.color != null) return item.color!;
    if (item.loading) return Colors.blue;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final tailColor = const Color(0xFFF0F0F0);
    final isAlternate = mode == TimelineMode.alternate;
    final isEnd = mode == TimelineMode.end;
    final isLeft = isAlternate && index % 2 == 1;

    if (isAlternate) {
      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: isLeft
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _buildContent(TextAlign.end),
                      ),
                    )
                  : const SizedBox(),
            ),
            Column(
              children: [
                _buildIcon(color),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: tailColor,
                    ),
                  ),
              ],
            ),
            Expanded(
              child: !isLeft
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildContent(TextAlign.start),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      );
    }

    if (isEnd) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildContent(TextAlign.end),
                ),
              ),
            ),
            Column(
              children: [
                _buildIcon(color),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: tailColor,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildIcon(color),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: tailColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildContent(TextAlign.start),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContent(TextAlign textAlign) {
    return [
      if (item.title != null) item.title!,
      if (item.title != null) const SizedBox(height: 4),
      if (item.content != null)
        Text(
          item.content!,
          textAlign: textAlign,
          style: const TextStyle(color: Color(0xFF595959)),
        ),
    ];
  }

  Widget _buildIcon(Color color) {
    if (item.icon != null) {
      return SizedBox(
        width: 20,
        child: item.icon!,
      );
    }

    if (item.loading) {
      return SizedBox(
        width: 20,
        child: Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 20,
      // height: 20,
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
      ),
    );
  }
}
