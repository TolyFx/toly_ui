import 'package:flutter/material.dart';
import 'package:tolyui/debugger/debug_constraints_display.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  ///      maxCrossAxisExtent: 320,
//       mainAxisSpacing: 10,
//       mainAxisExtent: 240,
//       crossAxisSpacing: 10,

  @override
  Widget build(BuildContext context) {
    // return Scaffold(body: const Center(child: Text('WidgetsPage')));
    return const Scaffold(
      body: Center(
        child: DebugConstraintsDisplay(
          color: Color(0xff00ffff),
          showBorder: true,
          showColor: true,
          // showConstraints: true,
          // child: WrapGridLayout(
          //   maxWidth: 320,
          //   height: 240,
          //   spacing: 12,
          //   runSpacing: 12,
          //   children: [
          //     ShowPanel(
          //       color: Colors.blue,
          //       icon: TolyIcon.iconMultiPlatform,
          //       title: '全平台支持',
          //       info:
          //       '支持全平台应用开发中的视图构建。Android、iOS、MacOS、Linux、Windows、Web',
          //     ),
          //     ShowPanel(
          //       color: Colors.orange,
          //       icon: TolyIcon.iconLink,
          //       title: '组件化',
          //       info: '组件独立存在，可选择使用个体组件。不侵入你原有的项目代码结构。',
          //     ),
          //     ShowPanel(
          //       color: Colors.green,
          //       icon: TolyIcon.iconOpenSrc,
          //       title: '源代码开放',
          //       info: 'MIT 开源协议，源代码完全公开，允许任何个人和企业使用。',
          //     ),
          //     ShowPanel(
          //       color: Colors.red,
          //       icon: TolyIcon.iconReactive,
          //       title: '响应式布局',
          //       info: '根据设备屏幕信息，让视图可以响应式变化。',
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
