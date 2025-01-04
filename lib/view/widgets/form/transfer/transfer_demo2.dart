import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '禁用条目选项',
  desc:
      '数据中 TransferItem#disabled 可以控制条目是否可用。',
)
class TransferDemo2 extends StatefulWidget {
  const TransferDemo2({super.key});

  @override
  State<TransferDemo2> createState() => _TransferDemo2State();
}

class _TransferDemo2State extends State<TransferDemo2> {
  List<TransferItem> data =
      List.generate(20, (index) => TransferItem(key: '$index', title: 'content#$index',disabled: index % 3 < 1));
  List<String> targetKeys = [];
  List<String> selectedKeys = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 480,
        height: 260,
        child: TolyTransfer(
          onSelectChange: _onSelectChange,
          dataSource: data,
          targetKeys: targetKeys,
          selectedKeys: selectedKeys,
          onChange: _onChange,
        ));
  }

  void _onSelectChange(List<String> keys) {
    for(String key in keys){
      if (selectedKeys.contains(key)) {
        selectedKeys.remove(key);
      } else {
        selectedKeys.add(key);
      }
    }
    setState(() {});
  }

  void _onChange(List<String> removeKeys, TransferAction action) {
    switch (action) {
      case TransferAction.toTarget:
        targetKeys.addAll(removeKeys);
        selectedKeys.removeWhere(removeKeys.contains);
        break;
      case TransferAction.toSource:
        targetKeys.removeWhere(removeKeys.contains);
        selectedKeys.removeWhere(removeKeys.contains);
    }
    setState(() {});
  }
}
