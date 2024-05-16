// // Copyright 2014 The 张风捷特烈 . All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// // Author:      张风捷特烈
// // CreateTime:  2024-05-16
// // Contact Me:  1981462002@qq.com
//
// import 'package:flutter/material.dart';
// import 'package:flutter/src/gestures/events.dart';
// import 'package:toly_ui/view/debugger/debugger.dart';
// import 'package:tolyui/tolyui.dart';
//
// import '../../feedback/feedback.dart';
//
// class DropMenuDisplay extends StatelessWidget {
//   const DropMenuDisplay({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Wrap(
//           spacing: 20,
//           children: [
//             TolyPopover(
//               placement: Placement.bottom,
//               maxWidth: 200,
//               overlayBuilder: (_, ctrl) => MenuListPanel(
//                 disableList: ['03'],
//                 menus: [
//                   MenuMeta(router: '01', label: '1st menu item'),
//                   MenuMeta(router: '02', label: '2nd menu item'),
//                   MenuMeta(router: '03', label: '3rd menu item'),
//                   MenuMeta(router: '04', label: '4ur menu item'),
//                 ],
//                 onSelect: (index) {
//                   ctrl.close();
//                   $message.success(message: '点击了第 ${index} 个菜单');
//                 },
//               ),
//               builder: (_, ctrl, __) {
//                 return DebugDisplayButton(
//                   info: 'DropMenu',
//                   onPressed: ctrl.open,
//                 );
//               },
//             ),
//             TolyPopover(
//               // overlayDecorationBuilder: decorationBuilder,
//               placement: Placement.bottomStart,
//               decorationConfig: DecorationConfig(isBubble: false),
//               maxWidth: 200,
//               offsetCalculator: (_) => Offset(0, -8),
//               overlayBuilder: (_, ctrl) => MenuListPanel(
//                 disableList: ['03'],
//                 menus: [
//                   MenuMeta(router: '01', label: '1st menu item'),
//                   MenuMeta(router: '02', label: '2nd menu item'),
//                   MenuMeta(router: '03', label: '3rd menu item'),
//                   MenuMeta(router: '04', label: '4ur menu item'),
//                 ],
//                 onSelect: (MenuMeta menu) {
//                   ctrl.close();
//                   $message.success(message: '点击了 [${menu.label}] 个菜单');
//                 },
//               ),
//               builder: (_, ctrl, __) {
//                 return DebugDisplayButton(
//                     info: 'DropMenu', onPressed: ctrl.open);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
