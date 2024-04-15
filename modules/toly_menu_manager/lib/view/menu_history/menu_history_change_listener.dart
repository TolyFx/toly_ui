import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toly_menu_manager/bloc/menu_history_bloc.dart';

import '../../bloc/menu_router_bloc.dart';
import '../../bloc/state.dart';

class MenuHistoryChangeListener extends StatelessWidget {
  final Widget child;
  final Function(BuildContext, String?) onRouterChanged;

  const MenuHistoryChangeListener(
      {super.key, required this.child, required this.onRouterChanged});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuHistoryBloc, MenuHistoryState>(
      child: child,
      listenWhen: (p, n) => p.activeHistory != n.activeHistory,
      listener: (ctx, state) {
        if(state.activeHistory==null){
          onRouterChanged(ctx, context.read<MenuRouterBloc>().activeMenu);
        }else{
          String? path = state.activeHistory;
          onRouterChanged(ctx, path);
          if(path!=null){
            Uri uri = Uri.parse(path);
            List<String> parts = uri.pathSegments;
            context.read<MenuRouterBloc>().selectMenuPath('/${parts.join('/')}');
          }
        }
      },
    );
  }
}

