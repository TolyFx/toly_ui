import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'TolyAutocomplete 基本使用',
  desc:
      '【optionsBuilder】 : 选项构造器   【AutocompleteOptionsBuilder<T>】\n【fieldViewBuilder】 : 选择时回调 【AutocompleteFieldViewBuilder】\n【onSelected】 : 选择时回调   【ValueChanged<T>】',
)
class AutocompleteDemo1 extends StatelessWidget {
  const AutocompleteDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
            width: 240,
            child: TolyAutocomplete<String>(
              optionsBuilder: buildOptions,
              fieldViewBuilder: _fieldViewBuilder,
              onSelected: _onSelected,
            )),
      ],
    );
  }

  void _onSelected(String value) {
    $message.success(message: '当前选择了 $value');
  }

  Future<Iterable<String>> buildOptions(
    TextEditingValue textEditingValue,
  ) async {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    }
    return searchByArgs(textEditingValue.text);
  }

  Future<Iterable<String>> searchByArgs(String args) async {
    // 模拟网络请求
    await Future.delayed(const Duration(milliseconds: 200));
    List<String> data = [args, args * 2, args * 3];
    return data.where((String name) => name.contains(args));
  }

  Widget _fieldViewBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    return TolyInput(
      focusNode: focusNode,
      controller: textEditingController,
      hintText: 'input here',
    );
  }
}
