import 'package:flutter/material.dart';

class TolyTabBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  final List<String> tabs;

  const TolyTabBar({
    super.key,
    required this.onTap,
    required this.tabs,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
        children: tabs
            .asMap()
            .keys
            .map((int index) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(index),
                    child: TolyTab(
                      label: tabs[index],
                      active: index == activeIndex,
                    ),
                  ),
                ))
            .toList());
  }
}

class TolyTab extends StatelessWidget {
  final String label;
  final bool active;

  const TolyTab({super.key, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    TextStyle style = active
        ? TextStyle(fontSize: 14,
        fontWeight: FontWeight.bold,
        color: color, shadows: [
            Shadow(color: Colors.white, offset: Offset(.5, .5)),
          ])
        : const TextStyle(fontSize: 14);

    return  DecoratedBox(
      decoration: BoxDecoration(
          border: active ? Border(bottom: BorderSide(color: color)) : null),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            label,
            style: style,
          ),
        ),
      ),
    );
  }
}

class ConstraintsPrinter extends StatelessWidget {
  final Widget child;

  const ConstraintsPrinter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (ctx, cts) {
          print(cts.maxHeight);
          return child;
        });
  }
}
