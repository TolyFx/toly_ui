import 'package:flutter/material.dart';

const TextStyle _defaultTagStyle = TextStyle(color: Colors.blue, fontSize: 14);

class TolyTag extends StatefulWidget {
  final String tagText;
  final Color? tagBgColor;
  final bool hasBorder;
  final Size? size;
  final TextStyle? tagStyle;
  final double radius;
  final VoidCallback? close;
  final VoidCallback? click;
  final EdgeInsetsGeometry? padding;

  const TolyTag(
      {super.key,
      this.tagText = "toly",
      this.tagBgColor,
      this.size,
      this.tagStyle,
      this.radius = 8,
      this.close,
      this.click,
      this.padding,
      this.hasBorder = true});

  @override
  State<TolyTag> createState() => _TolyTagState();
}

class _TolyTagState extends State<TolyTag> {
  late Color hoverColor;
  Color? defColor;

  @override
  void initState() {
    hoverColor = widget.tagStyle?.color ?? _defaultTagStyle.color!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle tagText = widget.tagStyle ?? _defaultTagStyle;
    EdgeInsetsGeometry padding = widget.padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 3);
    Widget child = Text(widget.tagText, style: tagText);
    Color? tagBgColor = widget.tagBgColor ?? (widget.tagStyle?.color ?? _defaultTagStyle.color)?.withOpacity(0.2);
    BoxDecoration tagDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(widget.radius),
      border: widget.hasBorder
          ? Border.all(
              color: widget.tagStyle?.color ?? _defaultTagStyle.color!,
              width: 1,
            )
          : null,
      color: tagBgColor,
    );
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
          const SizedBox(width: 5),
          MouseRegion(
            onHover: (p) {
              setState(() {
                hoverColor = Colors.white;
                defColor = widget.tagStyle?.color ?? _defaultTagStyle.color!;
              });
            },
            onExit: (p) {
              setState(() {
                hoverColor = widget.tagStyle?.color ?? _defaultTagStyle.color!;
                defColor = null;
              });
            },
            child: GestureDetector(
              onTap: widget.close,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(tagText.fontSize ?? _defaultTagStyle.fontSize!),
                  color: defColor,
                ),
                child: Icon(
                  Icons.close,
                  color: hoverColor,
                  size: tagText.fontSize ?? _defaultTagStyle.fontSize!,
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
      decoration: tagDecoration,
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
          hoverColor = Colors.blue;
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
