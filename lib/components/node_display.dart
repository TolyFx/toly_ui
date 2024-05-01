import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

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

  factory Node.fromMap(dynamic map) {
    return Node(title: map['title'], desc: map['desc'], code: map['code']);
  }
}

class NodeDisplay extends StatelessWidget {
  final Widget display;
  final Node node;

  const NodeDisplay({super.key, required this.display, required this.node});

  @override
  Widget build(BuildContext context) {

    return  Padding$(
        padding: (re)=>switch (re) {
      Rx.xs => const EdgeInsets.symmetric(horizontal: 18.0),
      Rx.sm => const EdgeInsets.symmetric(horizontal: 24.0),
      Rx.md => const EdgeInsets.symmetric(horizontal: 32.0),
      Rx.lg => const EdgeInsets.symmetric(horizontal: 48.0),
      Rx.xl => const EdgeInsets.symmetric(horizontal: 64.0),
    },
    child: Column(
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

    ));
  }
}

class TitleShow extends StatelessWidget {
  final String title;
  final String desc;

  const TitleShow({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
