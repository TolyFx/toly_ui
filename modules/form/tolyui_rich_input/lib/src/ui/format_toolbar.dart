/// 格式化工具栏
library;

import 'package:flutter/material.dart';

import '../editor/rich_input_controller.dart';
import '../types.dart';

/// 格式化工具栏组件
class FormatToolbar extends StatelessWidget {
  const FormatToolbar({
    super.key,
    required this.controller,
    this.enabledFormats = const {
      FormatType.bold,
      FormatType.italic,
      FormatType.underline,
      FormatType.strikethrough,
      FormatType.codeBlock,
      FormatType.blockquote,
      FormatType.orderedList,
      FormatType.bulletList,
    },
    this.onImagePick,
    this.onFilePick,
    this.leading = const [],
  });

  final RichInputController controller;
  final Set<FormatType> enabledFormats;
  final VoidCallback? onImagePick;
  final VoidCallback? onFilePick;
  final List<Widget> leading;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return _buildToolbarContent(context);
      },
    );
  }

  Widget _buildToolbarContent(BuildContext context) {
    final items = <Widget>[];
    items.addAll(leading);
    _addFormatButtons(items);
    _addMediaButtons(items);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Wrap(spacing: 2, children: items),
    );
  }

  void _addFormatButtons(List<Widget> items) {
    final formatConfigs = <(FormatType, IconData, String)>[
      (FormatType.bold, Icons.format_bold, '加粗'),
      (FormatType.italic, Icons.format_italic, '斜体'),
      (FormatType.underline, Icons.format_underline, '下划线'),
      (FormatType.strikethrough, Icons.format_strikethrough, '删除线'),
      (FormatType.codeBlock, Icons.code, '代码块'),
      (FormatType.blockquote, Icons.format_quote, '引用'),
      (FormatType.orderedList, Icons.format_list_numbered, '有序列表'),
      (FormatType.bulletList, Icons.format_list_bulleted, '无序列表'),
    ];

    for (final config in formatConfigs) {
      if (enabledFormats.contains(config.$1)) {
        items.add(FormatButton(
          icon: config.$2,
          tooltip: config.$3,
          isActive: controller.isFormatActive(config.$1),
          onPressed: () => controller.toggleFormat(config.$1),
        ));
      }
    }
  }

  void _addMediaButtons(List<Widget> items) {
    if (onImagePick != null) {
      items.add(FormatButton(
        icon: Icons.image_outlined,
        tooltip: '插入图片',
        isActive: false,
        onPressed: onImagePick!,
      ));
    }
    if (onFilePick != null) {
      items.add(FormatButton(
        icon: Icons.attach_file,
        tooltip: '插入文件',
        isActive: false,
        onPressed: onFilePick!,
      ));
    }
  }
}

/// 格式按钮
class FormatButton extends StatelessWidget {
  const FormatButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.isActive,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color iconColor;
    if (isActive) {
      bgColor = Theme.of(context).colorScheme.primaryContainer;
      iconColor = Theme.of(context).colorScheme.primary;
    } else {
      bgColor = Colors.transparent;
      iconColor = Theme.of(context).iconTheme.color ?? Colors.black54;
    }

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}
