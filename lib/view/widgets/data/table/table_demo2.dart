import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_table/toly_table.dart';

@DisplayNode(
  title: '带边框表格',
  desc: '展示带有边框的表格样式，并支持自定义表头和表尾。通过 bordered 属性添加完整的表格边框，title 和 footer 参数可以设置表格的标题和底部信息，适用于需要明确区分数据区域的场景。',
)
class TableDemo2 extends StatelessWidget {
  const TableDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTable<MoneyData>(
      bordered: true,
      title: const Text('Header'),
      footer: const Text('Footer'),
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
          title: 'Cash Assets',
          dataIndex: (data) => data.money,
          align: TextAlign.right,
        ),
        TableColumn(
          title: 'Address',
          dataIndex: (data) => data.address,
        ),
      ],
      dataSource: const [
        MoneyData(
          key: '1',
          name: 'John Brown',
          money: '￥300,000.00',
          address: 'New York No. 1 Lake Park',
        ),
        MoneyData(
          key: '2',
          name: 'Jim Green',
          money: '￥1,256,000.00',
          address: 'London No. 1 Lake Park',
        ),
        MoneyData(
          key: '3',
          name: 'Joe Black',
          money: '￥120,000.00',
          address: 'Sydney No. 1 Lake Park',
        ),
      ],
    );
  }
}

class MoneyData {
  final String key;
  final String name;
  final String money;
  final String address;

  const MoneyData({
    required this.key,
    required this.name,
    required this.money,
    required this.address,
  });
}
