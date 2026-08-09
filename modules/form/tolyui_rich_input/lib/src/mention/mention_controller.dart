/// MentionController — @提及控制器
library;

import 'package:flutter/foundation.dart';

import '../editor/embeds.dart';

/// 可被提及的用户
class MentionUser {
  const MentionUser({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? avatarUrl;
}

/// 用户搜索回调
typedef MentionSearchCallback = Future<List<MentionUser>> Function(
    String query);

/// @提及系统控制器
class MentionController extends ChangeNotifier {
  MentionController({this.onSearch});

  final MentionSearchCallback? onSearch;

  bool get isSearching => _isSearching;
  bool _isSearching = false;

  String get searchQuery => _searchQuery;
  String _searchQuery = '';

  int get triggerOffset => _triggerOffset;
  int _triggerOffset = -1;

  List<MentionUser> get searchResults => List.unmodifiable(_searchResults);
  List<MentionUser> _searchResults = [];

  /// 处理文本变化，检测 "@" 触发
  void onTextChanged(String text, int cursorPosition) {
    if (cursorPosition <= 0 || cursorPosition > text.length) {
      if (_isSearching) cancelSearch();
      return;
    }

    final textBeforeCursor = text.substring(0, cursorPosition);

    if (_isSearching) {
      if (_triggerOffset >= 0 && _triggerOffset < cursorPosition) {
        final query = textBeforeCursor.substring(_triggerOffset + 1);
        if (query.contains(' ') || query.contains('\n')) {
          cancelSearch();
          return;
        }
        _searchQuery = query;
        _performSearch(query);
      } else {
        cancelSearch();
      }
      return;
    }

    if (cursorPosition > 0 && text[cursorPosition - 1] == '@') {
      if (cursorPosition == 1 || _isWhitespace(text[cursorPosition - 2])) {
        _triggerOffset = cursorPosition - 1;
        _isSearching = true;
        _searchQuery = '';
        _performSearch('');
        notifyListeners();
      }
    }
  }

  /// 选择用户，返回替换信息
  MentionSelection? selectUser(MentionUser user) {
    if (!_isSearching || _triggerOffset < 0) return null;

    final embed = MentionEmbed(userId: user.id, displayName: user.name);
    final replaceLength = 1 + _searchQuery.length;

    final selection = MentionSelection(
      embed: embed,
      replaceOffset: _triggerOffset,
      replaceLength: replaceLength,
    );

    cancelSearch();
    return selection;
  }

  /// 取消搜索
  void cancelSearch() {
    _isSearching = false;
    _searchQuery = '';
    _triggerOffset = -1;
    _searchResults = [];
    notifyListeners();
  }

  /// 按关键词过滤用户
  static List<MentionUser> filterUsers(
      List<MentionUser> users, String query) {
    if (query.isEmpty) return users;
    final lowerQuery = query.toLowerCase();
    return users
        .where((u) => u.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<void> _performSearch(String query) async {
    if (onSearch != null) {
      try {
        _searchResults = await onSearch!(query);
      } catch (_) {
        _searchResults = [];
      }
    }
    notifyListeners();
  }

  bool _isWhitespace(String char) {
    return char == ' ' || char == '\n' || char == '\t';
  }
}

/// 提及选择结果
class MentionSelection {
  const MentionSelection({
    required this.embed,
    required this.replaceOffset,
    required this.replaceLength,
  });

  final MentionEmbed embed;
  final int replaceOffset;
  final int replaceLength;
}
