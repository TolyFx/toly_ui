import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '分页表格',
  desc: '展示支持分页功能的表格。当数据量较大时，通过分页控件将数据分批展示，提升页面性能和用户体验。支持页码切换和页面大小配置，底部显示总数据量和当前页码信息。',
)
class TableDemo5 extends StatefulWidget {
  const TableDemo5({super.key});

  @override
  State<TableDemo5> createState() => _TableDemo5State();
}

class _TableDemo5State extends State<TableDemo5> {
  int _currentPage = 1;
  final int _pageSize = 5;

  // 生成大量测试数据
  List<PaginationData> get _allData => List.generate(
        23,
        (index) => PaginationData(
          key: '${index + 1}',
          name: 'User ${index + 1}',
          age: 20 + (index % 50),
          address: 'Address ${index + 1}',
          tags: _generateTags(index),
        ),
      );

  List<String> _generateTags(int index) {
    final allTags = ['developer', 'designer', 'manager', 'tester', 'analyst', 'architect'];
    final count = (index % 3) + 1;
    return allTags.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TolyTable<PaginationData>(
      columns: [
        TableColumn(
          title: 'Name',
          dataIndex: (data) => data.name,
          render: (data, index) => Text(
            data.name,
            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
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
            spacing: 4,
            runSpacing: 4,
            children: data.tags.map((tag) {
              Color color = tag.length > 5 ? Colors.blue : Colors.green;
              return TolyTag(color: color, child: Text(tag));
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
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => $message.warning(message: 'Delete ${data.name}'),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ],
      dataSource: _allData,
      pagination: TablePagination(
        pageSize: _pageSize,
        current: _currentPage,
        total: _allData.length,
        onChange: (page, pageSize) {
          setState(() => _currentPage = page);
          debugPrint('Page changed to: $page, pageSize: $pageSize');
        },
      ),
    );
  }
}

class PaginationData {
  final String key;
  final String name;
  final int age;
  final String address;
  final List<String> tags;

  const PaginationData({
    required this.key,
    required this.name,
    required this.age,
    required this.address,
    required this.tags,
  });
}