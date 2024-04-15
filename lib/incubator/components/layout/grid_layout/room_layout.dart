// import 'package:flutter/material.dart';
// import 'package:livekit_client/livekit_client.dart';
// import 'package:meeting/src/views/mobile/room_page.dart';
// import 'landscape.dart';
// import 'portrait.dart';
//
// class RoomUserLayout extends StatefulWidget {
//   final List<LiveUser> data;
//
//   const RoomUserLayout({Key? key, required this.data}) : super(key: key);
//
//   @override
//   State<RoomUserLayout> createState() => _RoomUserLayoutState();
// }
//
// class _RoomUserLayoutState extends State<RoomUserLayout> {
//   List<LiveUser> get data => widget.data;
//
//   LiveUser? selectElement;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return  LayoutBuilder(
//           builder: (ctx,cts){
//             // 横向，宽 > 高
//             bool isLand = cts.maxWidth>cts.maxHeight;
//             int x = 0;
//             int y = 0;
//             if(isLand){
//               double minItemWidth = 200;
//               double minItemHeight = minItemWidth*9/16;
//               x = cts.maxWidth~/minItemWidth;
//               y = cts.maxHeight~/minItemHeight;
//             }else{
//               double minItemHeight = 200;
//               double minItemWidth = minItemHeight*3/4;
//               x = cts.maxWidth~/minItemWidth;
//               y = cts.maxHeight~/minItemHeight;
//             }
//
//             return !isLand?PortraitGridLayout(
//               selectElement: selectElement,
//               data: data,
//               onTapFull: (value){
//                 setState(() {
//                   selectElement = value;
//                 });
//               }, x: x, y: y,
//             ):LandGridLayout(
//               selectElement: selectElement,
//               data: data,
//               onTapFull: (value){
//                 setState(() {
//                   selectElement = value;
//                 });
//               }, x: x, y: y,
//             );
//           },
//     );
//   }
// }
//
//
//
//
//
