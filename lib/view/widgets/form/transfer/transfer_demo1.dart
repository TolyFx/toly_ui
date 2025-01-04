import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'Transfer 基本使用',
  desc:
      '【dataSource】 : 数据源   【List<TransferItem>】\n【targetKeys】 : 右框数据的 key 集合 【List<String>】\n【selectedKeys】 : 选中项 key 集合   【List<String>】\n【onSelectChange】 : 选中回调   【OnSelectChange】\n【onChange】 : 数据转移时回调   【OnTransferChange】',
)
class TransferDemo1 extends StatefulWidget {
  const TransferDemo1({super.key});

  @override
  State<TransferDemo1> createState() => _TransferDemo1State();
}

class _TransferDemo1State extends State<TransferDemo1> {
  List<TransferItem> data =
      List.generate(20, (index) => TransferItem(key: '$index', title: 'content#$index'));
  List<String> targetKeys = List.generate(10, (i) => '${10 + i}');
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
