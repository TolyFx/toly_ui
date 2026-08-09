/// HistoryController — 撤销/重做控制器
///
/// 封装 flutter_quill 内置的 history 管理
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// 撤销/重做历史控制器
class HistoryController extends ChangeNotifier {
  HistoryController({
    required this.quillController,
    this.maxHistorySize = 100,
  }) {
    quillController.document.history.maxStack;
    quillController.addListener(_onDocumentChanged);
  }

  final QuillController quillController;
  final int maxHistorySize;

  bool get canUndo => quillController.hasUndo;
  bool get canRedo => quillController.hasRedo;

  void undo() {
    if (!canUndo) return;
    quillController.undo();
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;
    quillController.redo();
    notifyListeners();
  }

  void clearHistory() {
    quillController.document.history.clear();
    notifyListeners();
  }

  void _onDocumentChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    quillController.removeListener(_onDocumentChanged);
    super.dispose();
  }
}
