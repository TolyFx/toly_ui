//
// import 'package:flutter/material.dart';
//
//
// class PortraitGridLayout extends StatelessWidget {
//   final int x;
//   final int y;
//   final List<LiveUser> data;
//   final ValueChanged<LiveUser?> onTapFull;
//   final LiveUser? selectElement;
//
//   const PortraitGridLayout({
//     Key? key,
//     required this.x,
//     required this.y,
//     required this.data,
//     this.selectElement,
//     required this.onTapFull,
//   }) : super(key: key);
//
//   int get perPageSize => x * y;
//
//   int get pageSize {
//     if (data.length % perPageSize == 0) return data.length ~/ perPageSize;
//
//     return (data.length / perPageSize).floor() + 1;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return selectElement != null
//         ? _buildSelectLayout()
//         : PageView.builder(
//             itemCount: pageSize,
//             itemBuilder: (_, index) =>
//                 buildAPage(perPageSize * index, perPageSize),
//           );
//     ;
//   }
//
//   Widget buildAPage(int from, int size) {
//     List<LiveUser> _realData;
//     if (from > data.length - perPageSize) {
//       _realData = data.getRange(from, data.length).toList();
//     } else {
//       _realData = data.getRange(from, from + size).toList();
//     }
//     bool isSingle = data.length == 1;
//
//     return XYGridLayout(
//       len: data.length,
//       x: x,
//       y: y,
//       children: _realData
//           .map((e) => ClipRRect(
//                 borderRadius: BorderRadius.circular(isSingle ? 0 : 6),
//                 child: ColoredBox(
//                   color: isSingle ? Colors.transparent : Colors.black,
//                   child: UserTile(
//                     user: e,
//                     expanded: false,
//                     onTapFull: onTapFull,
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }
//
//   Widget _buildSelectLayout() {
//     List<LiveUser> listData = data.where((e) => e != selectElement).toList();
//     return Column(
//       children: [
//         Expanded(
//             child: ClipRRect(
//           borderRadius: BorderRadius.circular(6),
//           child: ColoredBox(
//             color: Colors.black,
//             child: UserTile(
//               expanded: true,
//               onTapFull: onTapFull,
//               user: selectElement!,
//             ),
//           ),
//         )),
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           height: 100,
//           child: ListView.separated(
//               separatorBuilder: (_, __) => const SizedBox(
//                     width: 6,
//                   ),
//               itemCount: listData.length,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (_, index) => SizedBox(
//                     width: 120,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: ColoredBox(
//                         color: Colors.black,
//                         child: UserTile(
//                           expanded: false,
//                           user: listData[index],
//                           onTapFull: onTapFull,
//                         ),
//                       ),
//                     ),
//                   )),
//         )
//       ],
//     );
//   }
// }
