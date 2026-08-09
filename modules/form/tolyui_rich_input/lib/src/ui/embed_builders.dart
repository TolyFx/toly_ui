/// 自定义嵌入渲染器
library;

import 'dart:convert' show jsonDecode;
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../editor/embeds.dart';

/// @提及渲染器
class MentionEmbedBuilder extends EmbedBuilder {
  @override
  String get key => MentionEmbed.mentionType;

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data as String)
        as Map<String, dynamic>;
    final displayName = data['displayName'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '@$displayName',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: embedContext.textStyle.fontSize,
        ),
      ),
    );
  }
}

/// 表情渲染器
class EmojiEmbedBuilder extends EmbedBuilder {
  @override
  String get key => EmojiEmbed.emojiType;

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data as String)
        as Map<String, dynamic>;
    final code = data['code'] as String? ?? '';
    final imagePath = data['imagePath'] as String?;

    if (imagePath != null) {
      return Image.file(
        File(imagePath),
        width: 24,
        height: 24,
        errorBuilder: (_, __, ___) => Text(code),
      );
    }

    return Text(
      code,
      style: TextStyle(
          fontSize: (embedContext.textStyle.fontSize ?? 16) + 4),
    );
  }
}

/// 图片嵌入渲染器
class ImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => ImageEmbed.imageType;

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data as String)
        as Map<String, dynamic>;
    final src = data['src'] as String? ?? '';
    final width = (data['width'] as num?)?.toDouble();
    final height = (data['height'] as num?)?.toDouble();

    return SelectableEmbed(
      embedContext: embedContext,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 200, maxHeight: 150),
        child: Image.file(
          File(src),
          width: width,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildBrokenImage(),
        ),
      ),
    );
  }
}

/// 文件嵌入渲染器
class FileEmbedBuilder extends EmbedBuilder {
  @override
  String get key => FileEmbed.fileType;

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data as String)
        as Map<String, dynamic>;
    final name = data['name'] as String? ?? '未知文件';
    final size = data['size'] as int? ?? 0;
    final ext =
        name.contains('.') ? name.split('.').last.toLowerCase() : '';

    return SelectableEmbed(
      embedContext: embedContext,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            _buildFileIcon(ext),
            const SizedBox(width: 10),
            Expanded(child: _buildFileInfo(name, size)),
          ],
        ),
      ),
    );
  }

  Widget _buildFileIcon(String ext) {
    IconData icon;
    Color bgColor;
    if ({'pdf'}.contains(ext)) {
      icon = Icons.picture_as_pdf;
      bgColor = const Color(0xFFE74C3C);
    } else if ({'doc', 'docx'}.contains(ext)) {
      icon = Icons.description;
      bgColor = const Color(0xFF2B579A);
    } else if ({'zip', 'rar', '7z'}.contains(ext)) {
      icon = Icons.folder_zip;
      bgColor = const Color(0xFFF39C12);
    } else {
      icon = Icons.insert_drive_file;
      bgColor = const Color(0xFF95A5A6);
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildFileInfo(String name, int size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(_formatFileSize(size),
            style: TextStyle(
                fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }
}

/// Quill 内置图片渲染器
class QuillImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final src = embedContext.node.value.data as String;

    return SelectableEmbed(
      embedContext: embedContext,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 200, maxHeight: 150),
        child: Image.file(
          File(src),
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildBrokenImage(),
        ),
      ),
    );
  }
}

Widget _buildBrokenImage() {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.broken_image, size: 20),
        SizedBox(width: 4),
        Text('图片加载失败'),
      ],
    ),
  );
}

String _formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// 可选中的嵌入包装器
class SelectableEmbed extends StatefulWidget {
  const SelectableEmbed({
    super.key,
    required this.embedContext,
    required this.child,
  });

  final EmbedContext embedContext;
  final Widget child;

  @override
  State<SelectableEmbed> createState() => _SelectableEmbedState();
}

class _SelectableEmbedState extends State<SelectableEmbed> {
  bool _selected = false;

  QuillController get _controller => widget.embedContext.controller;
  int get _offset => widget.embedContext.node.documentOffset;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSelectionChanged);
    _checkSelection();
  }

  @override
  void dispose() {
    _controller.removeListener(_onSelectionChanged);
    super.dispose();
  }

  void _onSelectionChanged() {
    _checkSelection();
  }

  void _checkSelection() {
    final sel = _controller.selection;
    final isSelected = !sel.isCollapsed &&
        sel.baseOffset <= _offset &&
        sel.extentOffset >= _offset + 1;
    if (isSelected != _selected) {
      setState(() => _selected = isSelected);
    }
  }

  void _selectEmbed() {
    Future.delayed(const Duration(milliseconds: 50), () {
      _controller.updateSelection(
        TextSelection(
            baseOffset: _offset, extentOffset: _offset + 1),
        ChangeSource.local,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (_selected) {
      borderColor = const Color(0xFF3370FF);
    } else {
      borderColor = Colors.transparent;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _selectEmbed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1),
        ),
        child: widget.child,
      ),
    );
  }
}

/// 获取所有嵌入渲染器
List<EmbedBuilder> getEmbedBuilders() {
  return [
    MentionEmbedBuilder(),
    EmojiEmbedBuilder(),
    ImageEmbedBuilder(),
    FileEmbedBuilder(),
    QuillImageEmbedBuilder(),
  ];
}
