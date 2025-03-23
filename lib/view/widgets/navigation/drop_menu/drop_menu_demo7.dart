import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '右键触发',
  desc: '可以通过右键，在一个组件之上弹出菜单面板。',
)
class DropMenuDemo7 extends StatelessWidget {
  const DropMenuDemo7({super.key});

  @override
  Widget build(BuildContext context) {
    // return RightClickAnimation();
    Color bgColor = context.isDark ? const Color(0xff303133) : Colors.white;
    return TolyDropMenu(
      onSelect: onSelect,

      decorationConfig: DecorationConfig(isBubble: false, backgroundColor: bgColor),
      placement: Placement.topStart,
      menuItems: [
        ActionMenu(const MenuMeta(route: '01', label: '1st menu item')),
        ActionMenu(const MenuMeta(route: '02', label: '2nd menu item')),
        SubMenu(const MenuMeta(route: '03', label: 'export image'), menus: [
          ActionMenu(const MenuMeta(route: 'png', label: 'sub out .png')),
          ActionMenu(const MenuMeta(route: 'jpeg', label: 'sub out .jpeg')),
          ActionMenu(const MenuMeta(route: 'svg', label: 'sub out .svg')),
        ]),
        ActionMenu(const MenuMeta(route: '04', label: '4ur menu item')),
      ],
      // width: 140,
      childBuilder: _childBuilder,
    );
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 菜单');
  }

  void _onSecondaryTapDown(TapDownDetails details, PopoverController ctrl) async {
    if (ctrl.isOpen) {
      ctrl.close();
      await Future.delayed(const Duration(milliseconds: 280));
    }
    ctrl.open(position:details.localPosition);
    // ctrl.openAt(details.localPosition);
  }

  Widget _childBuilder(_, PopoverController ctrl, __) {
    return GestureDetector(
      onTapDown: (_) => ctrl.close(),
      onSecondaryTapDown: (detail) => _onSecondaryTapDown(detail, ctrl),
      child: Container(
        color: const Color(0xfff7f7f7),
        alignment: Alignment.center,
        height: 180,
        child: const Text('Right Click on here'),
      ),
    );
  }
}


class RightClickAnimation extends StatefulWidget{
  const RightClickAnimation({super.key});

  @override
  State<RightClickAnimation> createState() => _RightClickAnimationState();
}

class _RightClickAnimationState extends State<RightClickAnimation>  with SingleTickerProviderStateMixin{

  late AnimationController _backingController = AnimationController(
  duration: Duration(seconds: 2),
  reverseDuration:  Duration(seconds: 2),
  vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (d){
        _backingController.forward(from: 0);
      },
      child: Container(
        color: Colors.red,
        child: FadeTransition(
            opacity: _backingController,
            child: FlutterLogo()),
      ),
    );
  }
}
