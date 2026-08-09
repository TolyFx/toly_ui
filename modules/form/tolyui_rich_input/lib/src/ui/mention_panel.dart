/// @提及用户选择面板
library;

import 'package:flutter/material.dart';

import '../mention/mention_controller.dart';

/// @提及下拉面板
class MentionPanel extends StatefulWidget {
  const MentionPanel({
    super.key,
    required this.searchResults,
    required this.onSelect,
    required this.onDismiss,
  });

  final List<MentionUser> searchResults;
  final ValueChanged<MentionUser> onSelect;
  final VoidCallback onDismiss;

  @override
  State<MentionPanel> createState() => _MentionPanelState();
}

class _MentionPanelState extends State<MentionPanel> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(MentionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchResults != oldWidget.searchResults) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchResults.isEmpty) {
      return Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text('无匹配用户',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.searchResults.length,
          itemBuilder: (context, index) {
            return _buildUserItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildUserItem(int index) {
    final user = widget.searchResults[index];
    final isSelected = index == _selectedIndex;

    return ListTile(
      dense: true,
      selected: isSelected,
      selectedTileColor:
          Theme.of(context).colorScheme.primaryContainer,
      leading: CircleAvatar(
        radius: 14,
        child: Text(
          user.name.isNotEmpty ? user.name[0] : '?',
          style: const TextStyle(fontSize: 12),
        ),
      ),
      title: Text(user.name,
          style: const TextStyle(fontSize: 14)),
      onTap: () => widget.onSelect(user),
    );
  }
}
