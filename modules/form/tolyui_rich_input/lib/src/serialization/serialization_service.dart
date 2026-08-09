/// 序列化服务 — Delta、JSON、纯文本、HTML 互转
library;

import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter_quill/quill_delta.dart';

import '../editor/embeds.dart';

/// 富文本内容序列化/反序列化服务
class SerializationService {
  /// Delta 序列化为 JSON 字符串
  String serialize(Delta delta) {
    return jsonEncode(delta.toJson());
  }

  /// JSON 字符串反序列化为 Delta
  Delta deserialize(String json) {
    final List<dynamic> data = jsonDecode(json) as List<dynamic>;
    return Delta.fromJson(data);
  }

  /// Delta 转纯文本
  String toPlainText(Delta delta) {
    final buffer = StringBuffer();
    for (final op in delta.toList()) {
      if (op.isInsert) {
        if (op.data is String) {
          buffer.write(op.data as String);
        } else if (op.data is Map<String, dynamic>) {
          buffer.write(
              _embedToPlainText(op.data as Map<String, dynamic>));
        }
      }
    }
    return buffer.toString();
  }

  /// Delta 转 HTML
  String toHtml(Delta delta) {
    final buffer = StringBuffer();
    final ops = delta.toList();

    var i = 0;
    while (i < ops.length) {
      final op = ops[i];
      if (!op.isInsert) {
        i++;
        continue;
      }

      if (op.data is Map<String, dynamic>) {
        buffer.write(
            _embedToHtml(op.data as Map<String, dynamic>));
        i++;
        continue;
      }

      final text = op.data as String;
      final attrs = op.attributes;

      if (text == '\n' && attrs != null) {
        _writeBlockClose(buffer, attrs);
        i++;
        continue;
      }

      buffer.write(_wrapInlineHtml(text, attrs));
      i++;
    }

    return buffer.toString();
  }

  /// HTML 解析为 Delta
  Delta fromHtml(String html) {
    final delta = Delta();
    var remaining = html;

    while (remaining.isNotEmpty) {
      final tagMatch = RegExp(r'<(/?)(\w+)([^>]*)>').firstMatch(remaining);

      if (tagMatch == null) {
        if (remaining.isNotEmpty) {
          delta.insert(_decodeHtmlEntities(remaining));
        }
        break;
      }

      final beforeTag = remaining.substring(0, tagMatch.start);
      if (beforeTag.isNotEmpty) {
        delta.insert(_decodeHtmlEntities(beforeTag));
      }

      final isClosing = tagMatch.group(1) == '/';
      final tagName = tagMatch.group(2)!.toLowerCase();
      final tagAttrs = tagMatch.group(3) ?? '';

      remaining = remaining.substring(tagMatch.end);

      if (isClosing) continue;

      switch (tagName) {
        case 'br':
          delta.insert('\n');
        case 'b' || 'strong':
          final content = _extractTagContent(tagName, remaining);
          if (content != null) {
            delta.insert(content.text, {'bold': true});
            remaining = content.remaining;
          }
        case 'i' || 'em':
          final content = _extractTagContent(tagName, remaining);
          if (content != null) {
            delta.insert(content.text, {'italic': true});
            remaining = content.remaining;
          }
        case 'u':
          final content = _extractTagContent(tagName, remaining);
          if (content != null) {
            delta.insert(content.text, {'underline': true});
            remaining = content.remaining;
          }
        case 's' || 'del' || 'strike':
          final content = _extractTagContent(tagName, remaining);
          if (content != null) {
            delta.insert(content.text, {'strike': true});
            remaining = content.remaining;
          }
        case 'a':
          final href = _extractAttribute(tagAttrs, 'href');
          final content = _extractTagContent(tagName, remaining);
          if (content != null && href != null) {
            delta.insert(content.text, {'link': href});
            remaining = content.remaining;
          } else if (content != null) {
            delta.insert(content.text);
            remaining = content.remaining;
          }
        case 'p':
          final content = _extractTagContent(tagName, remaining);
          if (content != null) {
            final innerDelta = fromHtml(content.text);
            for (final op in innerDelta.toList()) {
              delta.push(op);
            }
            delta.insert('\n');
            remaining = content.remaining;
          }
        case 'pre' || 'code':
          final content = _extractTagContent(tagName, remaining);
          if (content != null) {
            delta.insert(content.text);
            delta.insert('\n', {'code-block': true});
            remaining = content.remaining;
          }
        case 'blockquote':
          final content = _extractTagContent(tagName, remaining);
          if (content != null) {
            delta.insert(content.text);
            delta.insert('\n', {'blockquote': true});
            remaining = content.remaining;
          }
        case 'ol':
          final items = _extractListItems(remaining);
          for (final item in items.items) {
            delta.insert(item);
            delta.insert('\n', {'list': 'ordered'});
          }
          remaining = items.remaining;
        case 'ul':
          final items = _extractListItems(remaining);
          for (final item in items.items) {
            delta.insert(item);
            delta.insert('\n', {'list': 'bullet'});
          }
          remaining = items.remaining;
        default:
          final content = _extractTagContent(tagName, remaining);
          if (content != null) {
            delta.insert(_decodeHtmlEntities(content.text));
            remaining = content.remaining;
          }
      }
    }

    return delta;
  }

  // --- 私有辅助方法 ---

  String _embedToPlainText(Map<String, dynamic> data) {
    final type = data.keys.first;
    final value = data.values.first;
    switch (type) {
      case MentionEmbed.mentionType:
        final json = _parseEmbedValue(value);
        return '@${json['displayName']}';
      case EmojiEmbed.emojiType:
        final json = _parseEmbedValue(value);
        return json['code'] as String;
      case ImageEmbed.imageType:
        return '[图片]';
      case FileEmbed.fileType:
        final json = _parseEmbedValue(value);
        return '[文件: ${json['name']}]';
      default:
        return '';
    }
  }

  Map<String, dynamic> _parseEmbedValue(dynamic value) {
    if (value is String) {
      return jsonDecode(value) as Map<String, dynamic>;
    }
    return value as Map<String, dynamic>;
  }

  String _embedToHtml(Map<String, dynamic> data) {
    final type = data.keys.first;
    final value = data.values.first;
    switch (type) {
      case MentionEmbed.mentionType:
        final json = _parseEmbedValue(value);
        final name = _encodeHtmlEntities(json['displayName'] as String);
        return '<span class="mention" data-user-id="${json['userId']}">@$name</span>';
      case EmojiEmbed.emojiType:
        final json = _parseEmbedValue(value);
        return '<span class="emoji">${_encodeHtmlEntities(json['code'] as String)}</span>';
      case ImageEmbed.imageType:
        final json = _parseEmbedValue(value);
        final src = _encodeHtmlEntities(json['src'] as String);
        return '<img src="$src">';
      case FileEmbed.fileType:
        final json = _parseEmbedValue(value);
        return '<span class="file">[文件: ${_encodeHtmlEntities(json['name'] as String)}]</span>';
      default:
        return '';
    }
  }

  void _writeBlockClose(StringBuffer buffer, Map<String, dynamic> attrs) {
    if (attrs.containsKey('code-block')) {
      buffer.write('</code></pre>');
    } else if (attrs.containsKey('blockquote')) {
      buffer.write('</blockquote>');
    }
  }

  String _wrapInlineHtml(String text, Map<String, dynamic>? attrs) {
    var result = _encodeHtmlEntities(text);
    if (attrs == null) return result;

    if (attrs['bold'] == true) result = '<strong>$result</strong>';
    if (attrs['italic'] == true) result = '<em>$result</em>';
    if (attrs['underline'] == true) result = '<u>$result</u>';
    if (attrs['strike'] == true) result = '<s>$result</s>';
    if (attrs.containsKey('link')) {
      final href = _encodeHtmlEntities(attrs['link'] as String);
      result = '<a href="$href">$result</a>';
    }
    return result;
  }

  String _encodeHtmlEntities(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
  }

  String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
  }

  _TagContent? _extractTagContent(String tagName, String html) {
    final closeTag = '</$tagName>';
    final closeIndex = html.indexOf(closeTag);
    if (closeIndex == -1) return null;
    return _TagContent(
      text: html.substring(0, closeIndex),
      remaining: html.substring(closeIndex + closeTag.length),
    );
  }

  String? _extractAttribute(String attrs, String name) {
    final match = RegExp('$name=["\']([^"\']*)["\']').firstMatch(attrs);
    return match?.group(1);
  }

  _ListItems _extractListItems(String html) {
    final closeOl = RegExp(r'</(ol|ul)>').firstMatch(html);
    if (closeOl == null) return _ListItems(items: [], remaining: html);

    final listContent = html.substring(0, closeOl.start);
    final remaining = html.substring(closeOl.end);

    final items = <String>[];
    final liPattern = RegExp(r'<li[^>]*>(.*?)</li>', dotAll: true);
    for (final match in liPattern.allMatches(listContent)) {
      items.add(_decodeHtmlEntities(match.group(1) ?? ''));
    }

    return _ListItems(items: items, remaining: remaining);
  }
}

class _TagContent {
  final String text;
  final String remaining;
  _TagContent({required this.text, required this.remaining});
}

class _ListItems {
  final List<String> items;
  final String remaining;
  _ListItems({required this.items, required this.remaining});
}
