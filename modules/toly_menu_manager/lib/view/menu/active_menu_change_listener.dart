import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toly_menu/toly_menu.dart';

import '../../bloc/menu_history_bloc.dart';
import '../../bloc/menu_router_bloc.dart';
import '../../bloc/state.dart';
import '../../sync_menu/bloc/menu_bloc.dart';

class ActiveMenuChangeListener extends StatelessWidget {
  final Widget child;
  final Function(BuildContext, String?) onRouterChanged;

  const ActiveMenuChangeListener(
      {super.key, required this.child, required this.onRouterChanged});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuRouterBloc, MenuLoadTask>(
      child: child,
      listenWhen: (p, n) =>
          (p is MenuLoadSuccess) && (n is MenuLoadSuccess) && !n.silentActive,
      listener: (ctx, state) {
        if (state is MenuLoadSuccess) {
          context.read<MenuHistoryBloc>().clearActive();
          onRouterChanged(ctx, state.state.activeMenu);
        }
      },
    );
  }
}

class MenuChangeListener extends StatelessWidget {
  final Widget child;
  final Function(BuildContext ctx, String?) onRouterChanged;

  const MenuChangeListener({
    super.key,
    required this.child,
    required this.onRouterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      child: child,
      listenWhen: (p, n) => p.activeMenu!=n.activeMenu,
      listener: (ctx, state) {
        onRouterChanged(ctx, state.activeMenu);

      },
    );
  }
}
