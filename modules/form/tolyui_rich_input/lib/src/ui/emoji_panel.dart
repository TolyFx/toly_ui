/// 表情选择面板
library;

import 'package:flutter/material.dart';

import '../emoji/emoji_data.dart';

/// 表情选择面板组件
class EmojiPanel extends StatefulWidget {
  const EmojiPanel({
    super.key,
    required this.onSelect,
    this.onDismiss,
  });

  final ValueChanged<EmojiItem> onSelect;
  final VoidCallback? onDismiss;

  @override
  State<EmojiPanel> createState() => _EmojiPanelState();
}

class _EmojiPanelState extends State<EmojiPanel>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final _categories = EmojiCategory.values;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _categories.length, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 320,
        height: 300,
        child: Column(
          children: [
            _buildSearchBar(),
            if (_searchQuery.isEmpty) _buildCategoryTabs(),
            Expanded(child: _buildEmojiGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: '搜索表情...',
          prefixIcon: Icon(Icons.search, size: 18),
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      tabs: _categories
          .map((c) => Tab(text: c.label, height: 32))
          .toList(),
    );
  }

  Widget _buildEmojiGrid() {
    if (_searchQuery.isNotEmpty) {
      final filtered = filterEmojis(builtInEmojis, _searchQuery);
      return _buildGrid(filtered);
    }

    return TabBarView(
      controller: _tabController,
      children: _categories.map((category) {
        final grouped = groupByCategory(builtInEmojis);
        final emojis = grouped[category] ?? [];
        return _buildGrid(emojis);
      }).toList(),
    );
  }

  Widget _buildGrid(List<EmojiItem> emojis) {
    if (emojis.isEmpty) {
      return const Center(
        child: Text('无匹配表情',
            style: TextStyle(color: Colors.grey)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final emoji = emojis[index];
        return Tooltip(
          message: emoji.name,
          child: InkWell(
            onTap: () => widget.onSelect(emoji),
            borderRadius: BorderRadius.circular(4),
            child: Center(
              child: Text(emoji.code,
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
        );
      },
    );
  }
}
