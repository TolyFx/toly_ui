import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/menu_history_bloc.dart';
import '../../bloc/state.dart';
import '../../toly_menu_manager.dart';

class MenuRecordTab extends StatelessWidget {
  final Function(BuildContext,MenuHistory) onCloseHistory;
  final Function(BuildContext,String) onTapHistory;

  const MenuRecordTab({
    super.key,
    required this.onCloseHistory,
    required this.onTapHistory,
  });

  @override
  Widget build(BuildContext context) {
    MenuHistoryState task = context
        .watch<MenuHistoryBloc>()
        .state;
    Widget child = const SizedBox();
    if (task is MenuHistoryState) {
      if(task.history.isEmpty) return child;
      child = ListView(
          scrollDirection: Axis.horizontal,
          children: task.history
              .map((e) =>
              RecordTab(
                // canClose:  task.history.length > 1,
                canClose:  true,
                onCloseHistory: onCloseHistory,
                onTapHistory: onTapHistory,
                active: task.activeHistory == e.menuPath,
                history: e,
              ))
              .toList());
    }

    const BorderSide side = BorderSide(color: Color(0xffE8E8E8), width: 1);
    Color themeColor = Theme
        .of(context)
        .primaryColor;
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          // color: const Color(0xffF2F2F2),
          border: Border(top: side, bottom: side)),
      height: 28,
      child: child,
    );
  }
}

class RecordTab extends StatelessWidget {
  final bool active;
  final bool canClose;
  final MenuHistory history;
  final Function(BuildContext,MenuHistory) onCloseHistory;
  final Function(BuildContext,String) onTapHistory;
  const RecordTab({
    super.key,
    this.active = false,
    required this.canClose,
    required this.history,
    required this.onCloseHistory,
    required this.onTapHistory,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTapHistory(context,history.menuPath),
      child: ColoredBox(
        color: active ? Colors.white : Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  history.menuLabel,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                if (canClose)
                  CloseHoverButton(onPressed: () => onCloseHistory(context,history))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CloseHoverButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CloseHoverButton({super.key, required this.onPressed});

  @override
  State<CloseHoverButton> createState() => _CloseHoverButtonState();
}

class _CloseHoverButtonState extends State<CloseHoverButton> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onExit: _onExit,
        onEnter: _onEnter,
        child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: _isHover ? Color(0xffBFC5C8) : Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              CupertinoIcons.clear_thick,
              size: 10,
              color: _isHover ? Colors.white : Colors.grey,
            )),
      ),
    );
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _isHover = false;
    });
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _isHover = true;
    });
  }
}
