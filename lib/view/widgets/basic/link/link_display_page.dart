import 'package:flutter/material.dart';
import 'package:toly_ui/components/node_display.dart';
import 'package:toly_ui/view/widgets/basic/link/display_nodes.dart';
import 'link_demo1.dart';
import 'link_demo2.dart';
import 'link_demo3.dart';

class LinkDisplayPage extends StatelessWidget {
  const LinkDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, index) {
          return NodeDisplay(
            display: _queryDisplay(keys[index]),
            node: Node.fromMap(data[index]),
          );
        },
        itemCount: displayNodes.length,
      ),
    );
  }

  Widget _queryDisplay(String key) {
    if (key == 'LinkDemo1') return const LinkDemo1();
    if (key == 'LinkDemo2') return const LinkDemo2();
    if (key == 'LinkDemo3') return const LinkDemo3();
    return const SizedBox();
  }
}
