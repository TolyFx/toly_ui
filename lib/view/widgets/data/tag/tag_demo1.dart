import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../incubator/components/data/tag/tag.dart';

class TagDemo1 extends StatelessWidget {
  const TagDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style2 = TextStyle(color: Color(0xff72c749), fontWeight: FontWeight.bold);
    return Wrap(
      spacing: 10,
      children: [
        TolyTag(
          tagStyle: style2,
        ),
        TolyTag(
          tagText: "正常",
          tagColor: Colors.green.withOpacity(0.4),
        ),
        TolyTag(
          tagText: "紧急",
          tagColor: Colors.red.withOpacity(0.6),
          close: () {},
        ),
      ],
    );
  }
}
