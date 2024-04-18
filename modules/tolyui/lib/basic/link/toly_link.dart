import 'package:flutter/material.dart';

import 'link_theme.dart';



class TolyLink extends StatefulWidget {
  final String text;
  final ValueChanged<String>? onTap;
  final TextStyle? style;
  final Color? hoverColor;
  final String href;
  final LineType? lineType;

  const TolyLink({
    super.key,
    required this.href,
    this.lineType,
    required this.text,
    this.style,
    this.hoverColor,
    required this.onTap,
  });

  @override
  State<TolyLink> createState() => _TolyLinkState();
}

class _TolyLinkState extends State<TolyLink> {
  bool _isHover = false;

  TextDecoration get decoration {
    LineType underLine = widget.lineType ??
        Theme.of(context).extension<LinkTheme>()?.lineType ??
        LineType.active;
    if (underLine == LineType.none||disable) return TextDecoration.none;
    if (underLine == LineType.always) return TextDecoration.underline;
    return _isHover ? TextDecoration.underline : TextDecoration.none;
  }

  bool get disable =>widget.onTap==null;

  Color? get textColor {
    return (_isHover&&!disable)
      ? widget.hoverColor ??
          Theme.of(context).extension<LinkTheme>()?.hoverColor
      : null;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = widget.style ??
        Theme.of(context).extension<LinkTheme>()?.style ??
        const TextStyle();

    if(disable){
      style = style.copyWith(
        color: style.color?.withOpacity(0.6)
      );
    }

    return MouseRegion(
      cursor: disable?SystemMouseCursors.forbidden:  SystemMouseCursors.click,
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
      child: GestureDetector(
        onTap: () => widget.onTap?.call(widget.href),
        child: Text(widget.text,
            style: style.copyWith(
                decoration: decoration,
                color: textColor,
                decorationColor: textColor)
            // TextStyle(),
            ),
      ),
    );
  }
}
