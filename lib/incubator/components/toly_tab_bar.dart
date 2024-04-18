import 'package:flutter/material.dart';

class TolyMenuBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  final List<String> tabs;

  const TolyMenuBar({
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
            .map((int index) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: TolyTab(
                label: tabs[index],
                active: index == activeIndex,
              ),
            ))
            .toList());
  }
}

class TolyTab extends StatefulWidget {
  final String label;
  final bool active;

  const TolyTab({super.key, required this.label, required this.active});

  @override
  State<TolyTab> createState() => _TolyTabState();
}

class _TolyTabState extends State<TolyTab> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    TextStyle style = const TextStyle(fontSize: 14);
    if(_isHover){
      style = style.copyWith(
          color: color,
      );
    }
    if(widget.active){
      style = style.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
      );
    }

    // TextStyle style = (widget.active||_isHover)
    //     ? TextStyle(
    //         fontSize: 14,
    //         fontWeight: FontWeight.bold,
    //         color: color,
    //         shadows: [
    //             Shadow(color: Colors.white, offset: Offset(.5, .5)),
    //           ])
    //     : const TextStyle(fontSize: 14);

    return MouseRegion(
      onExit: (_) {
        setState(() {
          _isHover = false;
        });
      },
      onEnter: (_) {
        setState(() {
          _isHover = true;
        });
      },
      cursor: SystemMouseCursors.click,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: widget.active
                ? Border(bottom: BorderSide(color: color))
                : null),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              widget.label,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
