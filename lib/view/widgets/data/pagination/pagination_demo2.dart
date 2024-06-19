import 'package:flutter/material.dart';
import 'package:toly_ui/incubator/components/data/pagination/pagination.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '数据总量和页码容量',
  desc: 'total 设置数据总量，pageSize 设置每页数量；capacity 设置分页的容量，超过该值时会折叠中间值：',
)
class PaginationDemo2 extends StatelessWidget {
  const PaginationDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: TolyPagination(
          total: 10000,
          pageSize: 10,
          capacity: 15,
        ));
  }
}
