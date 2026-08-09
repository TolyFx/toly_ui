/// RichTextInputBox — 富文本输入主组件
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:quill_native_bridge/quill_native_bridge.dart'
    show QuillNativeBridge, QuillNativeBridgeFeature;

import '../editor/custom_rules.dart';
import '../editor/embeds.dart';
import '../editor/history_controller.dart';
import '../editor/keyboard_shortcuts.dart';
import '../editor/rich_input_controller.dart';
import '../mention/mention_controller.dart';
import '../types.dart';
import 'embed_builders.dart';
import 'format_toolbar.dart';
import 'mention_panel.dart';

/// @提及搜索回调
typedef MentionSearchFn = Future<List<MentionUser>> Function(String query);

/// 文件/图片粘贴回调
typedef FilePastedCallback = void Function(dynamic file);

/// 富文本输入框主组件
class RichTextInputBox extends StatefulWidget {
  const RichTextInputBox({
    super.key,
    this.onChanged,
    this.onSubmit,
    this.onMentionSearch,
    this.onFilePasted,
    this.minLines = 1,
    this.maxLines = 8,
    this.showToolbar = true,
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
    this.placeholder,
    this.onImagePick,
    this.onFilePick,
    this.toolbarLeading = const [],
  });

  final ValueChanged<Delta>? onChanged;
  final ValueChanged<Delta>? onSubmit;
  final MentionSearchFn? onMentionSearch;
  final FilePastedCallback? onFilePasted;
  final int minLines;
  final int maxLines;
  final bool showToolbar;
  final Set<FormatType> enabledFormats;
  final String? placeholder;
  final VoidCallback? onImagePick;
  final VoidCallback? onFilePick;
  final List<Widget> toolbarLeading;

  @override
  State<RichTextInputBox> createState() => RichTextInputBoxState();
}

/// RichTextInputBox 的 State，暴露控制器供外部访问
class RichTextInputBoxState extends State<RichTextInputBox> {
  late final RichInputController _richController;
  late final HistoryController _historyController;
  late final KeyboardShortcutManager _shortcutManager;
  late final MentionController _mentionController;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  /// 访问富文本控制器
  RichInputController get controller => _richController;

  /// 请求焦点
  void requestFocus() => _focusNode.requestFocus();

  @override
  void initState() {
    super.initState();
    _richController = RichInputController(
      onImagePaste: _handleImagePaste,
    );
    _historyController = HistoryController(
      quillController: _richController.quillController,
    );
    _mentionController = MentionController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();

    _richController.quillController.document
        .setCustomRules(getCustomRules());

    _shortcutManager = KeyboardShortcutManager(
      richInputController: _richController,
      historyController: _historyController,
      onSubmit: _handleSubmit,
    );

    _richController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    widget.onChanged?.call(_richController.delta);
  }

  void _handleSubmit() {
    if (_richController.isEmpty) return;
    final delta = _richController.delta;
    _richController.clear();
    widget.onSubmit?.call(delta);
  }

  @override
  void dispose() {
    _richController.removeListener(_onContentChanged);
    _richController.dispose();
    _historyController.dispose();
    _mentionController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (widget.showToolbar) {
      children.add(FormatToolbar(
        controller: _richController,
        enabledFormats: widget.enabledFormats,
        onImagePick: widget.onImagePick,
        onFilePick: widget.onFilePick,
        leading: widget.toolbarLeading,
      ));
    }
    children.add(Expanded(
      child: Stack(
        children: [
          _buildEditor(),
          _buildMentionPanel(),
        ],
      ),
    ));

    return Column(children: children);
  }

  Widget _buildEditor() {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        _shortcutManager.handleKeyEvent(event);
      },
      child: QuillEditor.basic(
        controller: _richController.quillController,
        focusNode: _focusNode,
        scrollController: _scrollController,
        config: QuillEditorConfig(
          scrollable: true,
          padding: const EdgeInsets.all(8),
          placeholder: widget.placeholder,
          embedBuilders: getEmbedBuilders(),
          customStyles: DefaultStyles(
            paragraph: DefaultTextBlockStyle(
              const TextStyle(
                  fontSize: 14, height: 1.5, color: Colors.black),
              const HorizontalSpacing(0, 0),
              const VerticalSpacing(4, 4),
              const VerticalSpacing(0, 0),
              null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMentionPanel() {
    return ListenableBuilder(
      listenable: _mentionController,
      builder: (context, _) {
        if (!_mentionController.isSearching) {
          return const SizedBox.shrink();
        }
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MentionPanel(
            searchResults: _mentionController.searchResults,
            onSelect: _handleMentionSelect,
            onDismiss: _mentionController.cancelSearch,
          ),
        );
      },
    );
  }

  void _handleMentionSelect(MentionUser user) {
    final selection = _mentionController.selectUser(user);
    if (selection == null) return;
    _richController.quillController.replaceText(
      selection.replaceOffset,
      selection.replaceLength,
      selection.embed,
      null,
    );
  }

  /// 处理剪贴板图片粘贴
  Future<String?> _handleImagePaste(Uint8List imageBytes) async {
    try {
      String? resultPath;
      bool isFileEmbed = false;

      final clipResult = await _tryGetClipboardFile();
      resultPath = clipResult.path;
      isFileEmbed = clipResult.isFile;

      if (resultPath == null) {
        resultPath = await _saveTempImage(imageBytes);
      }

      if (isFileEmbed) {
        _replaceImageWithFileEmbed(resultPath);
        return resultPath;
      }

      _moveCursorAfterEmbed();
      return resultPath;
    } catch (_) {
      return null;
    }
  }

  Future<({String? path, bool isFile})> _tryGetClipboardFile() async {
    final bridge = QuillNativeBridge();
    final supported = await bridge
        .isSupported(QuillNativeBridgeFeature.getClipboardFiles);
    if (!supported) return (path: null, isFile: false);

    final files = await bridge.getClipboardFiles();
    if (files.isEmpty) return (path: null, isFile: false);

    final path = files.first;
    final lower = path.toLowerCase();
    final isImage = _isImagePath(lower);
    if (isImage) {
      return (path: path, isFile: false);
    }
    return (path: path, isFile: true);
  }

  Future<String> _saveTempImage(Uint8List imageBytes) async {
    final tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/paste_image_$timestamp.png');
    await file.writeAsBytes(imageBytes);
    return file.path;
  }

  bool _isImagePath(String lower) {
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp') ||
        lower.endsWith('.webp');
  }

  void _replaceImageWithFileEmbed(String filePath) {
    Future.microtask(() {
      final ctrl = _richController.quillController;
      final delta = ctrl.document.toDelta();
      final offset = _findImageOffset(delta, filePath);
      if (offset < 0) return;

      final file = File(filePath);
      final name = filePath.split(Platform.pathSeparator).last;
      int size = 0;
      if (file.existsSync()) {
        size = file.lengthSync();
      }
      final ext = name.contains('.')
          ? name.split('.').last.toLowerCase()
          : '';
      ctrl.replaceText(
        offset,
        1,
        FileEmbed(
          name: name,
          size: size,
          mimeType: _guessMimeType(ext),
          path: filePath,
        ),
        null,
      );
      ctrl.updateSelection(
        TextSelection.collapsed(offset: offset + 1),
        ChangeSource.local,
      );
    });
  }

  int _findImageOffset(Delta delta, String filePath) {
    int offset = 0;
    for (final op in delta.toList()) {
      if (op.data is Map) {
        final map = op.data as Map;
        if (map.containsKey('image') && map['image'] == filePath) {
          return offset;
        }
      }
      if (op.data is String) {
        offset += (op.data as String).length;
      } else {
        offset += 1;
      }
    }
    return -1;
  }

  void _moveCursorAfterEmbed() {
    Future.microtask(() {
      final ctrl = _richController.quillController;
      final docLen = ctrl.document.length;
      final pos = ctrl.selection.baseOffset + 1;
      int clampedPos;
      if (pos > docLen - 1) {
        clampedPos = docLen - 1;
      } else if (pos < 0) {
        clampedPos = 0;
      } else {
        clampedPos = pos;
      }
      ctrl.updateSelection(
        TextSelection.collapsed(offset: clampedPos),
        ChangeSource.local,
      );
    });
  }

  static String _guessMimeType(String ext) {
    const map = {
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'zip': 'application/zip',
      'txt': 'text/plain',
      'json': 'application/json',
      'png': 'image/png',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'gif': 'image/gif',
      'webp': 'image/webp',
    };
    return map[ext] ?? 'application/octet-stream';
  }
}
