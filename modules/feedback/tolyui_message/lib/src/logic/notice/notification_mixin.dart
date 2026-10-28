import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/notice_intent.dart';
import '../../model/position.dart';
import '../../widget/panel/notification_panel.dart';
import '../../widget/theme/toly_message_show_theme.dart';
import '../../widget/theme/toly_message_style_theme.dart';
import '../message/message_manager.dart';
import '../message/message_mixin.dart';
import 'intent_dispatcher.dart';
import 'notification_manager.dart';

mixin NotificationMixin on ContextAttachable {
  /// 当前挂载期的通知浮层调度器。
  final NotificationTaskManager _taskManager = NotificationTaskManager();

  /// 动作防重及异步错误反馈的生命周期边界。
  NoticeIntentDispatcher? _intentDispatcher;

  /// 通用通知入口，使用缺省磨砂面板，保留自定义内容的 emitNotice。
  void notice({
    required Widget title,
    required Widget subtitle,
    NoticeLevel level = NoticeLevel.info,
    ImageProvider? thumbnail,
    NoticeIntent? intent,
    NoticeIntentHandler? intentHandler,
    NoticeIntentErrorHandler? onIntentError,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position,
    Offset? offset,
    double? gap,
  }) {
    final TolyMessageShowTheme? theme =
        Theme.of(context).extension<TolyMessageShowTheme>();
    final TolyMessageStyleTheme? styleTheme =
        Theme.of(context).extension<TolyMessageStyleTheme>();
    final MessageStyle? style = switch (level) {
      NoticeLevel.info => styleTheme?.infoStyle,
      NoticeLevel.success => styleTheme?.successStyle,
      NoticeLevel.warning => styleTheme?.warningStyle,
      NoticeLevel.error => styleTheme?.errorStyle,
    };
    final Duration effectiveDuration = noticeDisplayDuration(
        duration ?? theme?.duration ?? const Duration(seconds: 3), intent);
    final NoticeIntentDispatcher dispatcher =
        _intentDispatcher ??= NoticeIntentDispatcher();
    final bool actionable = intent != null &&
        intentHandler != null &&
        intentHandler.supports(intent);
    void executeIntent() => unawaited(dispatcher.execute(
        intent!, intentHandler!, onIntentError ?? _showIntentFailure));
    Widget buildPanel(BuildContext context, VoidCallback close) =>
        NotificationPanel(
          title: title,
          subtitle: subtitle,
          level: level,
          icon: style?.icon,
          foregroundColor: style?.foregroundColor,
          duration: effectiveDuration,
          thumbnail: thumbnail,
          intent: intent,
          onIntent: actionable ? executeIntent : null,
          onClose: close,
        );
    emitNotice(
      builder: buildPanel,
      duration: effectiveDuration,
      animaDuration: animaDuration,
      position: position,
      offset: offset,
      gap: gap ?? theme?.gap ?? 8,
    );
  }

  /// 未接管动作错误时，用同一套缺省通知呈现失败。
  void _showIntentFailure(Object error, StackTrace stack) {
    notice(
        title: const Text('操作失败'),
        subtitle: Text('$error'),
        level: NoticeLevel.error);
  }

  /// 普通通知沿用既有 API，并支持缩略图和可选动作。
  void infoNotice({
    required Text title,
    required Text subtitle,
    ImageProvider? thumbnail,
    NoticeIntent? intent,
    NoticeIntentHandler? intentHandler,
    NoticeIntentErrorHandler? onIntentError,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position,
    Offset? offset,
    double? gap,
  }) =>
      notice(
        title: title,
        subtitle: subtitle,
        level: NoticeLevel.info,
        thumbnail: thumbnail,
        intent: intent,
        intentHandler: intentHandler,
        onIntentError: onIntentError,
        duration: duration,
        animaDuration: animaDuration,
        position: position,
        offset: offset,
        gap: gap,
      );

  /// 成功通知沿用既有 API，并支持缩略图和可选动作。
  void successNotice({
    required Text title,
    required Text subtitle,
    bool plain = false,
    ImageProvider? thumbnail,
    NoticeIntent? intent,
    NoticeIntentHandler? intentHandler,
    NoticeIntentErrorHandler? onIntentError,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position,
    Offset? offset,
    double? gap,
  }) =>
      notice(
        title: title,
        subtitle: subtitle,
        level: NoticeLevel.success,
        thumbnail: thumbnail,
        intent: intent,
        intentHandler: intentHandler,
        onIntentError: onIntentError,
        duration: duration,
        animaDuration: animaDuration,
        position: position,
        offset: offset,
        gap: gap,
      );

  /// 警告通知沿用既有 API，并支持缩略图和可选动作。
  void warningNotice({
    required Text title,
    required Text subtitle,
    bool plain = false,
    bool closeable = false,
    ImageProvider? thumbnail,
    NoticeIntent? intent,
    NoticeIntentHandler? intentHandler,
    NoticeIntentErrorHandler? onIntentError,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position,
    Offset? offset,
    double? gap,
  }) =>
      notice(
        title: title,
        subtitle: subtitle,
        level: NoticeLevel.warning,
        thumbnail: thumbnail,
        intent: intent,
        intentHandler: intentHandler,
        onIntentError: onIntentError,
        duration: duration,
        animaDuration: animaDuration,
        position: position,
        offset: offset,
        gap: gap,
      );

  /// 错误通知沿用既有 API，并支持缩略图和可选动作。
  void errorNotice({
    required Text title,
    required Text subtitle,
    bool plain = false,
    bool closeable = false,
    ImageProvider? thumbnail,
    NoticeIntent? intent,
    NoticeIntentHandler? intentHandler,
    NoticeIntentErrorHandler? onIntentError,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position,
    Offset? offset,
    double? gap,
  }) =>
      notice(
        title: title,
        subtitle: subtitle,
        level: NoticeLevel.error,
        thumbnail: thumbnail,
        intent: intent,
        intentHandler: intentHandler,
        onIntentError: onIntentError,
        duration: duration,
        animaDuration: animaDuration,
        position: position,
        offset: offset,
        gap: gap,
      );

  /// 自定义通知内容时仍复用浮层动画、堆叠和计时。
  void emitNotice({
    Widget? child,
    CloseableBuilder? builder,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position,
    Offset? offset,
    double? gap,
  }) {
    _taskManager.add(
      builder: builder ?? (_, close) => child ?? const SizedBox(),
      context: context,
      duration: duration,
      animaDuration: animaDuration,
      position: position,
      gap: gap,
      offset: offset,
    );
  }

  @override
  void detach() {
    _intentDispatcher?.dispose();
    _intentDispatcher = null;
    _taskManager.dispose();
    super.detach();
  }
}
