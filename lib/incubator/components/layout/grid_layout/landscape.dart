//
// import 'package:flutter/material.dart';
//
// class LandGridLayout extends StatelessWidget {
//   final int x;
//   final int y;
//   final List<LiveUser> data;
//   final ValueChanged<LiveUser?> onTapFull;
//   final LiveUser? selectElement;
//
//   const LandGridLayout({Key? key, required this.x, required this.y, required this.data, this.selectElement, required this.onTapFull}) : super(key: key);
//
//   int get perPageSize => x * y;
//
//   int get pageSize {
//     if(data.length%perPageSize==0) return data.length  ~/ perPageSize;
//
//     return (data.length  / perPageSize).floor() + 1;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return selectElement!=null? _buildSelectLayout():
//     PageView.builder(
//         itemCount: pageSize,
//         itemBuilder: (_, index) => buildAPage( perPageSize * index,perPageSize));
//   }
//   Widget buildAPage(int from, int size){
//     List<LiveUser> _realData;
//     if (from > data.length - perPageSize) {
//       _realData = data.getRange(from, data.length).toList();
//     } else {
//       _realData = data.getRange(from, from + size).toList();
//     }
//     bool isSingle = data.length ==1;
//
//     return XYGridLayout(
//       len: data.length,
//       land: true,
//       x: x,
//       y: y,
//       children: _realData
//           .map((e) => ClipRRect(
//             borderRadius: BorderRadius.circular(isSingle?0:6),
//             child: ColoredBox(
//               color: isSingle?Colors.transparent:Colors.black,
//               child: UserTile(
//                 expanded: false,
//                 user: e,
//                 onTapFull: onTapFull,
//               ),
//             ),
//           ))
//           .toList(),
//     );
//   }
//
//   Widget _buildSelectLayout() {
//     List<LiveUser> listData = data.where((e) => e!=selectElement).toList();
//
//     return Row(
//       children: [
//         Container(
//           width: 160,
//           alignment: Alignment.center,
//           child: ListView.separated(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               separatorBuilder: (_,__)=>const SizedBox(height: 6,),
//               itemCount: listData.length,
//               itemBuilder: (_,index)=> Center(
//                 child: SizedBox(
//                   width: 160,
//                   height: 160*9/16,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(6),
//                     child: ColoredBox(
//                       color: Colors.black,
//                       child: UserTile(
//                         expanded: false,
//                         onTapFull: onTapFull,
//                         user: listData[index],
//                       ),
//                     ),
//                   ),
//                 ),
//               ) ),
//         ),
//         Expanded(child: Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(6),
//             child: ColoredBox(
//               color: Colors.black,
//               child: UserTile(
//                 expanded: true,
//
//                 user: selectElement!,
//                 onTapFull: onTapFull,
//
//               ),
//             ),
//           ),
//         )),
//
//       ],
//     );
//   }
// }