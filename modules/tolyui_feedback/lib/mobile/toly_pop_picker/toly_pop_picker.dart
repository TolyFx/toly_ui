import 'dart:async';

import 'package:flutter/material.dart';

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
  final String? message;
  final Widget? title;
  final String cancelText;

  const TolyPopPicker({
    super.key,
    this.title,
    required this.tasks,
    this.message,
    this.onCancel,
    this.cancelText = "取消",
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message != null || title != null) _buildMessage(context, message),
              ...tasks.asMap().keys.map((index) => buildItem(index, context)).toList(),
              Container(
                color: const Color(0xffE5E3E4).withOpacity(0.3),
                height: 10,
              ),
              buildCancel(context)
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

  Widget buildCancel(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => _cancelTap(context),
        child: Ink(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: Colors.white,
          child: Center(
              child: Text(
            cancelText,
            style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget buildItem(int index, BuildContext context) {
    return Material(
      child: InkWell(
          onTap: tasks[index].task == null
              ? null
              : () async {
                  _cancelTap(context);
                  if (tasks[index].task != null) await tasks[index].task?.call();
                },
          child: Ink(
            height: 52,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: index != tasks.length - 1
                        ? BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5)
                        : BorderSide.none)),
            child: Center(
              child: tasks[index].content ?? Text(
                      tasks[index].info,
                      style: TextStyle(
                        fontSize: 16,
                        color: tasks[index].task == null ? Colors.grey : Colors.black,
                      ),
                    ),
            ),
          )),
    );
  }

  Widget _buildMessage(BuildContext context, String? message) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxHeight: 52),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5))),
      child: title != null
          ? title!
          : Text('${message}', style: TextStyle(fontSize: 15, color: Colors.grey)),
    );
  }
}
