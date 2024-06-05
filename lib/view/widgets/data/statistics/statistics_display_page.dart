import 'package:flutter/material.dart';
import 'package:toly_ui/components/node_display.dart';
import 'display_nodes.dart';
import '../../widget_display_map.dart';

class StatisticsDisplayPage extends StatelessWidget {
  const StatisticsDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, index) {
          return NodeDisplay(
            display: widgetDisplayMap(keys[index]),
            node: Node.fromMap(data[index]),
          );
        },
        itemCount: displayNodes.length,
      ),
    );
  }

}
