import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../../tolyui_feedback_modal.dart';

/// create by 张风捷特烈 on 2021/1/11
/// contact me by email 1981462002@qq.com
/// 说明:

class TolyPopPicker<T> extends StatelessWidget {
  final List<TolyMenuItem<T>> tasks;
  final OnStateChange<T>? onStatusChange;
  final Widget? title;
  final String? message;
  final String cancelText;
  final TolyPopPickerTheme? theme;

  const TolyPopPicker({
    super.key,
    this.title,
    this.message,
    required this.tasks,
    this.cancelText = "取消",
    this.theme,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    TolyPopPickerTheme effectTheme = theme ?? TolyPopPickerTheme.of(context);
    Color? background = effectTheme.backgroundColor;
    BorderRadius radius = BorderRadius.vertical(
      top: Radius.circular(effectTheme.borderRadius ?? 0),
    );

    List<Widget> children = buildItems(context, effectTheme);

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(systemNavigationBarColor: background),
        child: Material(
          borderRadius: radius,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(color: background, borderRadius: radius),
            child: Column(mainAxisSize: MainAxisSize.min, children: children),
          ),
        ));
  }

  List<Widget> buildItems(BuildContext context, TolyPopPickerTheme theme) {
    List<Widget> children = [];
    if (title != null || message != null) {
      children.add(_buildTitleTiled(title, theme));
    }

    for (int i = 0; i < tasks.length; i++) {
      Widget menu = PopMenuAction(
        theme: theme,
        item: tasks[i],
        onStatusChange: onStatusChange,
      );
      children.add(menu);
      if (i != tasks.length - 1) {
        children.add(Divider());
      }
    }

    children.add(
      Container(
        color: theme.separatorColor?.withOpacity(0.3),
        height: theme.separatorHeight,
      ),
    );

    children.add(buildCancel(context, theme));
    children.add(SizedBox(height: MediaQuery.of(context).padding.bottom));

    return children;
  }

  Widget buildCancel(BuildContext context, TolyPopPickerTheme theme) {
    Radius radius = Radius.circular(theme.borderRadius ?? 0);
    TextStyle? cancelStyle = theme.cancelTextStyle;
    return Material(
      borderRadius: BorderRadius.vertical(bottom: radius),
      child: InkWell(
        borderRadius: BorderRadius.vertical(bottom: radius),
        onTap: () => Navigator.of(context).pop(),
        child: Ink(
          width: MediaQuery.of(context).size.width,
          height: theme.cancelHeight,
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.vertical(bottom: radius),
          ),
          child: Center(child: Text(cancelText, style: cancelStyle)),
        ),
      ),
    );
  }

  Widget _buildTitleTiled(Widget? title, TolyPopPickerTheme theme) {
    Widget? child;
    if (title != null) {
      child = DefaultTextStyle(
        style: theme.titleTextStyle ?? const TextStyle(),
        child: title,
      );
    }

    if (message != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (child != null) child,
          Text(message!, style: theme.messageStyle)
        ],
      );
    }
    BorderRadius radius = BorderRadius.vertical(
      top: Radius.circular(theme.borderRadius ?? 0),
    );
    Border border = Border(
      bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 0.5),
    );
    return Container(
      alignment: Alignment.center,
      constraints: message != null ? null : BoxConstraints(maxHeight: 52),
      padding: theme.titlePadding,
      decoration: BoxDecoration(borderRadius: radius, border: border),
      child: child,
    );
  }
}
