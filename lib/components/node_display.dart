import 'package:flutter/material.dart';

import 'code_display.dart';

class Node {
  final String title;
  final String desc;
  final String code;

  const Node({
    required this.title,
    required this.desc,
    required this.code,
  });

  factory Node.fromMap(dynamic map){
    return Node(title: map['title'], desc: map['desc'], code: map['code']);
  }
}

class NodeDisplay extends StatelessWidget {
  final Widget display;
  final Node node;

  const NodeDisplay({super.key, required this.display, required this.node});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleShow(
          title: node.title,
          desc: node.desc,
        ),
        CodeDisplay(
          display: display,
          code: node.code,
        ),
      ],
    );
  }
}

class TitleShow extends StatelessWidget {
  final String title;
  final String desc;

  const TitleShow({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
