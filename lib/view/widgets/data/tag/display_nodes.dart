Map<String, dynamic> get displayNodes => {
      'TagDemo1': {
        'title': '基础用法',
        'desc': '基础的tag用法。',
        'code': """class TagDemo1 extends StatelessWidget {
  const TagDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style2 = TextStyle(color: Color(0xff72c749), fontWeight: FontWeight.bold);
    return const Wrap(
      spacing: 10,
      children: [
        TolyTag(
          tagStyle: style2,
        ),
        TolyTag(
          tagText: "正常",
          tagColor: Colors.green,
        ),
        TolyTag(
          tagText: "紧急",
          tagColor: Colors.red,
        ),
      ],
    );
  }
}
"""
      },
      'TagDemo2': {
        'title': '可删除状态',
        'desc': '使用 close方法。',
        'code': """class TagDemo2 extends StatelessWidget {
  const TagDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    List<TagModel> tags = [
      TagModel("上进", Colors.greenAccent),
      TagModel("努力", Colors.greenAccent),
      TagModel("成功", Colors.deepOrange)
    ];
    return Wrap(
      spacing: 10,
      children: [
        ...List.generate(tags.length, (i) {
          return TolyTag(
            tagText: tags[i].title,
            tagStyle: TextStyle(color: tags[i].color),
            close: () {
              tags.removeAt(i);
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
"""
      },
      'TagDemo3': {
        'title': '高级用法',
        'desc': '自定义Tag样式',
        'code': """class TagDemo3 extends StatelessWidget {
  const TagDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(color: Colors.white, fontSize: 12);
    return Wrap(
      spacing: 10,
      children: [
        TolyTag(
          radius: 15,
          tagText: "喜欢",
          tagBgColor: Colors.cyanAccent,
          tagStyle: style,
        ),
        TolyTag(
          radius: 15,
          tagText: "讨厌",
          tagBgColor: Colors.deepPurpleAccent,
          tagStyle: style,
        ),
        TolyTag(
          radius: 15,
          tagText: "依恋",
          tagBgColor: Colors.green,
          tagStyle: style,
        ),
      ],
    );
  }
"""
      }
    };
