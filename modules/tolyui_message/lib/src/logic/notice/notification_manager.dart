import 'package:flutter/material.dart';

import '../../../tolyui_message.dart';
import '../../model/position.dart';
import '../../model/task.dart';
import '../../widget/overlay/notice_overlay.dart';
import '../message/message_manager.dart';

class NotificationTaskManager {
  final Map<NoticePosition, List<NoticeTask>> _taskPool = {};

  List<NoticeTask> effectTasks(NoticePosition position) {
    return _taskPool[position] ?? [];
  }

  List<NoticeTask> addTaskInPool(NoticeTask task) {
    List<NoticeTask>? tasks = _taskPool[task.position];
    if (tasks == null) {
      tasks = [];
      _taskPool[task.position] = tasks;
    }
    _taskPool[task.position]!.add(task);
    return tasks;
  }

  void add({
    required CloseableBuilder builder,
    required BuildContext context,
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? position ,
    Offset? offset ,
    double? gap,
  }) {

    // 根据主题获取默认数据
    TolyMessageShowTheme? theme = Theme.of(context).extension<TolyMessageShowTheme>();
    duration = duration?? theme?.duration ?? const Duration(seconds: 3);
    animaDuration = animaDuration?? theme?.animaDuration??  const Duration(milliseconds: 250);
    position = position?? theme?.noticePosition?? NoticePosition.topRight;
    gap = gap?? theme?.gap?? 12;
    offset = offset?? theme?.noticeOffset?? const Offset(16, 16);

    NoticeTask task = NoticeTask(() => Future.delayed(duration!), position);
    double y = endY(offset.dy - gap, position);
    EdgeInsets padding = position.isTop
        ? EdgeInsets.only(top: gap)
        : EdgeInsets.only(bottom: gap);
    double start = starY(position);
    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext ctx) {
        return NoticeOverlay(
          duration: animaDuration!,
          position: position!,
          offset: offset!,
          offsetY: y,
          child: Padding(
            padding: padding,
            child: builder(ctx, () => hide(task)),
          ),
          onSizeReady: (state, size) {
            task.size = size;
            task.state = state;
          },
        );
      },
    );
    task.entry = entry;
    scheduleNoticeTask(task, context);
    if (duration != Duration.zero) {
      task.task().then((_) => hide(task));
    }
  }

  void scheduleNoticeTask(
    NoticeTask task,
    BuildContext context,
  ) {
    final OverlayState state = Overlay.of(context);
    state.insert(task.entry!);
    addTaskInPool(task);
  }

  double endY(double y, NoticePosition position) {
    double ret = y;
    for (NoticeTask task in effectTasks(position)) {
      ret += task.size?.height ?? 0;
    }
    return ret;
  }

  double starY(NoticePosition position) {
    List<NoticeTask> scheduleTasks = effectTasks(position);
    if (scheduleTasks.isEmpty) return 0;
    double ret = 0;
    for (NoticeTask task
        in scheduleTasks.sublist(0, scheduleTasks.length - 1)) {
      ret += task.size?.height ?? 0;
    }
    return ret;
  }

  void hide(NoticeTask task) async {
    NoticeOverlayState? state = task.state;
    if (state != null) {
      await state.close();
      task.entry?.remove();
      shiftWhenClose(task);
      task.state = null;
      task.entry = null;
    }
  }

  void shiftWhenClose(NoticeTask task) {
    double height = task.size?.height ?? 0;
    List<NoticeTask> tasks = effectTasks(task.position);
    int index = tasks.indexOf(task);
    for (int i = index; i < tasks.length; i++) {
      tasks[i].state?.shift(-height);
    }
    tasks.remove(task);
  }

  void dispose() {
    closeAll();
  }

  void closeAll() {
    _taskPool.values.forEach(closeTasks);
    _taskPool.clear();
  }

  void closeTasks(List<NoticeTask> tasks) {
    for (NoticeTask task in tasks) {
      task.state?.close();
      task.state = null;
    }
    tasks.clear();
  }
}
