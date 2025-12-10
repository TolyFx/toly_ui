import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'toly_tree.dart';

@DisplayNode(
  title: '基础树形',
  desc: '展示基本的树形结构，支持节点展开收起。通过递归渲染实现无限层级嵌套，适用于文件目录、组织架构等场景。',
)
class TreeDemo1 extends StatelessWidget {
  const TreeDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTree<String>(
      nodes: _buildSampleData(),
      nodeBuilder: (node) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(node.data),
      ),
    );
  }

  List<TreeNode<String>> _buildSampleData() {
    return [
      TreeNode(
        id: '1',
        data: '系统目录 (C:)',
        isExpanded: true,
        children: [
          TreeNode(
            id: '1-1',
            data: 'Program Files',
            children: [
              TreeNode(
                id: '1-1-1',
                data: 'Microsoft Office',
                children: [
                  TreeNode(id: '1-1-1-1', data: 'Word'),
                  TreeNode(id: '1-1-1-2', data: 'Excel'),
                  TreeNode(id: '1-1-1-3', data: 'PowerPoint'),
                ],
              ),
              TreeNode(
                id: '1-1-2',
                data: 'Google',
                children: [
                  TreeNode(
                    id: '1-1-2-1',
                    data: 'Chrome',
                    children: [
                      TreeNode(id: '1-1-2-1-1', data: 'Application'),
                      TreeNode(id: '1-1-2-1-2', data: 'Locales'),
                      TreeNode(id: '1-1-2-1-3', data: 'Extensions'),
                    ],
                  ),
                ],
              ),
              TreeNode(id: '1-1-3', data: 'Adobe'),
              TreeNode(id: '1-1-4', data: 'JetBrains'),
            ],
          ),
          TreeNode(
            id: '1-2',
            data: 'Users',
            children: [
              TreeNode(
                id: '1-2-1',
                data: 'Administrator',
                children: [
                  TreeNode(
                    id: '1-2-1-1',
                    data: 'Desktop',
                    children: [
                      TreeNode(id: '1-2-1-1-1', data: '快捷方式.lnk'),
                      TreeNode(id: '1-2-1-1-2', data: '文件夹'),
                    ],
                  ),
                  TreeNode(
                    id: '1-2-1-2',
                    data: 'Documents',
                    children: [
                      TreeNode(id: '1-2-1-2-1', data: '工作文档.docx'),
                      TreeNode(id: '1-2-1-2-2', data: '项目计划.xlsx'),
                      TreeNode(id: '1-2-1-2-3', data: '会议纪要.pdf'),
                    ],
                  ),
                  TreeNode(
                    id: '1-2-1-3',
                    data: 'Downloads',
                    children: [
                      TreeNode(id: '1-2-1-3-1', data: 'flutter_windows.zip'),
                      TreeNode(id: '1-2-1-3-2', data: 'android-studio.exe'),
                      TreeNode(id: '1-2-1-3-3', data: 'vscode.exe'),
                    ],
                  ),
                  TreeNode(id: '1-2-1-4', data: 'Pictures'),
                  TreeNode(id: '1-2-1-5', data: 'Videos'),
                ],
              ),
              TreeNode(id: '1-2-2', data: 'Public'),
              TreeNode(id: '1-2-3', data: 'Default'),
            ],
          ),
          TreeNode(
            id: '1-3',
            data: 'Windows',
            children: [
              TreeNode(id: '1-3-1', data: 'System32'),
              TreeNode(id: '1-3-2', data: 'SysWOW64'),
              TreeNode(id: '1-3-3', data: 'Temp'),
            ],
          ),
        ],
      ),
      TreeNode(
        id: '2',
        data: '数据盘 (D:)',
        children: [
          TreeNode(
            id: '2-1',
            data: 'Projects',
            children: [
              TreeNode(
                id: '2-1-1',
                data: 'Flutter',
                children: [
                  TreeNode(id: '2-1-1-1', data: 'toly_ui'),
                  TreeNode(id: '2-1-1-2', data: 'my_app'),
                  TreeNode(id: '2-1-1-3', data: 'demo_project'),
                ],
              ),
              TreeNode(
                id: '2-1-2',
                data: 'Web',
                children: [
                  TreeNode(id: '2-1-2-1', data: 'vue-project'),
                  TreeNode(id: '2-1-2-2', data: 'react-app'),
                ],
              ),
            ],
          ),
          TreeNode(
            id: '2-2',
            data: 'Software',
            children: [
              TreeNode(id: '2-2-1', data: 'Development'),
              TreeNode(id: '2-2-2', data: 'Design'),
              TreeNode(id: '2-2-3', data: 'Utilities'),
            ],
          ),
        ],
      ),
    ];
  }
}