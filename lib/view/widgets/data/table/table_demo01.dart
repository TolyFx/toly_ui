import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '基础表格',
  desc: '展示表格的基础用法。包含姓名、年龄、地址、标签和操作列，最后一列提供交互操作。通过简洁的列定义和数据源配置，快速构建功能完整的数据表格。',
)
class TableDemo1 extends StatelessWidget {
  const TableDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTable<_UserData>(
      columns: [
        TableColumn(
          title: 'Name',
          dataIndex: (data) => data.name,
          render: (data, index) => Text(
            data.name,
            style: const TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
        TableColumn(
          title: 'Age',
          dataIndex: (data) => data.age,
        ),
        TableColumn(
          title: 'Address',
          dataIndex: (data) => data.address,
        ),
        TableColumn(
          title: 'Tags',
          dataIndex: (data) => data.tags,
          render: (data, index) => Wrap(
            spacing: 8,
            runSpacing: 4,
            children: data.tags.map((tag) {
              Color color = tag.length > 5 ? Colors.blue : Colors.green;
              if (tag == 'loser') color = Colors.red;
              return TolyTag(color: color, child: Text(tag.toUpperCase()));
            }).toList(),
          ),
        ),
        TableColumn(
          title: 'Action',
          dataIndex: (data) => '',
          render: (data, index) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => $message.info(message: 'Invite ${data.name}'),
                child: const Text(
                  'Invite',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => $message.warning(message: 'Delete ${data.name}'),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ],
      dataSource: const [
        _UserData(
          key: '1',
          name: 'John Brown',
          age: 32,
          address: 'New York No. 1 Lake Park',
          tags: ['nice', 'developer'],
        ),
        _UserData(
          key: '2',
          name: 'Jim Green',
          age: 42,
          address: 'London No. 1 Lake Park',
          tags: ['loser'],
        ),
        _UserData(
          key: '3',
          name: 'Joe Black',
          age: 32,
          address: 'Sydney No. 1 Lake Park',
          tags: ['cool', 'teacher'],
        ),
      ],
    );
  }
}

class _UserData {
  final String key;
  final String name;
  final int age;
  final String address;
  final List<String> tags;

  const _UserData({
    required this.key,
    required this.name,
    required this.age,
    required this.address,
    required this.tags,
  });
}
