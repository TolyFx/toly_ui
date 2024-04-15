import 'menu_data.dart';

class MenuState {
  final List<String> expandMenus;
  final String activeMenu;
  final List<MenuNode> items;

  MenuState({
    required this.expandMenus,
    required this.activeMenu,
    required this.items,
  });

  MenuNode? get activeMenuNode => queryMenuNodeByPath(
        MenuNode(
          path: '',
          label: '',
          deep: -1,
          children: items,
        ),
        activeMenu,
      );

  MenuNode? queryMenuNodeByPath(MenuNode node, String path) {
    if (node.path == path) {
      return node;
    }
    if (node.children.isNotEmpty) {
      for (int i = 0; i < node.children.length; i++) {
        MenuNode? result = queryMenuNodeByPath(node.children[i], path);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  MenuState copyWith({
    List<String>? expandMenus,
    String? activeMenu,
    List<MenuNode>? items,
  }) {
    return MenuState(
      expandMenus: expandMenus ?? this.expandMenus,
      activeMenu: activeMenu ?? this.activeMenu,
      items: items ?? this.items,
    );
  }
}
