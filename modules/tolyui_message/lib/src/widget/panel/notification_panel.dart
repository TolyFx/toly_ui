import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tolyui_message.dart';

class NotificationPanel extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final IconData? icon;
  final Color? foregroundColor;
  final VoidCallback? onClose;

  const NotificationPanel({
    super.key,
    this.onClose,
    this.icon,
    this.foregroundColor,
    required this.title,
    required this.subtitle,
  });

  Decoration decoration(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TolyMessageStyleTheme? theme =
        Theme.of(context).extension<TolyMessageStyleTheme>();
    BorderRadius borderRadius =
        theme?.noticeBorderRadius ?? BorderRadius.circular(4);

    return BoxDecoration(
        color: isDark ? const Color(0xff1d1e1f) : Colors.white,
        borderRadius: borderRadius,
        border: isDark ? Border.all(color: const Color(0xff363637)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 0,
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration(context),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [],
          // ),
          if (icon != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Icon(
                icon,
                size: 20,
                color: foregroundColor,
              ),
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    title,
                    const Spacer(),
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
                const SizedBox(height: 6),
                subtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
