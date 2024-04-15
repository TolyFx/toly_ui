
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toly_menu_manager/ext/ext.dart';

import '../../bloc/menu_router_bloc.dart';
import '../../bloc/state.dart';

typedef MenuLoadBuilder = Function(BuildContext context, MenuLoadTask task);

class MenuLoadTaskBuilder extends StatefulWidget {
  final MenuLoadBuilder builder;

  const MenuLoadTaskBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<MenuLoadTaskBuilder> createState() => _MenuLoadTaskBuilderState();
}

class _MenuLoadTaskBuilderState extends State<MenuLoadTaskBuilder> {
  @override
  Widget build(BuildContext context) {
    MenuLoadTask task = context.watch<MenuRouterBloc>().state;
    return widget.builder(context, task);
  }

  @override
  void reassemble() {
    context.loadMenu();
    super.reassemble();
  }
}

