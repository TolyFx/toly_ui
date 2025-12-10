import 'dart:ui';

import 'package:flutter/material.dart';

class TolyCheckBox extends StatefulWidget {
  final bool value;
  final Widget? label;
  final bool indeterminate;
  final double labelSpacing;
  final double size;
  final BorderRadius? borderRadius;
  final ValueChanged<bool> onChanged;

  const TolyCheckBox({
    super.key,
    required this.value,
    this.indeterminate = false,
    this.label,
    this.labelSpacing = 6,
    this.size = 16,
    this.borderRadius,
    required this.onChanged,
  });

  @override
  State<TolyCheckBox> createState() => _TolyCheckBoxState();
}

class _TolyCheckBoxState extends State<TolyCheckBox> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.indeterminate) {
      child = indeterminateState();
    } else if (widget.value) {
      child = select();
    } else {
      child = unselect();
    }

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
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(widget.size * 0.125)),
      child: Icon(
        Icons.check,
        size: widget.size * 0.75,
        color: Colors.white,
      ),
    );
  }

  Widget indeterminateState() {
    return Container(
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(widget.size * 0.125)),
      child: Container(
        width: widget.size * 0.5,
        height: 2,
        color: Colors.white,
      ),
    );
  }

  Widget unselect() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _hover ? Colors.blue : Color(0xffdcdfe6), width: 1),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(widget.size * 0.125)),
    );
  }
}
