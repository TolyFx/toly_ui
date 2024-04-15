import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toly_menu/toly_menu.dart';

import '../data/model/menu_history.dart';
import '../bloc/menu_history_bloc.dart';
import '../bloc/menu_router_bloc.dart';
import '../sync_menu/bloc/menu_bloc.dart';

extension BlocActionContext on BuildContext {

  void selectMenuAsync(MenuNode menu) => read<MenuRouterBloc>().selectMenu(menu);

  String? get activeMenuAsync => read<MenuRouterBloc>().activeMenu;

  MenuNode? get activeMenuNodeAsync => read<MenuRouterBloc>().activeMenuNode;

  void loadMenuAsync() => read<MenuRouterBloc>().loadMenu();

  void changeMenu(MenuNode menu) => read<MenuBloc>().changeMenu(menu);

  String? get activeMenu => read<MenuBloc>().state.activeMenu;


  MenuState get watchMenu => watch<MenuBloc>().state;

  MenuNode? get activeMenuNode => read<MenuBloc>().state.activeMenuNode;

  void loadMenu() => read<MenuBloc>().loadMenu();


  void addHistory(String title, String path) => read<MenuHistoryBloc>().addHistory(title, path);

  void activeHistory(String path) =>
      read<MenuHistoryBloc>().activeHistory(path);

  void removeHistory(MenuHistory history) => read<MenuHistoryBloc>().removeHistory(history);
}
