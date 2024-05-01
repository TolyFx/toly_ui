import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toly_menu_manager/bloc/state.dart';

import '../data/repository.dart';
import '../data/model/menu_history.dart';

class MenuHistoryBloc extends Cubit<MenuHistoryState> {
  final AsyncMenuRepository repository;

  MenuHistoryBloc({required this.repository}) : super(MenuHistoryState.none());

  void loadHistory() async {
    try {
      List<MenuHistory> history = await repository.loadMenuHistory();
      String? activeHistory;
      if (history.isNotEmpty) {
        activeHistory = history.first.menuPath;
      }
      emit(MenuHistoryState(history: history, activeHistory: activeHistory));
    } catch (e) {
      print(e);
      // emit(MenuLoadFailed(e, trace));
    }
  }

  void addHistory(String title, String path) {
    MenuHistory history = MenuHistory(menuLabel: title, menuPath: path);
    state.history.removeWhere((e) => e.menuPath == path);
    repository.saveMenuHistory(history);
    emit(MenuHistoryState(
      history: [history, ...state.history],
      activeHistory: path,
    ));
  }

  void activeHistory(String path){
    emit(MenuHistoryState(
      history: state.history,
      activeHistory: path,
    ));
  }

  void clearActive(){
    emit(MenuHistoryState(
      history: state.history,
      activeHistory: null,
    ));
  }

  void removeHistory(MenuHistory history) {
    String? activeHistory = state.activeHistory;
    int index = state.history.indexWhere((e) => e.menuPath == history.menuPath);
    print(index);
    if(state.history.length==1){
      activeHistory = null;
    }else{
      /// 如果删除的是当前激活历史
      /// 修改激活索引
      if(history.menuPath==state.activeHistory){
        if(index==0){
          //第一个
          activeHistory = state.history[index+1].menuPath;
        }else{
          activeHistory = state.history[index-1].menuPath;
        }
      }
    }
    List<MenuHistory> newHistory = state.history.toList();
    newHistory.removeAt(index);
    repository.deleteMenuHistory(history);
    emit(MenuHistoryState(
      history: [...newHistory],
      activeHistory: activeHistory,
    ));

    // MenuHistory history = MenuHistory(menuLabel: title, menuPath: path);
    // state.history.removeWhere((e) => e.menuPath == path);
    // repository.saveMenuHistory(history);
    // emit(MenuHistoryState(
    //   history: [history, ...state.history],
    //   activeHistory: path,
    // ));
  }
}
