import 'package:flutter/material.dart';
import 'package:toly_ui/app/logic/actions/navigation.dart';
import 'package:toly_ui/app/res/toly_icon.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '基础表格',
  desc: '展示表格的基础用法。以 TolyUI 组件库为例，通过 FieldSpec 定义列结构，使用 source 构造器快速绑定数据源。支持自定义单元格渲染，可以嵌入链接、标签、图标等复杂组件，满足多样化的数据展示需求。',
)
class TableDemo1 extends StatelessWidget {
  const TableDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sourceData = const [
      {
        'key': '1',
        'name': 'toly_tree',
        'type': '数据展示',
        'status': 1,
        'tags': ['树', '常用'],
        'desc': '完善的树形视图模块',
      },
      {
        'key': '2',
        'name': 'tolyui_feedback',
        'type': '交互反馈',
        'status': 1,
        'tags': ['交互', '提示'],
        'desc': '用户交互反馈核模块',
      },
      {
        'key': '3',
        'name': 'tolyui_table',
        'type': '数据展示',
        'status': 0,
        'tags': ['表格', '复杂'],
        'desc': '强大的数据表格模块',
      },
      {
        'key': '4',
        'name': 'tolyui_navigation',
        'type': '导航模块',
        'status': 1,
        'tags': ['导航', '菜单'],
        'desc': '强大的锚点导航模块',
      },
    ];

    return TolyTable<_Component>.source(
      data: sourceData,
      converter: _Component.fromMap,
      fields: _buildFields(),
    );
  }

  List<FieldSpec<_Component>> _buildFields() => [
        FieldSpec(
          key: 'name',
          header: const FieldHeader(title: '模块名'),
          builder: (ctx) =>
              _NameCell(name: ctx.data.name, status: ctx.data.status),
        ),
        FieldSpec(
          key: 'type',
          header: const FieldHeader(title: '类型'),
          builder: (ctx) => Text(ctx.data.type),
        ),
        FieldSpec(
          key: 'desc',
          header: const FieldHeader(title: '描述'),
          builder: (ctx) => Text(
            ctx.data.desc,
          ),
        ),
        FieldSpec(
          key: 'tags',
          header: const FieldHeader(title: '标签'),
          builder: (ctx) => Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ctx.data.tags.map((tag) {
              return TolyTag(
                color: Colors.blue,
                variant: TagVariant.outlined,
                child: Text(tag),
              );
            }).toList(),
          ),
        ),
        FieldSpec(
          key: 'action',
          header: const FieldHeader(title: '操作'),
          builder: (ctx) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => $message.info(message: '查看 ${ctx.data.name}'),
                child: Icon(
                  TolyIcon.iconGithub,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => $message.success(message: '复制 ${ctx.data.name}'),
                child: const Text(
                  '复制',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ];
}

class _NameCell extends StatelessWidget {
  final String name;
  final int status;

  const _NameCell({super.key, required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      shape: BoxShape.circle,
      color: status == 1 ? Colors.green : Colors.orange,
    );
    const TextStyle linkStyle = TextStyle(color: Colors.blue);
    String href = 'https://pub.dev/packages/$name';
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TolyTooltip(
          placement: Placement.top,
          message: status == 1 ? '已发布' : '开发中',
          child: Container(width: 8, height: 8, decoration: decoration),
        ),
        const SizedBox(width: 8),
        TolyLink(text: name, href: href, style: linkStyle, onTap: jumpUrl),
      ],
    );
  }
}

class _Component {
  final String key;
  final String name;
  final String type;
  final int status;
  final List<String> tags;
  final String desc;

  const _Component({
    required this.key,
    required this.name,
    required this.type,
    required this.status,
    required this.tags,
    required this.desc,
  });

  factory _Component.fromMap(Map<String, dynamic> map) {
    return _Component(
      key: map['key'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      status: map['status'] as int,
      tags: (map['tags'] as List).cast<String>(),
      desc: map['desc'] as String,
    );
  }
}
