/// Markdown 风格自动转换规则
///
/// 支持列表标记（"- ", "* ", "1. "）、代码块（```）、引用（"> "）
library;

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

// ignore: implementation_imports
import 'package:flutter_quill/src/rules/insert.dart';

/// 检测 "- ", "* " 转为无序列表，"1. " 转为有序列表
class AutoListConversionRule extends InsertRule {
  const AutoListConversionRule();

  @override
  Delta? applyRule(
    Document document,
    int index, {
    int? len,
    Object? data,
    Attribute? attribute,
  }) {
    if (data is! String || data != ' ') return null;

    final delta = document.toDelta();
    final itr = DeltaIterator(delta);
    final prev = itr.skip(index);
    if (prev == null) return null;

    final prevText = prev.data is String ? prev.data as String : '';
    final lastNewline = prevText.lastIndexOf('\n');
    String linePrefix;
    if (lastNewline >= 0) {
      linePrefix = prevText.substring(lastNewline + 1);
    } else {
      linePrefix = prevText;
    }

    if (linePrefix == '-' || linePrefix == '*') {
      return _convertToList(index, linePrefix.length, Attribute.ul);
    }

    final orderedPattern = RegExp(r'^(\d+)\.$');
    final orderedMatch = orderedPattern.firstMatch(linePrefix);
    if (orderedMatch != null) {
      return _convertToList(index, linePrefix.length, Attribute.ol);
    }

    return null;
  }

  Delta _convertToList(int index, int prefixLength, Attribute attribute) {
    return Delta()
      ..retain(index - prefixLength)
      ..delete(prefixLength + 1)
      ..retain(1, attribute.toJson());
  }
}

/// 检测 ``` 转为代码块
class CodeBlockTriggerRule extends InsertRule {
  const CodeBlockTriggerRule();

  @override
  Delta? applyRule(
    Document document,
    int index, {
    int? len,
    Object? data,
    Attribute? attribute,
  }) {
    if (data is! String || data != '\n') return null;

    final delta = document.toDelta();
    final itr = DeltaIterator(delta);
    final prev = itr.skip(index);
    if (prev == null) return null;

    final prevText = prev.data is String ? prev.data as String : '';
    final lastNewline = prevText.lastIndexOf('\n');
    String linePrefix;
    if (lastNewline >= 0) {
      linePrefix = prevText.substring(lastNewline + 1);
    } else {
      linePrefix = prevText;
    }

    if (linePrefix != '```') return null;

    return Delta()
      ..retain(index - 3)
      ..delete(3)
      ..insert('\n', Attribute.codeBlock.toJson());
  }
}

/// 检测 "> " 转为引用块
class BlockquoteTriggerRule extends InsertRule {
  const BlockquoteTriggerRule();

  @override
  Delta? applyRule(
    Document document,
    int index, {
    int? len,
    Object? data,
    Attribute? attribute,
  }) {
    if (data is! String || data != ' ') return null;

    final delta = document.toDelta();
    final itr = DeltaIterator(delta);
    final prev = itr.skip(index);
    if (prev == null) return null;

    final prevText = prev.data is String ? prev.data as String : '';
    final lastNewline = prevText.lastIndexOf('\n');
    String linePrefix;
    if (lastNewline >= 0) {
      linePrefix = prevText.substring(lastNewline + 1);
    } else {
      linePrefix = prevText;
    }

    if (linePrefix != '>') return null;

    return Delta()
      ..retain(index - 1)
      ..delete(2)
      ..retain(1, Attribute.blockQuote.toJson());
  }
}

/// 获取所有自定义规则
List<Rule> getCustomRules() {
  return const [
    AutoListConversionRule(),
    CodeBlockTriggerRule(),
    BlockquoteTriggerRule(),
  ];
}
