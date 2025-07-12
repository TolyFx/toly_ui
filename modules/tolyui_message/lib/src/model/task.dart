import 'package:flutter/material.dart';

import '../../tolyui_message.dart';
import '../widget/overlay/message_overlay.dart';
import '../widget/overlay/notice_overlay.dart';

typedef Task<T> = Future<T> Function();

/// 消息任务栈
class MessageTask {
  final Task task;
  final MessagePosition position;
  OverlayEntry? entry;
  MessageOverlayState? state;
  Size? size;

  MessageTask(this.task, this.position);
}

/// 通知任务栈
class NoticeTask {
  final Task task;
  final NoticePosition position;
  OverlayEntry? entry;
  NoticeOverlayState? state;
  Size? size;

  NoticeTask(this.task, this.position);
}
