import 'package:flutter/material.dart';
import 'package:toly_ui/incubator/components/data/tag/tag.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '可删除状态',
  desc: '使用 close 方法',
)
class TagDemo2 extends StatefulWidget {
  const TagDemo2({super.key});

  @override
  State<TagDemo2> createState() => _TagDemo2State();
}

class _TagDemo2State extends State<TagDemo2> {
  List<TagModel> tags = [
    TagModel("上进", Colors.deepPurpleAccent),
    TagModel("努力", Colors.greenAccent),
    TagModel("成功", Colors.deepOrange)
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        ...List.generate(tags.length, (i) {
          return TolyTag(
            tagText: tags[i].title,
            tagStyle: TextStyle(color: tags[i].color),
            close: () {
              tags.removeAt(i);
              setState(() {});
            },
          );
        })
      ],
    );
  }
}

class TagModel {
  String title;
  Color color;

  TagModel(this.title, this.color);
}
