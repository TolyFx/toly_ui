import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/incubator/components/navigation/tabs/toly_tabs.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../incubator/components/navigation/tabs/tabs.dart';

class TabsDemo1 extends StatefulWidget {
  const TabsDemo1({super.key});

  @override
  State<TabsDemo1> createState() => _TabsDemo1State();
}

class _TabsDemo1State extends State<TabsDemo1> with TickerProviderStateMixin {
  TabController? controller;

  List<MenuMeta> items = [
    MenuMeta(label: 'Tab1', router: 'tab1'),
    MenuMeta(label: 'Tab2', router: 'tab2'),
    MenuMeta(label: 'Tab3', router: 'tab3'),
    MenuMeta(label: 'Tab4', router: 'tab4'),
  ];

  @override
  void initState() {
    super.initState();
    initController(0);
  }

  void initController(int initialIndex) {
    if(controller!=null){
      controller?.dispose();
      controller=null;
    }
    controller = TabController(length: items.length, vsync: this,initialIndex: initialIndex);
  }

  String activeId = 'tab1';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(onPressed: (){
          items.add(  MenuMeta(label: 'Tab${items.length+1}', router: 'tab${items.length+1}'),);
          initController(items.length-1);
          setState(() {

          });
        }, icon: Icon(Icons.add)),
        TolyTabBar(
        overlayColor:WidgetStateProperty.all(Colors.transparent),
          indicatorPadding: EdgeInsets.only(bottom: 0),

          tabAlignment: TabAlignment.start,
          isScrollable: true,
          splashFactory: NoSplash.splashFactory,

          controller: controller,
          onTap: _onTap,
            tabs: items
                .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(e.label,style: TextStyle(fontWeight: activeId==e.id?FontWeight.bold:null),),
                    Icon(Icons.close,size: 14,)
                  ]),
                ))
                .toList()),
      ],
    );

    // return LayoutBuilder(
    //   builder: (context,cts) {
    //     print(cts);
    //     return const TabBar(tabs: tabs);
    //   }
    // );
    return TolyTabs(
      // onSelect: context.go,
      tabs: [
        MenuMeta(label: 'Tab1', router: 'tab1'),
        MenuMeta(label: 'Tab2', router: 'tab2'),
        MenuMeta(label: 'Tab3', router: 'tab3'),
        MenuMeta(label: 'Tab4', router: 'tab4'),
      ],
      activeId: activeId,
      onSelect: (MenuMeta value) {
        activeId = value.id;
        setState(() {});
      },
    );
  }

  void _onTap(int value) {
    activeId = items[value].id;
    setState(() {

    });
  }
}

class TolyUiTabCell extends StatelessWidget {
  const TolyUiTabCell({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

