import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';

@DisplayNode(
  title: 'TolySheet 三级表头',
  desc:
      '展示 TolySheet 的三级表头合并功能。通过多层嵌套的 FieldSpec 定义三级表头结构，支持任意层级的表头合并。适用于复杂的数据分类展示场景，如学生成绩单、多维度数据分析等。',
)
class TableDemo12 extends StatefulWidget {
  const TableDemo12({super.key});

  @override
  State<TableDemo12> createState() => _TableDemo12State();
}

class _TableDemo12State extends State<TableDemo12> {
  final List<StudentData> _students = [
    StudentData(
      name: '张三',
      chinese: 85,
      math: 92,
      english: 88,
      physics: 90,
      chemistry: 87,
      biology: 89,
      politics: 86,
      history: 91,
      geography: 88,
    ),
    StudentData(
      name: '李四',
      chinese: 92,
      math: 88,
      english: 90,
      physics: 85,
      chemistry: 89,
      biology: 87,
      politics: 90,
      history: 88,
      geography: 92,
    ),
    StudentData(
      name: '王五',
      chinese: 88,
      math: 95,
      english: 86,
      physics: 92,
      chemistry: 90,
      biology: 88,
      politics: 85,
      history: 87,
      geography: 89,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TolyTable<StudentData>(
        provider: LocalSheetProvider(data: _students),
        fields: [
          FieldSpec<StudentData>(
            key: 'name',
            header: const FieldHeader(title: '姓名'),
            builder: (ctx) => Text(
              ctx.data.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          FieldSpec<StudentData>(
            key: 'scores',
            header: const FieldHeader(title: '成绩'),
            children: [
              FieldSpec<StudentData>(
                key: 'language',
                header: const FieldHeader(title: '语言类'),
                children: [
                  FieldSpec<StudentData>(
                    key: 'chinese',
                    header: const FieldHeader(title: '语文'),
                    builder: (ctx) => Text(
                      '${ctx.data.chinese}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.chinese),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FieldSpec<StudentData>(
                    key: 'english',
                    header: const FieldHeader(title: '英语'),
                    builder: (ctx) => Text(
                      '${ctx.data.english}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.english),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              FieldSpec<StudentData>(
                key: 'science',
                header: const FieldHeader(title: '理科类'),
                children: [
                  FieldSpec<StudentData>(
                    key: 'math',
                    header: const FieldHeader(title: '数学'),
                    builder: (ctx) => Text(
                      '${ctx.data.math}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.math),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FieldSpec<StudentData>(
                    key: 'physics',
                    header: const FieldHeader(title: '物理'),
                    builder: (ctx) => Text(
                      '${ctx.data.physics}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.physics),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FieldSpec<StudentData>(
                    key: 'chemistry',
                    header: const FieldHeader(title: '化学'),
                    builder: (ctx) => Text(
                      '${ctx.data.chemistry}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.chemistry),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FieldSpec<StudentData>(
                    key: 'biology',
                    header: const FieldHeader(title: '生物'),
                    builder: (ctx) => Text(
                      '${ctx.data.biology}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.biology),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              FieldSpec<StudentData>(
                key: 'liberal',
                header: const FieldHeader(title: '文科类'),
                children: [
                  FieldSpec<StudentData>(
                    key: 'politics',
                    header: const FieldHeader(title: '政治'),
                    builder: (ctx) => Text(
                      '${ctx.data.politics}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.politics),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FieldSpec<StudentData>(
                    key: 'history',
                    header: const FieldHeader(title: '历史'),
                    builder: (ctx) => Text(
                      '${ctx.data.history}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.history),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FieldSpec<StudentData>(
                    key: 'geography',
                    header: const FieldHeader(title: '地理'),
                    builder: (ctx) => Text(
                      '${ctx.data.geography}',
                      style: TextStyle(
                        color: _getScoreColor(ctx.data.geography),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          FieldSpec<StudentData>(
            key: 'total',
            header: const FieldHeader(title: '总分'),
            builder: (ctx) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTotalScoreColor(ctx.data.totalScore),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${ctx.data.totalScore}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        appearance: const SheetAppearance(
          layoutMode: LayoutMode.fixed,
          showBorder: true,
          rowHeight: 48,
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getTotalScoreColor(int total) {
    if (total >= 810) return Colors.green;
    if (total >= 720) return Colors.blue;
    if (total >= 540) return Colors.orange;
    return Colors.red;
  }
}

class StudentData {
  final String name;
  final int chinese;
  final int math;
  final int english;
  final int physics;
  final int chemistry;
  final int biology;
  final int politics;
  final int history;
  final int geography;

  StudentData({
    required this.name,
    required this.chinese,
    required this.math,
    required this.english,
    required this.physics,
    required this.chemistry,
    required this.biology,
    required this.politics,
    required this.history,
    required this.geography,
  });

  int get totalScore =>
      chinese +
      math +
      english +
      physics +
      chemistry +
      biology +
      politics +
      history +
      geography;
}
