import 'dart:ui';

import 'package:flutter/material.dart';

class TolyCheckBox extends StatefulWidget {
  final bool value;
  final Widget? label;
  final bool indeterminate;
  final double labelSpacing;
  final ValueChanged<bool> onChanged;

  const TolyCheckBox({
    super.key,
    required this.value,
    this.indeterminate = false,
    this.label,
    this.labelSpacing = 6,
    required this.onChanged,
  });

  @override
  State<TolyCheckBox> createState() => _TolyCheckBoxState();
}

class _TolyCheckBoxState extends State<TolyCheckBox> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    Widget child = widget.value ? select() : unselect();

    if (widget.label != null) {
      child = Wrap(
        spacing: widget.labelSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [child, widget.label!],
      );
    }

    return MouseRegion(
      onExit: (_) => setState(() => _hover = false),
      onEnter: (_) => setState(() => _hover = true),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onChanged(!widget.value),
        child: child,
      ),
    );
  }

  Widget select() {
    return Container(
      width: 16,
      height: 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: widget.indeterminate ? Colors.white : Colors.blue,
          border: widget.indeterminate
              ? Border.all(
                  color: _hover ? Colors.blue : Color(0xffdcdfe6),
                  width: 1 / window.devicePixelRatio)
              : null,
          borderRadius: BorderRadius.circular(2)),
      child: Icon(
        Icons.check,
        size: 12,
        color: widget.indeterminate ? Colors.blue : Colors.white,
      ),
    );
  }

  Widget unselect() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _hover ? Colors.blue : Color(0xffdcdfe6), width: 1),
          borderRadius: BorderRadius.circular(2)),
    );
  }
}
