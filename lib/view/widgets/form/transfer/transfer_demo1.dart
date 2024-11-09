import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/form/transfer/toly_transfer.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'Transfer 基本使用',
  desc:
      '【optionsBuilder】 : 选项构造器   【AutocompleteOptionsBuilder<T>】\n【fieldViewBuilder】 : 选择时回调 【AutocompleteFieldViewBuilder】\n【onSelected】 : 选择时回调   【ValueChanged<T>】',
)
class TransferDemo1 extends StatelessWidget {
  const TransferDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
            width: 480,
            height: 260,
            child: TolyTransfer(
              dataSource: [
                ...List.generate(
                    20, (index) => TransferItem(key: '$index', title: 'content#$index'))
              ],
              targetKeys: List.generate(10,(i) =>'$i'),
              selectedKeys: List.generate(10,(i) =>'${i+10}'),
            )),
      ],
    );
  }
}
