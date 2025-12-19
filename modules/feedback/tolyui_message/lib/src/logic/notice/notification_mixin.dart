import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tolyui_message.dart';
import '../../widget/panel/notification_panel.dart';
import '../message/message_manager.dart';
import '../message/message_mixin.dart';
import 'notification_manager.dart';

mixin NotificationMixin on ContextAttachable {

  final NotificationTaskManager _taskManager = NotificationTaskManager();

  void infoNotice({
    required Text title,
    required Text subtitle,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position,
    Offset? offset,
    double? gap,
  }) {
    TolyMessageStyleTheme theme = effectTheme;
    Color foregroundColor = theme.infoStyle.foregroundColor;
    IconData icon = theme.infoStyle.icon;

    _emitNotice(
      icon: icon,
      foregroundColor: foregroundColor,
      title: title,
      subtitle: subtitle,
      animaDuration: animaDuration,
      duration: duration,
      position: position,
      offset: offset,
      gap: gap,
    );
  }

  void warningNotice({
    required Text title,
    required Text subtitle,
    bool plain = false,
    bool closeable = false,
    Duration duration = const Duration(seconds: 3),
    Duration animaDuration = const Duration(milliseconds: 250),
    NoticePosition position = NoticePosition.topRight,
    Offset offset = const Offset(16, 16),
    double gap = 12,
  }) {
    TolyMessageStyleTheme theme = effectTheme;
    Color foregroundColor = theme.warningStyle.foregroundColor;
    IconData icon = theme.warningStyle.icon;

    _emitNotice(
      foregroundColor: foregroundColor,
      icon: icon,
      title: title,
      subtitle: subtitle,
      animaDuration: animaDuration,
      duration: duration,
      position: position,
      offset: offset,
      gap: gap,
    );
  }

  void successNotice({
    required Text title,
    required Text subtitle,
    bool plain = false,
    Duration duration = const Duration(seconds: 3),
    Duration animaDuration = const Duration(milliseconds: 250),
    NoticePosition position = NoticePosition.topRight,
    Offset offset = const Offset(16, 16),
    double gap = 12,
  }) {
    TolyMessageStyleTheme theme = effectTheme;
    Color foregroundColor = theme.successStyle.foregroundColor;
    IconData icon = theme.successStyle.icon;

    _emitNotice(
      foregroundColor: foregroundColor,
      icon: icon,
      title: title,
      subtitle: subtitle,
      animaDuration: animaDuration,
      duration: duration,
      position: position,
      offset: offset,
      gap: gap,
    );
  }

  void errorNotice({
    required Text title,
    required Text subtitle,
    bool plain = false,
    bool closeable = false,
    Duration duration = const Duration(seconds: 3),
    Duration animaDuration = const Duration(milliseconds: 250),
    NoticePosition position = NoticePosition.topRight,
    Offset offset = const Offset(16, 16),
    double gap = 12,
  }) {
    TolyMessageStyleTheme theme = effectTheme;
    Color foregroundColor = theme.errorStyle.foregroundColor;
    IconData icon = theme.errorStyle.icon;

    _emitNotice(
      foregroundColor: foregroundColor,
      icon: icon,
      title: title,
      subtitle: subtitle,
      animaDuration: animaDuration,
      duration: duration,
      position: position,
      offset: offset,
      gap: gap,
    );
  }

  void _emitNotice({
    required Text title,
    required Text subtitle,
    IconData? icon,
    Color? foregroundColor,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position,
    Offset? offset,
    double? gap,
  }) {
    emitNotice(
      builder: (_, close) {
        return NotificationPanel(
          title: title,
          icon: icon,
          onClose: close,
          subtitle: subtitle,
          foregroundColor: foregroundColor,
        );
      },
      duration: duration,
      animaDuration: animaDuration,
      position: position,
      gap: gap,
      offset: offset,
    );
  }

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
      builder: builder ?? (_, c) => child ?? const SizedBox(),
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
    _taskManager.dispose();
    super.detach();
  }
}