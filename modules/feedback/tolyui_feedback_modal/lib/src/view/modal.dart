import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 自定义弹框内容构建器。
typedef TolyModalBuilder = Widget Function(BuildContext context);

/// 使用 TolyUI 的跨平台弹层承载自定义内容。
///
/// 桌面端使用居中的 [TolyDesktopDialog]，移动端使用底部弹层，
/// 调用方只维护一份内容组件。
Future<T?> showTolyModal<T>({
  required BuildContext context,
  required TolyModalBuilder builder,
  BoxConstraints desktopConstraints = const BoxConstraints(maxWidth: 480),
  bool isDismissible = true,
  bool useRootNavigator = false,
  Color? barrierColor,
}) {
  if (isTolyDesktopPlatform()) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      barrierColor: barrierColor,
      builder: (BuildContext dialogContext) {
        return TolyDesktopDialog(
          constraints: desktopConstraints,
          child: builder(dialogContext),
        );
      },
    );
  }
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor,
    showDragHandle: true,
    builder: builder,
  );
}

/// TolyUI 桌面端通用弹框外壳。
class TolyDesktopDialog extends StatelessWidget {
  /// 弹框中的自定义内容。
  final Widget child;

  /// 内容可占用的最大尺寸。
  final BoxConstraints constraints;

  /// 创建桌面端自定义弹框。
  const TolyDesktopDialog({
    super.key,
    required this.child,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final Color surface = Theme.of(context).colorScheme.surface;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: constraints,
        child: Material(
          color: surface,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(20),
          child: child,
        ),
      ),
    );
  }
}

/// 判断当前运行目标是否应使用桌面弹框。
bool isTolyDesktopPlatform() {
  if (kIsWeb) return true;
  return switch (defaultTargetPlatform) {
    TargetPlatform.macOS ||
    TargetPlatform.windows ||
    TargetPlatform.linux =>
      true,
    _ => false,
  };
}
