import 'package:flutter/material.dart';

import '../../res/tolyui_icon.dart';

class EmptyDataView extends StatelessWidget {
  const EmptyDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          Icon(
            TolyuiIcon.empty_data,
            size: 64,
            color: Colors.grey,
          ),
          Text("暂无数据",style: TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }
}
