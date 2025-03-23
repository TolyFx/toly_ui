import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '页签的添加和移除',
  desc: '通过 leading和tail 属性，可以设置左右的首尾组件：',
)
class TabsDemo6 extends StatefulWidget {
  const TabsDemo6({super.key});

  @override
  State<TabsDemo6> createState() => _TabsDemo6State();
}

class _TabsDemo6State extends State<TabsDemo6> with TickerProviderStateMixin {
  List<MenuMeta> items = const [
    MenuMeta(label: 'Tab1', route: 'tab1'),
    MenuMeta(label: 'Tab2', route: 'tab2'),
    MenuMeta(label: 'Tab3', route: 'tab3'),
    MenuMeta(label: 'Tab4', route: 'tab4'),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
          tail: _buildTail(),
          showDivider: false,
          showIndicator: false,
          labelPadding: EdgeInsets.symmetric(horizontal: 1),
          cellBuilder: (menu, meta) => CloseableTabCell(
            menu: menu,
            meta: meta,
            onDelete: _onDelete,
          ),
          tabs: items,
          activeId: activeId,
          onSelect: _onSelect,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  Widget _buildTail() => Wrap(spacing: 8, children: [
        IconButton(
          onPressed: addTab,
          icon: Icon(Icons.add),
        )
      ]);

  void addTab() {
    items = [
      ...items,
      MenuMeta(
        label: 'Tab${items.length + 1}',
        route: 'tab_${DateTime.now().millisecondsSinceEpoch}',
      ),
    ];
    activeId = items.last.route;
    setState(() {});
  }

  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }

  void _onDelete(MenuMeta value) {
    if (items.length == 1) return;
    int index = items.indexWhere((e) => e.id == activeId);
    int newActiveIndex = 0;
    List<MenuMeta> newList = List.of(items);
    if (items[index].id != value.id) {
      newActiveIndex = index;
    } else {
      if (index == items.length - 1) {
        newActiveIndex = index - 1;
      } else {
        newActiveIndex = index + 1;
      }
    }
    activeId = newList[newActiveIndex].id;

    newList.remove(value);
    setState(() {
      items = newList;
    });
  }
}

class CloseableTabCell extends StatelessWidget {
  final MenuMeta menu;
  final TabCellMeta meta;
  final ValueChanged<MenuMeta> onDelete;

  const CloseableTabCell({
    super.key,
    required this.menu,
    required this.meta,
    required this.onDelete,
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
    if (icon != null) {
      content.insert(0, Icon(icon, color: color, size: 18));
    }
    content.add(GestureDetector(
        onTap: () {
          onDelete.call(menu);
        },
        child: const Icon(
          Icons.close,
          size: 14,
        )));

    if (content.length > 1) {
      child = Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: content,
      );
      // child = Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   // spacing: 4,
      //   // crossAxisAlignment: WrapCrossAlignment.center,
      //   children: content,
      // );
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
