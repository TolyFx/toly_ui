import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'toly_tree.dart';

@DisplayNode(
  title: '动画树形',
  desc: '带有平滑展开收起动画的树形组件。节点展开时有渐入效果，图标旋转动画，提供流畅的用户体验。',
)
class TreeDemo4 extends StatelessWidget {
  const TreeDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTree<String>(
      nodes: _buildSampleData(),
      animationDuration: const Duration(milliseconds: 300),
      nodeBuilder: (node) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              node.hasChildren ? Icons.folder : Icons.insert_drive_file,
              size: 16,
              color: node.hasChildren ? Colors.amber : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              node.data,
              style: TextStyle(
                fontWeight: node.hasChildren ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TreeNode<String>> _buildSampleData() {
    return [
      TreeNode(
        id: '1',
        data: 'TolyUI 框架项目',
        isExpanded: true,
        children: [
          TreeNode(
            id: '1-1',
            data: 'lib',
            isExpanded: true,
            children: [
              TreeNode(
                id: '1-1-1',
                data: 'view',
                children: [
                  TreeNode(
                    id: '1-1-1-1',
                    data: 'widgets',
                    children: [
                      TreeNode(
                        id: '1-1-1-1-1',
                        data: 'data',
                        children: [
                          TreeNode(id: '1-1-1-1-1-1', data: 'tree'),
                          TreeNode(id: '1-1-1-1-1-2', data: 'statistics'),
                          TreeNode(id: '1-1-1-1-1-3', data: 'tag'),
                          TreeNode(id: '1-1-1-1-1-4', data: 'card'),
                          TreeNode(id: '1-1-1-1-1-5', data: 'avatar'),
                        ],
                      ),
                      TreeNode(
                        id: '1-1-1-1-2',
                        data: 'form',
                        children: [
                          TreeNode(id: '1-1-1-1-2-1', data: 'input'),
                          TreeNode(id: '1-1-1-1-2-2', data: 'button'),
                          TreeNode(id: '1-1-1-1-2-3', data: 'checkbox'),
                        ],
                      ),
                      TreeNode(
                        id: '1-1-1-1-3',
                        data: 'navigation',
                        children: [
                          TreeNode(id: '1-1-1-1-3-1', data: 'menu'),
                          TreeNode(id: '1-1-1-1-3-2', data: 'breadcrumb'),
                          TreeNode(id: '1-1-1-1-3-3', data: 'tabs'),
                        ],
                      ),
                    ],
                  ),
                  TreeNode(id: '1-1-1-2', data: 'pages'),
                  TreeNode(id: '1-1-1-3', data: 'components'),
                ],
              ),
              TreeNode(
                id: '1-1-2',
                data: 'app',
                children: [
                  TreeNode(id: '1-1-2-1', data: 'theme'),
                  TreeNode(id: '1-1-2-2', data: 'logic'),
                  TreeNode(id: '1-1-2-3', data: 'router'),
                ],
              ),
              TreeNode(
                id: '1-1-3',
                data: 'navigation',
                children: [
                  TreeNode(id: '1-1-3-1', data: 'menu'),
                  TreeNode(id: '1-1-3-2', data: 'router'),
                ],
              ),
              TreeNode(id: '1-1-4', data: 'main.dart'),
            ],
          ),
          TreeNode(
            id: '1-2',
            data: 'modules',
            children: [
              TreeNode(
                id: '1-2-1',
                data: 'tolyui',
                children: [
                  TreeNode(id: '1-2-1-1', data: 'lib'),
                  TreeNode(id: '1-2-1-2', data: 'pubspec.yaml'),
                ],
              ),
              TreeNode(
                id: '1-2-2',
                data: 'tolyui_statistic',
                children: [
                  TreeNode(id: '1-2-2-1', data: 'lib'),
                  TreeNode(id: '1-2-2-2', data: 'example'),
                ],
              ),
            ],
          ),
          TreeNode(
            id: '1-3',
            data: 'assets',
            children: [
              TreeNode(
                id: '1-3-1',
                data: 'images',
                children: [
                  TreeNode(id: '1-3-1-1', data: 'logo.png'),
                  TreeNode(id: '1-3-1-2', data: 'icons'),
                ],
              ),
              TreeNode(id: '1-3-2', data: 'fonts'),
              TreeNode(id: '1-3-3', data: 'code_res'),
            ],
          ),
          TreeNode(
            id: '1-4',
            data: 'doc',
            children: [
              TreeNode(id: '1-4-1', data: 'articles'),
              TreeNode(id: '1-4-2', data: 'screenshots'),
              TreeNode(id: '1-4-3', data: 'README.md'),
            ],
          ),
          TreeNode(id: '1-5', data: 'pubspec.yaml'),
          TreeNode(id: '1-6', data: 'analysis_options.yaml'),
        ],
      ),
      TreeNode(
        id: '2',
        data: '其他项目',
        children: [
          TreeNode(
            id: '2-1',
            data: 'Vue 项目',
            children: [
              TreeNode(id: '2-1-1', data: 'src'),
              TreeNode(id: '2-1-2', data: 'public'),
              TreeNode(id: '2-1-3', data: 'package.json'),
            ],
          ),
          TreeNode(
            id: '2-2',
            data: 'React 项目',
            children: [
              TreeNode(id: '2-2-1', data: 'src'),
              TreeNode(id: '2-2-2', data: 'public'),
              TreeNode(id: '2-2-3', data: 'package.json'),
            ],
          ),
        ],
      ),
    ];
  }
}