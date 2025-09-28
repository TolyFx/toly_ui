import 'package:flutter/material.dart';

import '../../tolyui_feedback_modal.dart';
import '../model/status.dart';
import 'mobile/toly_pop_picker.dart';

Future<T?> showTolyPopPicker<T>({
  required BuildContext context,
  required List<TolyMenuItem<T>> tasks,
  OnStateChange<T>? onStatusChange,
  Widget? title,
  String cancelText = "取消",
  String? message,
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
  theme = theme ?? TolyPopPickerTheme.of(context);
  ShapeBorder border = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(theme.borderRadius),
    ),
  );

  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: border,
    clipBehavior: clipBehavior,
    constraints: constraints,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    transitionAnimationController: transitionAnimationController,
    builder: (context) => TolyPopPicker<T>(
      tasks: tasks,
      title: title,
      cancelText: cancelText,
      theme: theme,
      message: message,
      onStatusChange: onStatusChange,
    ),
  );
}
