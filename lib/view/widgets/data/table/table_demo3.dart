import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_table/toly_table.dart';

@DisplayNode(
  title: '紧凑型表格',
  desc: '展示不同尺寸的表格样式。通过 size 属性控制表格的紧凑程度，提供 middle 和 small 两种尺寸选项。中等尺寸适合常规页面展示，小尺寸适用于对话框或空间受限的场景。',
)
class TableDemo3 extends StatelessWidget {
  const TableDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Middle size table', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 16),
        _SizeTable(size: TableSize.middle),
        SizedBox(height: 32),
        Text('Small size table', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 16),
        _SizeTable(size: TableSize.small),
      ],
    );
  }
}

class _SizeTable extends StatelessWidget {
  final TableSize size;

  const _SizeTable({required this.size});

  @override
  Widget build(BuildContext context) {
    return TolyTable<SimpleData>(
      size: size,
      columns: [
        TableColumn(
          title: 'Name',
          dataIndex: (data) => data.name,
        ),
        TableColumn(
          title: 'Age',
          dataIndex: (data) => data.age,
        ),
        TableColumn(
          title: 'Address',
          dataIndex: (data) => data.address,
        ),
      ],
      dataSource: const [
        SimpleData(
          key: '1',
          name: 'John Brown',
          age: 32,
          address: 'New York No. 1 Lake Park',
        ),
        SimpleData(
          key: '2',
          name: 'Jim Green',
          age: 42,
          address: 'London No. 1 Lake Park',
        ),
        SimpleData(
          key: '3',
          name: 'Joe Black',
          age: 32,
          address: 'Sydney No. 1 Lake Park',
        ),
      ],
    );
  }
}

class SimpleData {
  final String key;
  final String name;
  final int age;
  final String address;

  const SimpleData({
    required this.key,
    required this.name,
    required this.age,
    required this.address,
  });
}
