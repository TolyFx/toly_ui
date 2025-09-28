import 'dart:async';

import 'package:flutter/material.dart';
import 'toly_pop_picker_theme.dart';

/// create by 张风捷特烈 on 2021/1/11
/// contact me by email 1981462002@qq.com
/// 说明:

class TolyPopItem {
  final FutureOr Function()? task;
  final String info;
  final Widget? content;
  final WidgetBuilder? loadingContent;

  TolyPopItem({
    this.loadingContent,
    this.task,
    required this.info,
    this.content,
  });
}

class TolyPopPicker extends StatelessWidget {
  final List<TolyPopItem> tasks;
  final VoidCallback? onCancel;
  final Widget? title;
  final String cancelText;
  final TolyPopPickerTheme? theme;

  const TolyPopPicker({
    super.key,
    this.title,
    required this.tasks,
    this.onCancel,
    this.cancelText = "取消",
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? TolyPopPickerTheme.of(context);
    return Material(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(effectiveTheme.borderRadius)),
      child: Container(
          decoration: BoxDecoration(
            color: effectiveTheme.backgroundColor,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(effectiveTheme.borderRadius)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                _buildMessage(context, effectiveTheme),
              ...tasks
                  .asMap()
                  .keys
                  .map((index) => buildItem(index, context, effectiveTheme)),
              Container(
                color: effectiveTheme.separatorColor.withOpacity(0.3),
                height: effectiveTheme.separatorHeight,
              ),
              buildCancel(context, effectiveTheme),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          )),
    );
  }

  void _cancelTap(BuildContext context) {
    if (onCancel != null) {
      onCancel!.call();
      return;
    }
    Navigator.of(context).pop();
  }

  Widget buildCancel(BuildContext context, TolyPopPickerTheme theme) {
    Radius radius = Radius.circular(theme.borderRadius);
    TextStyle? cancelStyle = theme.cancelTextStyle;
    return Material(
      borderRadius: BorderRadius.vertical(bottom: radius),
      child: InkWell(
        borderRadius: BorderRadius.vertical(bottom: radius),
        onTap: () => _cancelTap(context),
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

  Widget buildItem(int index, BuildContext context, TolyPopPickerTheme theme) {
    bool disable = tasks[index].task == null;
    TextStyle? itemStyle =
        disable ? theme.disabledItemTextStyle : theme.itemTextStyle;
    return Material(
      child: InkWell(
          onTap: disable
              ? null
              : () async {
                  _cancelTap(context);
                  if (tasks[index].task != null) {
                    await tasks[index].task?.call();
                  }
                },
          child: Ink(
            height: theme.itemHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                border: Border(
                    bottom: index != tasks.length - 1
                        ? BorderSide(
                            color: Colors.grey.withOpacity(0.2), width: 0.5)
                        : BorderSide.none)),
            child: Container(
              padding: theme.itemPadding,
              child: Center(
                child: tasks[index].content ??
                    Text(
                      tasks[index].info,
                      style: itemStyle,
                    ),
              ),
            ),
          )),
    );
  }

  Widget _buildMessage(BuildContext context, TolyPopPickerTheme theme) {
    Widget? child;
    if (title != null) {
      child = DefaultTextStyle(
        style: theme.titleTextStyle ?? const TextStyle(),
        child: title!,
      );
    }
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxHeight: 52),
      width: MediaQuery.of(context).size.width,
      padding: theme.titlePadding,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(theme.borderRadius)),
          border: Border(
              bottom:
                  BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5))),
      child: child,
    );
  }
}

Future<T?> showTolyPopPicker<T>({
  required BuildContext context,
  required List<TolyPopItem> tasks,
  Widget? title,
  VoidCallback? onCancel,
  String cancelText = "取消",
  TolyPopPickerTheme? theme,
  bool isDismissible = true,
  bool enableDrag = true,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  Color? backgroundColor,
  double? elevation,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  String? barrierLabel,
  AnimationController? transitionAnimationController,
}) {
  final effectiveTheme = theme ?? TolyPopPickerTheme.of(context);
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(effectiveTheme.borderRadius)),
    ),
    clipBehavior: clipBehavior,
    constraints: constraints,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    transitionAnimationController: transitionAnimationController,
    builder: (context) => TolyPopPicker(
      tasks: tasks,
      title: title,
      onCancel: onCancel,
      cancelText: cancelText,
      theme: theme,
    ),
  );
}
