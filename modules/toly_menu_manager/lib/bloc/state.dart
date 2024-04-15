import 'package:equatable/equatable.dart';
import 'package:toly_menu/toly_menu.dart';

import '../data/model/menu_history.dart';

sealed class MenuLoadTask {
  const MenuLoadTask();
}

class MenuLoading extends MenuLoadTask {
  const MenuLoading();
}

class MenuLoadSuccess extends MenuLoadTask with EquatableMixin {
  final MenuState state;
  final bool silentActive;


  const MenuLoadSuccess({
    required this.state,
    this.silentActive = false
  });

  @override
  List<Object?> get props => [state,];
}

class MenuLoadFailed extends MenuLoadTask {
  final Object error;
  final StackTrace trace;

  const MenuLoadFailed(this.error, this.trace);
}

class MenuHistoryState with EquatableMixin {

  final List<MenuHistory> history;
  final String? activeHistory;

  const MenuHistoryState({
    required this.history,
    this.activeHistory,
  });

  factory MenuHistoryState.none()=>const MenuHistoryState(history:  []);

  @override
  List<Object?> get props => [history, activeHistory];
}
