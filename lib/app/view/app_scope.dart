import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

import '../logic/app_state/app_logic.dart';

class AppScope extends StatelessWidget {
  final Widget child;

  const AppScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiBlocProvider(providers: [
        BlocProvider<AppLogic>(create: (_) => AppLogic()),
      ], child: child),
    );
  }
}
