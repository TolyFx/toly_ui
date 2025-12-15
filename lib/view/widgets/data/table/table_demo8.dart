import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_table/tolyui_table.dart';

@DisplayNode(
  title: '合并表头',
  desc:
      '展示支持多级表头合并的表格。通过嵌套的列定义结构，可以创建复杂的表头布局。支持任意层级的表头分组，适用于复杂数据结构的展示，如财务报表、统计分析等场景。',
)
class TableDemo8 extends StatelessWidget {
  const TableDemo8({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    return TolyTable<GroupedData>(
      bordered: true,
      columns: [
        TableColumn(
          title: 'Name',
          dataIndex: (data) => data.name,
          width: 100,
          render: (data, index) => Text(
            data.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        TableColumn(
          title: 'Personal Info',
          children: [
            TableColumn(
              title: 'Age',
              dataIndex: (data) => data.age,
              width: 80,
              align: TextAlign.center,
            ),
            TableColumn(
              title: 'Gender',
              dataIndex: (data) => data.gender,
              width: 80,
              align: TextAlign.center,
            ),
          ],
        ),
        TableColumn(
          title: 'Contact',
          children: [
            TableColumn(
              title: 'Phone',
              dataIndex: (data) => data.phone,
              width: 120,
            ),
            TableColumn(
              title: 'Email',
              dataIndex: (data) => data.email,
              width: 180,
            ),
          ],
        ),
        TableColumn(
          title: 'Work Info',
          children: [
            TableColumn(
              title: 'Department',
              dataIndex: (data) => data.department,
              width: 100,
            ),
            TableColumn(
              title: 'Position',
              dataIndex: (data) => data.position,
              width: 120,
            ),
            TableColumn(
              title: 'Salary',
              dataIndex: (data) => data.salary,
              width: 100,
              align: TextAlign.right,
              render: (data, index) => Text(
                '\$${data.salary.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    )}',
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.green),
              ),
            ),
          ],
        ),
      ],
      dataSource: const [
        GroupedData(
          name: 'John Brown',
          age: 32,
          gender: 'Male',
          phone: '+1 555-0123',
          email: 'john.brown@example.com',
          department: 'Engineering',
          position: 'Senior Developer',
          salary: 85000,
        ),
        GroupedData(
          name: 'Jane Smith',
          age: 28,
          gender: 'Female',
          phone: '+1 555-0124',
          email: 'jane.smith@example.com',
          department: 'Design',
          position: 'UI Designer',
          salary: 72000,
        ),
        GroupedData(
          name: 'Bob Johnson',
          age: 35,
          gender: 'Male',
          phone: '+1 555-0125',
          email: 'bob.johnson@example.com',
          department: 'Marketing',
          position: 'Marketing Manager',
          salary: 95000,
        ),
        GroupedData(
          name: 'Alice Wilson',
          age: 29,
          gender: 'Female',
          phone: '+1 555-0126',
          email: 'alice.wilson@example.com',
          department: 'HR',
          position: 'HR Specialist',
          salary: 68000,
        ),
        GroupedData(
          name: 'Charlie Davis',
          age: 42,
          gender: 'Male',
          phone: '+1 555-0127',
          email: 'charlie.davis@example.com',
          department: 'Finance',
          position: 'Financial Analyst',
          salary: 78000,
        ),
      ],
    );
  }
}

class GroupedData {
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String email;
  final String department;
  final String position;
  final int salary;

  const GroupedData({
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
