import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toly_menu/toly_menu.dart';

import '../../data/repository.dart';

class MenuBloc extends Cubit<MenuState> {
  final MenuRepository repository;

  MenuBloc({
    required this.repository,
  }) : super(MenuState(expandMenus: [], activeMenu: '', items: []));

  void loadMenu(){
    MenuNode root =  repository.loadMenuTree();
    var activeState =  repository.loadActiveState();
    emit(MenuState(
      expandMenus: activeState.expends,
      activeMenu: activeState.activeId,
      items: root.children,
    ));
  }

  void changeMenu(MenuNode menu) {
    MenuState oldSate = state;
    MenuState newState;
    if (menu.isLeaf) {
      newState = oldSate.copyWith(activeMenu: menu.path);
    } else {
      List<String> menus = [];
      String path = menu.path.substring(1);
      List<String> parts = path.split('/');
      if (parts.isNotEmpty) {
        String path = '';
        for (String part in parts) {
          path += '/$part';
          menus.add(path);
        }
      }

      if (oldSate.expandMenus.contains(menu.path)) {
        menus.remove(menu.path);
      }
      newState = oldSate.copyWith(expandMenus: menus);
    }
    emit(newState);
  }

  void selectMenuPath(String path) {
    MenuNode root = MenuNode(
      path: '',
      label: '',
      deep: -1,
      children: state.items,
    );
    List<MenuNode> result = findNodes(root, Uri.parse(path), 0, '/', []);
    if (result.isNotEmpty) {
      List<String> expandMenus = [];
      if (result.length > 1) {
        expandMenus.addAll(
            result.sublist(0, result.length - 1).map((e) => e.path).toList());
      }
      emit(state.copyWith(
          expandMenus: expandMenus,
          activeMenu:  result.last.path
      ));
    }
  }

  List<MenuNode> findNodes(
      MenuNode node,
      Uri uri,
      int deep,
      String prefix,
      List<MenuNode> result,
      ) {
    List<String> parts = uri.pathSegments;
    if (deep > parts.length - 1) {
      return result;
    }
    String target = parts[deep];
    if (node.children.isNotEmpty) {
      target = prefix + target;
      List<MenuNode> nodes =
      node.children.where((e) => e.path == target).toList();
      bool match = nodes.isNotEmpty;
      if (match) {
        MenuNode matched = nodes.first;
        result.add(matched);
        String nextPrefix = '${matched.path}/';
        findNodes(matched, uri, ++deep, nextPrefix, result);
      }
    }
    return result;
  }
}
