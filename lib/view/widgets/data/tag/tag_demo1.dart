import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../incubator/components/data/tag/tag.dart';

class TagDemo1 extends StatelessWidget {
  const TagDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing:20,
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
