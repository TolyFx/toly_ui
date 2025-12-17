import 'package:flutter/material.dart';
import 'package:toly_ui/app/logic/actions/navigation.dart';
import 'package:toly_ui/app/res/toly_icon.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '外观配置表格',
  desc: '展示表格的外观配置能力。通过 SheetAppearance 可以控制边框、行线、列线、条纹和行高等外观属性。支持 headerActions 和 footerActions 添加表头表尾操作区，鼠标悬浮时高亮显示当前行，提供丰富的视觉反馈和交互体验。',
)
class TableDemo2 extends StatefulWidget {
  const TableDemo2({super.key});

  @override
  State<TableDemo2> createState() => _TableDemo2State();
}

class _TableDemo2State extends State<TableDemo2> {
  bool _showBorder = true;
  bool _showRowDivider = true;
  bool _showHeaderColumnDivider = true;
  bool _showBodyColumnDivider = false;
  bool _striped = false;
  double _rowHeight = 56;

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
      fields: [
        FieldSpec<_Component>(
          key: 'name',
          header: const FieldHeader(title: '模块名'),
          builder: (ctx) =>
              _NameCell(name: ctx.data.name, status: ctx.data.status),
        ),
        FieldSpec<_Component>(
          key: 'type',
          header: const FieldHeader(title: '类型'),
          builder: (ctx) => Text(ctx.data.type),
        ),
        FieldSpec<_Component>(
          key: 'desc',
          header: const FieldHeader(title: '描述'),
          builder: (ctx) => Text(ctx.data.desc),
        ),
        FieldSpec<_Component>(
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
        FieldSpec<_Component>(
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
      ],
      appearance: SheetAppearance(
        showBorder: _showBorder,
        showRowDivider: _showRowDivider,
        showHeaderColumnDivider: _showHeaderColumnDivider,
        showBodyColumnDivider: _showBodyColumnDivider,
        striped: _striped,
        rowHeight: _rowHeight,
        headerActions: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TolyUI 组件列表',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_showBorder ? Icons.border_outer : Icons.border_clear, size: 20),
                  onPressed: () => setState(() => _showBorder = !_showBorder),
                  tooltip: '切换边框',
                ),
                IconButton(
                  icon: Icon(_showRowDivider ? Icons.view_headline : Icons.view_stream, size: 20),
                  onPressed: () => setState(() => _showRowDivider = !_showRowDivider),
                  tooltip: '切换行线',
                ),
                IconButton(
                  icon: Icon(_showHeaderColumnDivider ? Icons.view_week : Icons.view_column, size: 20),
                  onPressed: () => setState(() => _showHeaderColumnDivider = !_showHeaderColumnDivider),
                  tooltip: '表头列线',
                ),
                IconButton(
                  icon: Icon(_showBodyColumnDivider ? Icons.table_chart : Icons.table_rows, size: 20),
                  onPressed: () => setState(() => _showBodyColumnDivider = !_showBodyColumnDivider),
                  tooltip: '内容列线',
                ),
                IconButton(
                  icon: Icon(_striped ? Icons.format_line_spacing : Icons.table_rows, size: 20),
                  onPressed: () => setState(() => _striped = !_striped),
                  tooltip: '切换斑马纹',
                ),
                IconButton(
                  icon: const Icon(Icons.height, size: 20),
                  onPressed: () => setState(() => _rowHeight = _rowHeight == 56 ? 48 : 56),
                  tooltip: '切换行高',
                ),
              ],
            ),
          ],
        ),
        footerActions: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '共 ${sourceData.length} 条记录',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: () {},
                ),
                const Text('1 / 1'),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
