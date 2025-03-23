import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '自定义页签组件',
  desc: '通过 cellBuilder 可以自定义构建页签样式：',
)
class TabsDemo5 extends StatefulWidget {
  const TabsDemo5({super.key});

  @override
  State<TabsDemo5> createState() => _TabsDemo5State();
}

class _TabsDemo5State extends State<TabsDemo5> with TickerProviderStateMixin {
  List<MenuMeta> items = [
    IconMenu( Icons.anchor,label: 'Tab1', route: 'tab1'),
    IconMenu( Icons.ramp_right,label: 'Tab2', route: 'tab2'),
    IconMenu( Icons.cable,label: 'Tab3', route: 'tab3'),
    IconMenu( Icons.account_box_rounded,label: 'Tab4', route: 'tab4'),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
            showDivider: false,
            showIndicator: false,
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.symmetric(horizontal: 1),
            cellBuilder: (menu, meta) => DiyTabCell(
                  menu: menu,
                  meta: meta,
                ),
            tabs: items,
            activeId: activeId,
            onSelect: _onSelect),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }
}

class DiyTabCell extends StatelessWidget {
  final MenuMeta menu;
  final TabCellMeta meta;

  const DiyTabCell({
    super.key,
    required this.menu,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    Color? color;
    // FontWeight? fontWeight = widget.active ? FontWeight.bold : null;
    if (meta.active || meta.hovered) {
      color = Theme.of(context).primaryColor;
    }
    if (!menu.enable) {
      color = Color(0xff8c8c8c);
    }
    Widget child = Text(
      menu.label,
      maxLines: 1,
      style: TextStyle(
        // fontWeight: fontWeight,
        color: color,
      ),
    );
    List<Widget> content = [child];
    IconData? icon;
    if(menu is IconMenu){
      icon = (menu as IconMenu).icon;
    }
    if (icon!= null) {
      content.insert(0, Icon(icon, color: color, size: 18));
    }

    if (content.length > 1) {
      child = Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: content,
      );
    }
    const BorderSide side = BorderSide(color: Color(0xfff0f0f0));
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: side,
            left: side,
            right: side,
            bottom: meta.active ? BorderSide.none : side,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
            topLeft: Radius.circular(6),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          color: !meta.active ? Color(0xfffafafa) : null,
        ),
        child: child);
  }
}
