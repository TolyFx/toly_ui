import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';

@DisplayNode(
  title: '可选择表格',
  desc: '展示支持行选择功能的表格。支持复选框和单选框两种选择模式，可以通过切换按钮改变选择类型。选中的行会高亮显示，支持全选和单选操作，并提供选择状态的回调处理。',
)
class TableDemo4 extends StatefulWidget {
  const TableDemo4({super.key});

  @override
  State<TableDemo4> createState() => _TableDemo4State();
}

class _TableDemo4State extends State<TableDemo4> {
  RowSelectionType _selectionType = RowSelectionType.checkbox;
  List<int> _selectedKeys = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<RowSelectionType>(
              value: RowSelectionType.checkbox,
              groupValue: _selectionType,
              onChanged: (value) => setState(() => _selectionType = value!),
            ),
            const Text('Checkbox'),
            const SizedBox(width: 16),
            Radio<RowSelectionType>(
              value: RowSelectionType.radio,
              groupValue: _selectionType,
              onChanged: (value) => setState(() => _selectionType = value!),
            ),
            const Text('Radio'),
          ],
        ),
        const SizedBox(height: 16),
        TolyTable<SelectableData>(
          rowSelection: TableRowSelection<SelectableData>(
            type: _selectionType,
            onChange: (selectedRowKeys, selectedRows) {
              setState(() => _selectedKeys = selectedRowKeys);
              debugPrint('selectedRowKeys: $selectedRowKeys');
              debugPrint('selectedRows: ${selectedRows.map((e) => e.name).toList()}');
            },
            getCheckboxProps: (record) => CheckboxProps(
              disabled: record.name == 'Disabled User',
              name: record.name,
            ),
          ),
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
          ],
          dataSource: const [
            SelectableData(
              key: '1',
              name: 'John Brown',
              age: 32,
              address: 'New York No. 1 Lake Park',
            ),
            SelectableData(
              key: '2',
              name: 'Jim Green',
              age: 42,
              address: 'London No. 1 Lake Park',
            ),
            SelectableData(
              key: '3',
              name: 'Joe Black',
              age: 32,
              address: 'Sydney No. 1 Lake Park',
            ),
            SelectableData(
              key: '4',
              name: 'Disabled User',
              age: 99,
              address: 'Sydney No. 1 Lake Park',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('已选择: ${_selectedKeys.length} 项'),
      ],
    );
  }
}

class SelectableData {
  final String key;
  final String name;
  final int age;
  final String address;

  const SelectableData({
    required this.key,
    required this.name,
    required this.age,
    required this.address,
  });
}