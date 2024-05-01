import 'package:flutter/material.dart';
import 'package:toly_menu/toly_menu.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }

}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          SizedBox(width: 210,
          child: TolyMenuRail(),
          )
        ],
      ),
    );
  }


}

class TolyMenuRail extends StatefulWidget {
  const TolyMenuRail({super.key});

  @override
  State<TolyMenuRail> createState() => _TolyMenuRailState();
}

class _TolyMenuRailState extends State<TolyMenuRail> {
  MenuState state = MenuState(expandMenus: ['/dashboard'], activeMenu: '/dashboard/data_analyse', items: [
    MenuNode(
        path: '/dashboard',
        label: '总览面板',
        children: [
          MenuNode(
              path: '/dashboard/data_analyse',
              label: '数据分析',
              deep: 1),
          MenuNode(
              path: '/dashboard/work_board',
              label: '工作台',
              deep: 1,
              children: [
                MenuNode(
                    path:
                    '/dashboard/work_board/a',
                    label: '第一工作区',
                    deep: 2),
                MenuNode(
                    path:
                    '/dashboard/work_board/b',
                    label: '第二工作区',
                    deep: 2),
                MenuNode(
                    path:
                    '/dashboard/work_board/c',
                    label: '第三工作区',
                    deep: 2),
              ]),
        ]),
    MenuNode(
        path: '/knowledge',
        label: '知识库管理',
        children: [
          MenuNode(
              path: '/knowledge/a',
              label: '语文',
              deep: 1,
              children: [
                MenuNode(
                  path: '/knowledge/a/1',
                  label: '诗词歌赋',
                  deep: 2,
                ),
                MenuNode(
                  path: '/knowledge/a/2',
                  label: '人物故事',
                  deep: 2,
                ),
                MenuNode(
                  path: '/knowledge/a/3',
                  label: '名著推荐',
                  deep: 2,
                )
              ]
          ),
          MenuNode(
              path: '/knowledge/b',
              label: '数学',
              children: [
                MenuNode(
                  path: '/knowledge/b/1',
                  label: '人物故事',
                  deep: 2,
                ),
                MenuNode(
                  path: '/knowledge/b/2',
                  label: '数学定理',
                  deep: 2,
                ),
                MenuNode(
                  path: '/knowledge/b/3',
                  label: '几何知识',
                  deep: 2,
                ),
                MenuNode(
                  path: '/knowledge/b/4',
                  label: '代数知识',
                  deep: 2,
                )
              ],
              deep: 1),
          MenuNode(
              path: '/knowledge/c',
              label: '英语',
              deep: 1),
        ]),
  ]);


  @override
  Widget build(BuildContext context) {
    return TolyMenu(state: state, onSelect: _onSelect);
  }

  void _onSelect(MenuNode menu) {
    if(menu.isLeaf){
      state = state.copyWith(activeMenu: menu.path);
    }else{
      List<String> menus = [];
      String path = menu.path.substring(1);
      List<String> parts = path.split('/');

      if(parts.isNotEmpty){
        String path = '';
        for (String part in parts) {
          path+='/$part';
          menus.add(path);
        }
      }

      if(state.expandMenus.contains(menu.path)){
        menus.remove(menu.path);
      }

      state = state.copyWith(expandMenus: menus);

    }
    setState(() {

    });
  }
}
