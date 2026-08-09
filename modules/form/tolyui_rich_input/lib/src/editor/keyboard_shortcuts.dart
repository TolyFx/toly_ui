/// 键盘快捷键管理
library;

import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../types.dart';
import 'history_controller.dart';
import 'rich_input_controller.dart';

/// 快捷键绑定定义
class ShortcutBinding {
  const ShortcutBinding({
    required this.key,
    this.shift = false,
    required this.action,
    required this.label,
  });

  final LogicalKeyboardKey key;
  final bool shift;
  final ShortcutAction action;
  final String label;
}

/// 快捷键动作
enum ShortcutAction {
  bold,
  italic,
  underline,
  undo,
  redo,
}

/// 键盘快捷键管理器
class KeyboardShortcutManager {
  KeyboardShortcutManager({
    required this.richInputController,
    required this.historyController,
    this.onSubmit,
  });

  final RichInputController richInputController;
  final HistoryController historyController;
  final VoidCallback? onSubmit;

  static final List<ShortcutBinding> bindings = [
    const ShortcutBinding(
      key: LogicalKeyboardKey.keyB,
      action: ShortcutAction.bold,
      label: 'Bold',
    ),
    const ShortcutBinding(
      key: LogicalKeyboardKey.keyI,
      action: ShortcutAction.italic,
      label: 'Italic',
    ),
    const ShortcutBinding(
      key: LogicalKeyboardKey.keyU,
      action: ShortcutAction.underline,
      label: 'Underline',
    ),
    const ShortcutBinding(
      key: LogicalKeyboardKey.keyZ,
      action: ShortcutAction.undo,
      label: 'Undo',
    ),
    const ShortcutBinding(
      key: LogicalKeyboardKey.keyZ,
      shift: true,
      action: ShortcutAction.redo,
      label: 'Redo (Shift+Z)',
    ),
    const ShortcutBinding(
      key: LogicalKeyboardKey.keyY,
      action: ShortcutAction.redo,
      label: 'Redo (Y)',
    ),
  ];

  /// 平台修饰键是否按下（macOS 用 Cmd，其他用 Ctrl）
  static bool isPlatformModifierPressed() {
    final keyboard = HardwareKeyboard.instance;
    if (Platform.isMacOS) {
      return keyboard.isMetaPressed;
    }
    return keyboard.isControlPressed;
  }

  /// 处理键盘事件
  KeyEventResult handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final keyboard = HardwareKeyboard.instance;

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      final result = richInputController.handleEnterKey(
        isShiftPressed: keyboard.isShiftPressed,
      );
      if (result == KeyEventResult.skipRemainingHandlers) {
        onSubmit?.call();
        return KeyEventResult.handled;
      }
      return result;
    }

    if (!isPlatformModifierPressed()) return KeyEventResult.ignored;

    for (final binding in bindings) {
      if (event.logicalKey != binding.key) continue;
      if (binding.shift && !keyboard.isShiftPressed) continue;
      if (!binding.shift &&
          keyboard.isShiftPressed &&
          binding.key != LogicalKeyboardKey.keyZ) {
        continue;
      }

      executeAction(binding.action);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// 执行快捷键动作
  void executeAction(ShortcutAction action) {
    switch (action) {
      case ShortcutAction.bold:
        richInputController.toggleFormat(FormatType.bold);
      case ShortcutAction.italic:
        richInputController.toggleFormat(FormatType.italic);
      case ShortcutAction.underline:
        richInputController.toggleFormat(FormatType.underline);
      case ShortcutAction.undo:
        historyController.undo();
      case ShortcutAction.redo:
        historyController.redo();
    }
  }
}
