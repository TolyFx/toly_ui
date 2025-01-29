import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '基本使用',
  desc: '当数据量过多时，使用分页分解数据。点击数字或者按钮可以切换激活页码：',
)
class PaginationDemo1 extends StatelessWidget {
  const PaginationDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: TolyPagination(
          total: 1000,
        ));
  }
}
