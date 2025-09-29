import 'package:flutter/material.dart';
import '../../model/toly_menu_item.dart';
import '../../model/status.dart';
import '../../theme/toly_pop_picker_theme.dart';

class TolyDesktopModal<T> extends StatefulWidget {
  final List<TolyMenuItem<T>> tasks;
  final Widget? title;
  final String? message;
  final String cancelText;
  final TolyPopPickerTheme? theme;
  final OnStateChange<T>? onStatusChange;

  const TolyDesktopModal({
    super.key,
    required this.tasks,
    this.title,
    this.message,
    this.cancelText = '取消',
    this.theme,
    this.onStatusChange,
  });

  @override
  State<TolyDesktopModal<T>> createState() => _TolyDesktopModalState<T>();
}

class _TolyDesktopModalState<T> extends State<TolyDesktopModal<T>> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? TolyPopPickerTheme.of(context);

    return Dialog(
      backgroundColor: theme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.borderRadius ?? 12),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 400,
          minHeight: 200,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null) _buildHeader(theme),
            if (widget.message != null) _buildMessage(theme),
            _buildContent(theme),
            _buildActions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TolyPopPickerTheme theme) {
    return Container(
      padding: theme.titlePadding ?? const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: theme.titleTextStyle ?? const TextStyle(),
              child: widget.title!,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(TolyPopPickerTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.message!,
        style: theme.messageStyle,
      ),
    );
  }

  Widget _buildContent(TolyPopPickerTheme theme) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: widget.tasks.length,
        separatorBuilder: (context, index) => SizedBox(
          height: theme.separatorHeight ?? 8,
        ),
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          return _buildTaskItem(task, theme);
        },
      ),
    );
  }

  Widget _buildTaskItem(TolyMenuItem<T> task, TolyPopPickerTheme theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _isLoading ? null : () => _handleTaskTap(task),
        child: Container(
          height: theme.itemHeight ?? 48,
          padding:
              theme.itemPadding ?? const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: task.content ??
              Text(
                task.info,
                style: _isLoading
                    ? theme.disabledItemTextStyle
                    : theme.itemTextStyle,
              ),
        ),
      ),
    );
  }

  Widget _buildActions(TolyPopPickerTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text(
              widget.cancelText,
              style: theme.cancelTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTaskTap(TolyMenuItem<T> task) async {
    if (task.task == null) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await task.task!.execute(
        onStatusChange: (e) => widget.onStatusChange?.call(e, task),
      );

      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
