import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tolyui_feedback_modal.dart';
import '../../theme/theme.dart';

class PopMenuAction<T> extends StatefulWidget {
  final TolyPopPickerTheme theme;
  final TolyMenuItem<T> item;

  const PopMenuAction({super.key, required this.theme, required this.item});

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

  void _handleTask(BuildContext context, TolyMenuItem item) async {
    if (item.popBeforeTask) {
      _pop(context);
      try {
        await item.task?.call();
      } catch (e) {}
      return;
    }

    setState(() {
      _loading = true;
    });
    T? data;
    try {
      data = await item.task?.call();
    } catch (e) {
    } finally {
      setState(() {
        _loading = false;
      });
    }

    if (data != null) {
      _pop(context, data);

      return;
    }
    _pop(context);
  }

  void _pop(BuildContext context, [T? result]) {
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }
}
