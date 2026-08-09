/// 链接检测服务 — 自动检测文本中的 URL
library;

import 'package:flutter_quill/quill_delta.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

/// 检测到的链接匹配
class LinkMatch {
  const LinkMatch({
    required this.start,
    required this.end,
    required this.url,
  });

  final int start;
  final int end;
  final String url;
}

/// URL 检测和管理服务
class LinkDetectionService {
  static final RegExp urlPattern = RegExp(
    r'https?://[^\s<>\[\]{}|\\^`"]+',
    caseSensitive: false,
  );

  /// 检测文本中的所有 URL
  List<LinkMatch> detectLinks(String text) {
    final matches = <LinkMatch>[];
    for (final match in urlPattern.allMatches(text)) {
      final url = match.group(0)!;
      if (_isValidUrl(url)) {
        matches.add(LinkMatch(
          start: match.start,
          end: match.end,
          url: url,
        ));
      }
    }
    return matches;
  }

  /// 对 Delta 中检测到的 URL 应用链接格式
  Delta applyLinkFormat(Delta delta) {
    final result = Delta();

    for (final op in delta.toList()) {
      if (!op.isInsert || op.data is! String) {
        result.push(op);
        continue;
      }

      final text = op.data as String;
      final baseAttrs = op.attributes ?? {};
      final links = detectLinks(text);

      if (links.isEmpty) {
        result.push(op);
        continue;
      }

      var lastEnd = 0;
      for (final link in links) {
        if (link.start > lastEnd) {
          final before = text.substring(lastEnd, link.start);
          Map<String, dynamic>? attrs;
          if (baseAttrs.isNotEmpty) {
            attrs = Map<String, dynamic>.from(baseAttrs);
          }
          result.insert(before, attrs);
        }
        final linkText = text.substring(link.start, link.end);
        final linkAttrs = Map<String, dynamic>.from(baseAttrs);
        linkAttrs['link'] = link.url;
        result.insert(linkText, linkAttrs);
        lastEnd = link.end;
      }
      if (lastEnd < text.length) {
        final after = text.substring(lastEnd);
        Map<String, dynamic>? attrs;
        if (baseAttrs.isNotEmpty) {
          attrs = Map<String, dynamic>.from(baseAttrs);
        }
        result.insert(after, attrs);
      }
    }

    return result;
  }

  /// 重新检测全文链接
  Delta redetectLinks(String fullText) {
    final delta = Delta();
    final links = detectLinks(fullText);

    if (links.isEmpty) {
      delta.insert(fullText);
      return delta;
    }

    var lastEnd = 0;
    for (final link in links) {
      if (link.start > lastEnd) {
        delta.insert(fullText.substring(lastEnd, link.start));
      }
      delta.insert(
        fullText.substring(link.start, link.end),
        {'link': link.url},
      );
      lastEnd = link.end;
    }
    if (lastEnd < fullText.length) {
      delta.insert(fullText.substring(lastEnd));
    }

    return delta;
  }

  /// 在系统浏览器中打开链接
  Future<bool> openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return launcher.launchUrl(uri);
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (!uri.hasScheme) return false;
    if (uri.host.isEmpty) return false;
    if (!uri.host.contains('.')) return false;
    return true;
  }
}
