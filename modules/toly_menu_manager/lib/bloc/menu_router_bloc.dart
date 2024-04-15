import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toly_menu/toly_menu.dart';
import 'package:toly_menu_manager/bloc/state.dart';

import '../data/repository.dart';

class MenuRouterBloc extends Cubit<MenuLoadTask> {
  final AsyncMenuRepository repository;

  MenuRouterBloc({required this.repository}) : super(const MenuLoading());

  String? get activeMenu {
    if(state is MenuLoadSuccess){
      return (state as MenuLoadSuccess).state.activeMenu;
    }
    return null;
  }

  MenuNode? get activeMenuNode {
    if(state is MenuLoadSuccess){
      return (state as MenuLoadSuccess).state.activeMenuNode;
    }
    return null;
  }

  void loadMenu() async {
    emit(const MenuLoading());
    try {
      MenuNode root = await repository.loadMenuTree();
      var activeState = await repository.loadActiveState();
      emit(MenuLoadSuccess(
        state: MenuState(
          expandMenus: activeState.expends,
          activeMenu: activeState.activeId,
          items: root.children,
        ),
      ));
    } catch (e, trace) {
      print(e);
      emit(MenuLoadFailed(e, trace));
    }
  }

  void selectMenu(MenuNode menu) {
    if(state is! MenuLoadSuccess) return;
    MenuLoadSuccess old = state as MenuLoadSuccess;
    MenuState oldSate = old.state;
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
    emit(MenuLoadSuccess(
      state: newState,
    ));
  }

  void selectMenuPath(String path) {
    if(state is! MenuLoadSuccess) return;
    MenuLoadSuccess old = state as MenuLoadSuccess;
    MenuNode root = MenuNode(
      path: '',
      label: '',
      deep: -1,
      children: old.state.items,
    );
    List<MenuNode> result = findNodes(root, Uri.parse(path), 0, '/', []);
    if (result.isNotEmpty) {
      List<String> expandMenus = [];
      if (result.length > 1) {
        expandMenus.addAll(
            result.sublist(0, result.length - 1).map((e) => e.path).toList());
      }
      emit(MenuLoadSuccess(
        silentActive: true,
        state: old.state.copyWith(
          expandMenus: expandMenus,
          activeMenu:  result.last.path
        ),
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
