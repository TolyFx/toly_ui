
import 'tree_node.dart';

class MenuTreeMeta {
  final List<String> expandMenus;
  final MenuNode? activeMenu;
  final MenuNode root;

  List<MenuNode> get items => root.children;

  MenuTreeMeta({
    required this.expandMenus,
    required this.activeMenu,
    required this.root,
  });

  MenuNode? queryMenuNodeByPath(MenuNode node, String path) {
    if (node.id == path) {
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

  MenuTreeMeta selectPath(String path, {bool singleExpand = false}) {
    MenuNode? node = queryMenuNodeByPath(root, path);
    if (node == null) return this;
    return select(node);
  }

  List<String> parentsPath(String path) {
    List<String> parts = path.split('/');
    List<String> menus = ['/'];
    if (parts.isNotEmpty) {
      for (int i = 1; i < parts.length; i++) {
        List<String> ps =  parts.sublist(0,i);
        String path = ps.join('/');
        if(path.isNotEmpty){
          menus.add(path);
        }
      }
    }
    return menus;
  }

  MenuTreeMeta select(MenuNode menu, {bool singleExpand = false}) {
    if (menu.isLeaf) return copyWith(activeMenu: menu, expandMenus: parentsPath(menu.id));
    List<String> menus = [];
    String path = menu.id.substring(1);
    List<String> parts = path.split('/');

    if (parts.isNotEmpty) {
      String path = '';
      for (String part in parts) {
        path += '/$part';
        menus.add(path);
      }
    }

    if (expandMenus.contains(menu.id)) {
      menus.remove(menu.id);
      // expandMenus.map((e) => null);
    }

    if (!singleExpand) {
      menus.addAll(expandMenus.where((e) => e != menu.id));
    }

    return copyWith(expandMenus: menus);
  }

  MenuTreeMeta copyWith({
    List<String>? expandMenus,
    MenuNode? activeMenu,
    MenuNode? root,
  }) {
    return MenuTreeMeta(
      expandMenus: expandMenus ?? this.expandMenus,
      activeMenu: activeMenu ?? this.activeMenu,
      root: root ?? this.root,
    );
  }
}
