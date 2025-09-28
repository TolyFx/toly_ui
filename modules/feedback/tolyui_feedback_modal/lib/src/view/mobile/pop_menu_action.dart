import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tolyui_feedback_modal.dart';
import '../../model/status.dart';

class PopMenuAction<T> extends StatefulWidget {
  final TolyPopPickerTheme theme;
  final TolyMenuItem<T> item;
  final OnStateChange<T>? onStatusChange;

  const PopMenuAction({
    super.key,
    required this.theme,
    required this.item,
    this.onStatusChange,
  });

  @override
  State<PopMenuAction<T>> createState() => _PopMenuActionState<T>();
}

class _PopMenuActionState<T> extends State<PopMenuAction<T>> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    bool disable = widget.item.task == null;
    TextStyle? style = disable
        ? widget.theme.disabledItemTextStyle
        : widget.theme.itemTextStyle;

    Widget? loadingView;
    if (_loading) {
      loadingView = widget.item.loadingBuilder?.call(context) ??
          CupertinoActivityIndicator(
            radius: 8,
          );
    }

    Widget content =
        widget.item.content ?? Text(widget.item.info, style: style);
    if (loadingView != null) {
      content = Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [content, loadingView],
      );
    }

    return Material(
      child: InkWell(
          onTap: disable ? null : () => _handleTask(context, widget.item),
          child: Ink(
            height: widget.theme.itemHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: widget.theme.backgroundColor),
            child: Container(
              padding: widget.theme.itemPadding,
              child: Center(child: content),
            ),
          )),
    );
  }

  Future<T?> doTask(Task task) async {
    T? data;
    widget.onStatusChange?.call(const Loading(), widget.item);
    try {
      data = await task.call();
      widget.onStatusChange?.call(Success(data), widget.item);
    } catch (e, s) {
      widget.onStatusChange?.call(Failure(e, s), widget.item);
    } finally {
      setState(() {
        _loading = false;
      });
    }
    return data;
  }

  Future<T?> doTaskWithTimeout(Task task) async {
    Duration duration = Duration(seconds: 5);
    return doTask(task).timeout(duration, onTimeout: () {
      widget.onStatusChange?.call(Timeout(duration), widget.item);
      return null;
    });
  }

  void _handleTask(BuildContext context, TolyMenuItem<T> item) async {
    Task? task = item.task;
    Duration duration = Duration(seconds: 5);
    if (task == null) return;
    if (item.popBeforeTask) {
      _pop(context);
      task.execute(
        duration: duration,
        onStatusChange: _onStatusChange,
      );
      return;
    }

    await task.execute(
      duration: duration,
      onStatusChange: _onStatusChange,
    );
    _pop(context);
  }

  void _pop(BuildContext context, [T? result]) {
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  void _onStatusChange(TaskStatus status) {
    TolyMenuItem<T> item = widget.item;

    if (!item.popBeforeTask) {
      switch (status) {
        case Idle():
        case Success():
        case Failure():
        case Timeout():
        case Canceled():
          setState(() {
            _loading = false;
          });
          break;
        case Loading():
          setState(() {
            _loading = true;
          });
          break;
      }
    }

    widget.onStatusChange?.call(status, item);
  }
}
