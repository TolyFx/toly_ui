import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:toly_menu/toly_menu.dart';
import 'package:toly_menu_manager/data/model/menu_history.dart';

abstract class AsyncMenuRepository {

  /// 同步/异步 加载菜单树数据
  FutureOr<MenuNode> loadMenuTree();

  /// 同步/异步 加载菜单树激活信息
  /// List<String>: 展开项列表
  /// String: 激活项 id
  FutureOr<ActiveState> loadActiveState();

  /// 同步/异步 加载菜单历史
  FutureOr<List<MenuHistory> > loadMenuHistory();

  /// 同步/异步 保存菜单历史
  FutureOr<void> saveMenuHistory(MenuHistory history);
  FutureOr<void> deleteMenuHistory(MenuHistory history);
}

/// expends: 展开项列表
/// activeId : 激活项 id
class ActiveState{
  final List<String> expends;
  final String activeId;

  ActiveState(this.expends, this.activeId);
}

abstract class MenuRepository {

  /// 同步/异步 加载菜单树数据
  MenuNode loadMenuTree();

  /// 同步/异步 加载菜单树激活信息
  /// List<String>: 展开项列表
  /// String: 激活项 id
  ActiveState loadActiveState();

}

abstract class MenuHistoryRepository {

  /// 同步/异步 加载菜单历史
  @protected
  List<MenuHistory> loadMenuHistory()=>[];

  /// 同步/异步 保存菜单历史
  @protected
  void saveMenuHistory(MenuHistory history){}

  @protected
  void deleteMenuHistory(MenuHistory history){}

}
