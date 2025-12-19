import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tolyui_message.dart';

class MessagePanel extends StatelessWidget {
  final String? message;
  final bool plain;
  final InlineSpan? richMessage;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final VoidCallback? onClose;

  const MessagePanel({
    super.key,
    this.message,
    this.plain = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.onClose,
    this.icon,
    this.richMessage,
  });

  Decoration decoration(BuildContext context) {
    TolyMessageStyleTheme? theme =
        Theme.of(context).extension<TolyMessageStyleTheme>();
    BorderRadius borderRadius = theme?.borderRadius ?? BorderRadius.circular(4);
    if (plain) {
      bool isDark = Theme.of(context).brightness == Brightness.dark;

      return BoxDecoration(
          color: isDark ? backgroundColor : Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            )
          ]);
    }
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: borderColor ?? Colors.transparent),
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration(context),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 18,
              color: foregroundColor,
            ),
          Text.rich(
            richMessage ?? TextSpan(text: message),
            style: TextStyle(color: foregroundColor),
          ),
          if (onClose != null)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    CupertinoIcons.clear,
                    size: 16,
                    color: Color(0xffa8abb2),
                  )),
            )
        ],
      ),
    );
  }
}
