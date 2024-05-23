import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';

class MenuDisplayExt extends MenuMateExt {
  final ImageProvider? image;
  final String? action;

  const MenuDisplayExt({this.image, this.action});
}

class DropMenuDemo7 extends StatelessWidget {
  const DropMenuDemo7({super.key});

  @override
  Widget build(BuildContext context) {
    DropMenuCellStyle lightStyle = const DropMenuCellStyle(
      padding: EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      foregroundColor: Color(0xff1f1f1f),
      backgroundColor: Colors.transparent,
      disableColor: Color(0xffbfbfbf),
      hoverBackgroundColor: Color(0xfff5f5f5),
      hoverForegroundColor: Color(0xff1f1f1f),
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: TolyDropMenu(
          onSelect: onSelect,
          style: lightStyle,
          tailBuilder: _tailBuilder,
          leadingBuilder: _leadingBuilder,
          subMenuGap: 6,
          placement: Placement.bottomStart,
          decorationConfig:
              DecorationConfig(isBubble: false, backgroundColor: Colors.white),
          offsetCalculator: boxOffsetCalculator,
          menuItems: [
            ActionMenu(const MenuMeta(
                router: '01',
                label: '1st menu item',
                ext: MenuDisplayExt(
                  image: AssetImage('assets/images/icon_head.webp'),
                  action: 'Ctrl+J',
                ))),
            ActionMenu(
              const MenuMeta(
                  router: '02',
                  label: '2nd menu item',
                  ext: MenuDisplayExt(
                    image: AssetImage('assets/images/logo.png'),
                    action: 'Ctrl+P',
                  )),
            ),
            SubMenu(
                const MenuMeta(
                    router: 'export',
                    label: 'export image',
                    icon: Icons.file_upload_outlined),
                menus: [
                  ActionMenu(
                      const MenuMeta(router: 'png', label: 'sub out .png')),
                  ActionMenu(
                      const MenuMeta(router: 'jpeg', label: 'sub out .jpeg')),
                  ActionMenu(
                      const MenuMeta(router: 'svg', label: 'sub out .svg')),
                  SubMenu(
                      const MenuMeta(router: 'sub sub', label: 'sub sub menu'),
                      menus: [
                        ActionMenu(
                            const MenuMeta(router: 's1', label: 'sub menu1')),
                        ActionMenu(
                            const MenuMeta(router: 's2', label: 'sub menu2')),
                        ActionMenu(
                            const MenuMeta(router: 's3', label: 'sub menu3')),
                      ]),
                ]),
            const DividerMenu(),
            ActionMenu(const MenuMeta(router: '03', label: '3rd menu item'),
                enable: false),
            ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
          ],
          // width: 160,
          childBuilder: (_, ctrl, __) {
            return DebugDisplayButton(
              info: 'Leading&tail',
              onPressed: ctrl.open,
            );
          }),
    );
  }

  void onSelect(
    MenuMeta menu,
  ) {
    $message.success(message: '点击了 [${menu.label}] 菜单');
  }

  Widget? _tailBuilder(
      BuildContext context, MenuMeta menu, DropMenuDisplayMeta display) {

    MenuDisplayExt? ext = menu.ext?.me<MenuDisplayExt>();

    if (ext?.action != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          ext!.action!,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    return null;
  }

  Widget? _leadingBuilder(
      BuildContext context, MenuMeta menu, DropMenuDisplayMeta display) {
    if(menu.router == '04'){
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: FlutterLogo(size: 18,));
    }
    MenuDisplayExt? ext = menu.ext?.me<MenuDisplayExt>();
    if (ext?.image != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Image(
          image: ext!.image!,
          width: 20,
        ),
      );
    }
    if (menu.icon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          menu.icon!,
          size: 20,
        ),
      );
    }
    return null;
  }
}
