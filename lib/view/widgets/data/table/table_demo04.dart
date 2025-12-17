import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';

@DisplayNode(
  title: '可选择表格',
  desc: '展示支持行选择功能的表格。通过 PickStrategy 配置单选或多选模式，选中的行会高亮显示。支持全选操作和选择状态回调，可以实时获取选中的行索引，适用于需要批量操作的数据管理场景。',
)
class TableDemo4 extends StatefulWidget {
  const TableDemo4({super.key});

  @override
  State<TableDemo4> createState() => _TableDemo4State();
}

class _TableDemo4State extends State<TableDemo4> {
  PickMode _pickMode = PickMode.multiple;
  Set<int> _selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sourceData = const [
      {
        'key': '1',
        'name': 'John Brown',
        'age': 32,
        'address': 'New York No. 1 Lake Park',
      },
      {
        'key': '2',
        'name': 'Jim Green',
        'age': 42,
        'address': 'London No. 1 Lake Park',
      },
      {
        'key': '3',
        'name': 'Joe Black',
        'age': 32,
        'address': 'Sydney No. 1 Lake Park',
      },
      {
        'key': '4',
        'name': 'Disabled User',
        'age': 99,
        'address': 'Sydney No. 1 Lake Park',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<PickMode>(
              value: PickMode.multiple,
              groupValue: _pickMode,
              onChanged: (value) => setState(() {
                _pickMode = value!;
                _selectedIndices.clear();
              }),
            ),
            const Text('多选'),
            const SizedBox(width: 16),
            Radio<PickMode>(
              value: PickMode.single,
              groupValue: _pickMode,
              onChanged: (value) => setState(() {
                _pickMode = value!;
                _selectedIndices.clear();
              }),
            ),
            const Text('单选'),
          ],
        ),
        const SizedBox(height: 16),
        TolyTable<_SelectableData>.source(
          data: sourceData,
          converter: _SelectableData.fromMap,
          fields: [
            FieldSpec<_SelectableData>(
              key: 'name',
              header: const FieldHeader(title: 'Name'),
              builder: (ctx) => Text(
                ctx.data.name,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            FieldSpec<_SelectableData>(
              key: 'age',
              header: const FieldHeader(title: 'Age'),
              builder: (ctx) => Text('${ctx.data.age}'),
            ),
            FieldSpec<_SelectableData>(
              key: 'address',
              header: const FieldHeader(title: 'Address'),
              builder: (ctx) => Text(ctx.data.address),
            ),
          ],
          behavior: SheetBehavior(
            pickStrategy: PickStrategy(
              mode: _pickMode,
              onChanged: (indices) {
                setState(() => _selectedIndices = indices);
              },
            ),
          ),
          appearance: const SheetAppearance(
            showBorder: true,
          ),
        ),
        const SizedBox(height: 16),
        Text('已选择: ${_selectedIndices.length} 项'),
      ],
    );
  }
}

class _SelectableData {
  final String key;
  final String name;
  final int age;
  final String address;

  const _SelectableData({
    required this.key,
    required this.name,
    required this.age,
    required this.address,
  });

  factory _SelectableData.fromMap(Map<String, dynamic> map) {
    return _SelectableData(
      key: map['key'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      address: map['address'] as String,
    );
  }
}
