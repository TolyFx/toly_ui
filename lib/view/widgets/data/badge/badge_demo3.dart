import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'Badge 的偏移量',
  desc: 'offset 设置标记偏移量，类型为 Offset；alignment 设置标题对齐方式，类型为 AlignmentDirectional',
)
class BadgeDemo3 extends StatelessWidget {
  const BadgeDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> info = ['默认偏移和对齐', '偏移-4,-4', '偏移-2,-2;右下角'];
    final List<Offset?> offsets = [null, const Offset(-4, -2), const Offset(-2, -2)];
    final List<Alignment?> alignments = [null, null, Alignment.bottomRight];

    return Wrap(
      spacing: 40,
      children: info
          .asMap()
          .keys
          .map((int i) => _buildShowItem(info[i], offsets[i], alignments[i]))
          .toList(),
    );
  }

  Widget _buildShowItem(String info, Offset? offset, Alignment? alignment) {
    return Wrap(
      spacing: 8,
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Badge(
          backgroundColor: Colors.red,
          label: const Text(
            '99',
            style: TextStyle(height: 1),
          ),
          textStyle: const TextStyle(fontSize: 8, color: Colors.red),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          largeSize: 14,
          offset: offset,
          alignment: alignment,
          child: const Icon(CupertinoIcons.mail, size: 36, color: Colors.indigo),
        ),
        Text(
          info,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        )
      ],
    );
  }
}
