import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';

@DisplayNode(
  title: 'TolySheet 合并表头',
  desc: '展示 TolySheet 的合并表头功能。通过嵌套的 FieldSpec 定义多级表头结构，支持任意层级的表头合并。适用于复杂数据结构的展示场景，如个人信息、联系方式、工作信息等分组展示。',
)
class TableDemo10 extends StatefulWidget {
  const TableDemo10({super.key});

  @override
  State<TableDemo10> createState() => _TableDemo10State();
}

class _TableDemo10State extends State<TableDemo10> {
  final List<EmployeeData> _employees = [
    EmployeeData(
      name: '张三',
      age: 32,
      gender: '男',
      phone: '138-0000-0001',
      email: 'zhangsan@company.com',
      department: '技术部',
      position: '高级工程师',
      salary: 25000,
    ),
    EmployeeData(
      name: '李四',
      age: 28,
      gender: '女',
      phone: '138-0000-0002',
      email: 'lisi@company.com',
      department: '设计部',
      position: 'UI设计师',
      salary: 18000,
    ),
    EmployeeData(
      name: '王五',
      age: 35,
      gender: '男',
      phone: '138-0000-0003',
      email: 'wangwu@company.com',
      department: '市场部',
      position: '市场经理',
      salary: 22000,
    ),
    EmployeeData(
      name: '赵六',
      age: 29,
      gender: '女',
      phone: '138-0000-0004',
      email: 'zhaoliu@company.com',
      department: '人事部',
      position: '人事专员',
      salary: 15000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TolySheet<EmployeeData>(
        provider: LocalSheetProvider(data: _employees),
        fields: [
          FieldSpec<EmployeeData>(
            key: 'name',
            header: const FieldHeader(title: '姓名'),
            builder: (ctx) => Text(
              ctx.data.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          FieldSpec<EmployeeData>(
            key: 'personal',
            header: const FieldHeader(title: '个人信息'),
            children: [
              FieldSpec<EmployeeData>(
                key: 'age',
                header: const FieldHeader(title: '年龄'),
                builder: (ctx) => Text('${ctx.data.age}'),
              ),
              FieldSpec<EmployeeData>(
                key: 'gender',
                header: const FieldHeader(title: '性别'),
                builder: (ctx) => Text(ctx.data.gender),
              ),
            ],
          ),
          FieldSpec<EmployeeData>(
            key: 'contact',
            header: const FieldHeader(title: '联系方式'),
            children: [
              FieldSpec<EmployeeData>(
                key: 'phone',
                header: const FieldHeader(title: '电话'),
                builder: (ctx) => Text(ctx.data.phone),
              ),
              FieldSpec<EmployeeData>(
                key: 'email',
                header: const FieldHeader(title: '邮箱'),
                builder: (ctx) => Text(
                  ctx.data.email,
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ],
          ),
          FieldSpec<EmployeeData>(
            key: 'work',
            header: const FieldHeader(title: '工作信息'),
            children: [
              FieldSpec<EmployeeData>(
                key: 'department',
                header: const FieldHeader(title: '部门'),
                builder: (ctx) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDepartmentColor(ctx.data.department),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ctx.data.department,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
              FieldSpec<EmployeeData>(
                key: 'position',
                header: const FieldHeader(title: '职位'),
                builder: (ctx) => Text(ctx.data.position),
              ),
              FieldSpec<EmployeeData>(
                key: 'salary',
                header: const FieldHeader(title: '薪资'),
                builder: (ctx) => Text(
                  '¥${ctx.data.salary.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (m) => '${m[1]},',
                      )}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
        appearance: const SheetAppearance(
          layoutMode: LayoutMode.fluid,
          showBorder: true,
          rowHeight: 56,
        ),
      ),
    );
  }

  Color _getDepartmentColor(String department) {
    switch (department) {
      case '技术部':
        return Colors.blue;
      case '设计部':
        return Colors.purple;
      case '市场部':
        return Colors.orange;
      case '人事部':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class EmployeeData {
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String email;
  final String department;
  final String position;
  final int salary;

  EmployeeData({
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.email,
    required this.department,
    required this.position,
    required this.salary,
  });
}
