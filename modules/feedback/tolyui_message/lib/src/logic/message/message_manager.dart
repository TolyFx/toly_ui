import 'package:flutter/material.dart';

import '../../model/position.dart';
import '../../model/task.dart';
import '../../widget/overlay/message_overlay.dart';
import '../../widget/theme/toly_message_show_theme.dart';

typedef CloseableBuilder = Widget Function(
    BuildContext ccontext, VoidCallback close);

class MessageTaskManager {
  Map<MessagePosition, List<MessageTask>> _taskPool = {};

  List<MessageTask> effectTasks(MessagePosition position) {
    return _taskPool[position] ?? [];
  }

  List<MessageTask> addTaskInPool(MessageTask task) {
    List<MessageTask>? tasks = _taskPool[task.position];
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
    Duration? duration ,
    Duration? animaDuration ,
    MessagePosition? position ,
    Offset? offset,
    double? gap,
  }) {
    // 根据主题获取默认数据
    TolyMessageShowTheme? theme = Theme.of(context).extension<TolyMessageShowTheme>();
    Duration effectDuration = duration?? theme?.duration?? const Duration(seconds: 3);
    Duration effectAnimaDuration = animaDuration?? theme?.animaDuration??  const Duration(milliseconds: 250);
    MessagePosition effectPosition = position?? theme?.messagePosition?? MessagePosition.top;
    double effectGap = gap?? theme?.gap?? 12;
    Offset effectOffset = offset?? theme?.offset?? const Offset(0, 16);

    MessageTask task = MessageTask(() => Future.delayed(effectDuration), effectPosition);
    double y = endY(effectOffset.dy - effectGap, effectPosition);
    EdgeInsets padding = position == MessagePosition.top
        ? EdgeInsets.only(top: effectGap)
        : EdgeInsets.only(bottom: effectGap);
    double start = starY(effectPosition);
    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext ctx) {
        return MessageOverlay(
          duration: effectAnimaDuration,
          position: effectPosition,
          offset: effectOffset,
          startY: start,
          endY: y,
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
    scheduleMessageTask(task, context);
  }

  void scheduleMessageTask(
    MessageTask task,
    BuildContext context,
  ) {
    final OverlayState state = Overlay.of(context);
    state.insert(task.entry!);
    task.task().then((_) => hide(task));
    addTaskInPool(task);
  }

  double endY(double y, MessagePosition position) {
    double ret = y;
    for (MessageTask task in effectTasks(position)) {
      ret += task.size?.height ?? 0;
    }
    return ret;
  }

  double starY(MessagePosition position) {
    List<MessageTask> scheduleTasks = effectTasks(position);
    if (scheduleTasks.isEmpty) return 0;
    double ret = 0;
    for (MessageTask task
        in scheduleTasks.sublist(0, scheduleTasks.length - 1)) {
      ret += task.size?.height ?? 0;
    }
    return ret;
  }

  void hide(MessageTask task) async {
    MessageOverlayState? state = task.state;
    if (state != null) {
      await state.close();
      task.entry?.remove();
      shiftWhenClose(task);
      task.state = null;
      task.entry = null;
    }
  }

  void shiftWhenClose(MessageTask task) {
    double height = task.size?.height ?? 0;
    List<MessageTask> tasks = effectTasks(task.position);
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

  void closeTasks(List<MessageTask> tasks) {
    for (MessageTask task in tasks) {
      task.state?.close();
      task.state = null;
    }
    tasks.clear();
  }
}
