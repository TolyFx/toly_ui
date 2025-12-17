import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '固定高度表格',
  desc:
      '展示固定高度的可滚动表格。当表格内容超出指定高度时，会出现垂直滚动条。适用于需要限制表格占用空间的场景，如对话框、侧边栏或固定布局区域。支持水平滚动以适应更多列。',
)
class TableDemo6 extends StatefulWidget {
  const TableDemo6({super.key});

  @override
  State<TableDemo6> createState() => _TableDemo6State();
}

class _TableDemo6State extends State<TableDemo6> {
  // 生成更多测试数据
  List<ScrollableData> get _scrollData => List.generate(
        15,
        (index) => ScrollableData(
          key: '${index + 1}',
          name: 'User ${index + 1}',
          age: 20 + (index % 50),
          address:
              'Very long address text for User ${index + 1} at location ${index + 1}',
          email: 'user${index + 1}@example.com',
          phone: '+1 555-${(1000 + index).toString().padLeft(4, '0')}',
          department: _getDepartment(index),
          salary: '\$${(50000 + index * 1000).toString()}',
        ),
      );

  String _getDepartment(int index) {
    final departments = [
      'Engineering',
      'Marketing',
      'Sales',
      'HR',
      'Finance',
      'Operations'
    ];
    return departments[index % departments.length];
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '固定高度 300px，支持垂直和水平滚动',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        TolyTableV1<ScrollableData>(
          height: 300,
          bordered: true,
          columns: [
            TableColumn(
              title: 'Name',
              dataIndex: (data) => data.name,
              width: 120,
              render: (data, index) => Text(
                data.name,
                style: const TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            TableColumn(
              title: 'Age',
              dataIndex: (data) => data.age,
              width: 80,
              align: TextAlign.center,
            ),
            TableColumn(
              title: 'Email',
              dataIndex: (data) => data.email,
              width: 200,
            ),
            TableColumn(
              title: 'Phone',
              dataIndex: (data) => data.phone,
              width: 150,
            ),
            TableColumn(
              title: 'Department',
              dataIndex: (data) => data.department,
              width: 120,
            ),
            TableColumn(
              title: 'Salary',
              dataIndex: (data) => data.salary,
              width: 100,
              align: TextAlign.right,
            ),
            TableColumn(
              title: 'Address',
              dataIndex: (data) => data.address,
              width: 300,
            ),
            TableColumn(
              title: 'Action',
              dataIndex: (data) => '',
              width: 150,
              render: (data, index) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => $message.info(message: 'Edit ${data.name}'),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        $message.warning(message: 'Delete ${data.name}'),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ],
          dataSource: _scrollData,
          onRow: (record, index) {
            $message.success(message: 'Clicked row: ${record.name}');
          },
        ),
      ],
    );
  }
}

class ScrollableData {
  final String key;
  final String name;
  final int age;
  final String address;
  final String email;
  final String phone;
  final String department;
  final String salary;

  const ScrollableData({
    required this.key,
    required this.name,
    required this.age,
    required this.address,
    required this.email,
    required this.phone,
    required this.department,
    required this.salary,
  });
}
