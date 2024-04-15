import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/menu_history_bloc.dart';
import '../../bloc/menu_router_bloc.dart';
import '../../bloc/state.dart';

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
      (p is MenuLoadSuccess) &&
          (n is MenuLoadSuccess) && !n.silentActive,
      listener: (ctx, state) {
        if (state is MenuLoadSuccess) {
          context.read<MenuHistoryBloc>().clearActive();
          onRouterChanged(ctx, state.state.activeMenu);
        }
      },
    );
  }
}
