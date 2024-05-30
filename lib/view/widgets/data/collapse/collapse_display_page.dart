import 'package:flutter/material.dart';
import 'package:toly_ui/components/node_display.dart';
import 'package:toly_ui/view/home_page/link_panel.dart';

import '../../../home_page/cooperation_panel.dart';
import '../../widget_display_map.dart';
import 'display_nodes.dart';

class CollapseDisplayPage extends StatelessWidget {
  const CollapseDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, index) {
          if (index == displayNodes.length) {
            return CooperationPanel(
              padding: EdgeInsets.symmetric(vertical: 46),
            );
          }
          if (index == displayNodes.length + 1) {
            return Divider();
          }
          if (index == displayNodes.length + 2) {
            return LinkPanel();
          }
          return NodeDisplay(
            display: widgetDisplayMap(keys[index]),
            node: Node.fromMap(data[index]),
          );
        },
        itemCount: displayNodes.length + 3,
      ),
    );
  }
}
