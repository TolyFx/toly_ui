import 'package:flutter/material.dart';

class TolyTag extends StatefulWidget {
  final Color tagColor;
  final String tagText;
  final Size? size;
  final TextStyle? tagStyle;
  final double radius;
  final VoidCallback? close;
  final VoidCallback? click;
  final EdgeInsetsGeometry? padding;

  const TolyTag({super.key,
    this.tagColor = Colors.blue,
    this.tagText = "toly",
    this.size,
    this.tagStyle,
    this.radius = 8,
    this.close,
    this.click,
    this.padding});

  @override
  State<TolyTag> createState() => _TolyTagState();
}

class _TolyTagState extends State<TolyTag> {
  late Color hoverColor;

  Color defColor = Colors.transparent;

  @override
  void initState() {
    hoverColor = widget.tagColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle tagText = widget.tagStyle ?? const TextStyle(color: Colors.white, fontSize: 14);
    EdgeInsetsGeometry padding = widget.padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 3);
    Widget child = Text(widget.tagText, style: tagText);
    if (widget.click != null) {
      child = GestureDetector(
        onTap: widget.click,
        child: child,
      );
    }

    if (widget.close != null) {
      child = Wrap(
        children: [
          child,
          const SizedBox(width: 5,),
          MouseRegion(
            onHover: (p) {
              setState(() {
                hoverColor = Colors.white;
                defColor = widget.tagColor;
              });
            },
            onExit: (p) {
              setState(() {
                hoverColor = widget.tagColor;
                defColor = Colors.transparent;
              });
            },
            child: GestureDetector(
              onTap: widget.close,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(tagText.fontSize!),
                  color: defColor,
                ),
                child: Icon(
                  Icons.close,
                  color: hoverColor,
                  size: tagText.fontSize,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container(
      padding: padding,
      width: widget.size?.width,
      height: widget.size?.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        color: widget.tagColor,
      ),
      child: child,
    );
  }

  ///为什么不刷新
  Widget _closeButton(Color color) {
    Color hoverColor = color;
    Color defColor = Colors.transparent;
    return MouseRegion(
      onHover: (p) {
        setState(() {
          hoverColor = Colors.white;
          defColor = color;
        });
      },
      onExit: (p) {
        setState(() {
          hoverColor = widget.tagColor;
          defColor = Colors.transparent;
        });
      },
      child: GestureDetector(
        onTap: widget.close,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: defColor,
          ),
          child: Icon(
            Icons.close,
            color: hoverColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}
