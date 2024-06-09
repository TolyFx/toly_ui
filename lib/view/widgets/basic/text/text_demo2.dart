import 'package:flutter/material.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '可选择文字',
  desc:'可选择文字的展示基于 Flutter 框架内置的 SelectionArea、SelectableRegion、SelectionContainer、SelectableText等组件实现 。',
)
class TextDemo2 extends StatelessWidget {
  const TextDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    const String info = 'TolyUI 是张风捷特烈打造的 Flutter 全平台应用开发 UI 框架。具备全平台、组件化、源码开放、响应式四大特点。提供大量 Flutter 框架内部之外的常用组件，帮助开发者迅速构建具有响应式的全平台应用软件。';
    return SelectionArea(
      selectionControls: DesktopTextSelectionControls(),
      focusNode: FocusNode(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('介绍',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
          ),
          Text(info,style:  TextStyle(color: Color(0xff606266)),),
        ],
      ),
    );
  }
}
