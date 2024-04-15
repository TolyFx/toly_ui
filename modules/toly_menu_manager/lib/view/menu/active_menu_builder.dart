import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toly_menu/toly_menu.dart';

import '../../bloc/state.dart';
import '../../toly_menu_manager.dart';

typedef MenuChangeBuilder = Function(BuildContext context, MenuNode? menu);

class ActiveMenuBuilder extends StatelessWidget {
  final MenuChangeBuilder builder;

  const ActiveMenuBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuRouterBloc, MenuLoadTask>(
        buildWhen: (p, n) =>
            (p is MenuLoadSuccess) &&
            (n is MenuLoadSuccess) &&
            p.state.activeMenu != n.state.activeMenu,
        builder: (_, state) {
          if (state is MenuLoadSuccess) {
            return builder.call(context, state.state.activeMenuNode);
          }
          return builder.call(context, null);
        });
  }
}
