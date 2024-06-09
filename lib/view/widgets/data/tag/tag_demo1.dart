import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

import '../../../../incubator/components/data/tag/tag.dart';

@DisplayNode(
  title: '基础用法',
  desc: '基础的tag用法',
)
class TagDemo1 extends StatelessWidget {
  const TagDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 20,
      children: [
        TolyTag(
          tagBgColor: Colors.transparent,
        ),
        TolyTag(
          tagText: "正常",
          tagStyle: TextStyle(color: Colors.cyan),
        ),
        TolyTag(
          tagText: "紧急",
          tagStyle: TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
