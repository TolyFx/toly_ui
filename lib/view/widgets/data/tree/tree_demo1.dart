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
    return Wrap(
      children: [
        SizedBox(
          width: 300,
          child: TolyTree<String>(
            nodes: _treeData.map(TreeNode<String>.fromMap).toList(),
            nodeBuilder: (node) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(node.data),
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: TolyTree<String>(
            showConnectingLines: true,
            nodes: natureScienceTree.map(TreeNode<String>.fromMap).toList(),
            nodeBuilder: (node) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(node.data),
            ),
          ),
        ),
      ],
    );
  }
}

List<Map<String, dynamic>> get _treeData => [
      {
        'id': '1',
        'data': '系统目录 (C:)',
        'isExpanded': true,
        'children': [
          {
            'id': '1-1',
            'data': 'Program Files',
            'children': [
              {
                'id': '1-1-1',
                'data': 'Microsoft Office',
                'children': [
                  {'id': '1-1-1-1', 'data': 'Word', 'isLeaf': true},
                  {'id': '1-1-1-2', 'data': 'Excel', 'isLeaf': true},
                  {'id': '1-1-1-3', 'data': 'PowerPoint', 'isLeaf': true},
                ],
              },
              {
                'id': '1-1-2',
                'data': 'Google',
                'children': [
                  {
                    'id': '1-1-2-1',
                    'data': 'Chrome',
                    'children': [
                      {'id': '1-1-2-1-1', 'data': 'Application', 'isLeaf': true},
                      {'id': '1-1-2-1-2', 'data': 'Locales', 'isLeaf': true},
                      {'id': '1-1-2-1-3', 'data': 'Extensions', 'isLeaf': true},
                    ],
                  },
                ],
              },
              {'id': '1-1-3', 'data': 'Adobe', 'isLeaf': true},
              {'id': '1-1-4', 'data': 'JetBrains', 'isLeaf': true},
            ],
          },
          {
            'id': '1-2',
            'data': 'Users',
            'children': [
              {
                'id': '1-2-1',
                'data': 'Administrator',
                'children': [
                  {
                    'id': '1-2-1-1',
                    'data': 'Desktop',
                    'children': [
                      {'id': '1-2-1-1-1', 'data': '快捷方式.lnk', 'isLeaf': true},
                      {'id': '1-2-1-1-2', 'data': '文件夹', 'isLeaf': true},
                    ],
                  },
                  {
                    'id': '1-2-1-2',
                    'data': 'Documents',
                    'children': [
                      {'id': '1-2-1-2-1', 'data': '工作文档.docx', 'isLeaf': true},
                      {'id': '1-2-1-2-2', 'data': '项目计划.xlsx', 'isLeaf': true},
                      {'id': '1-2-1-2-3', 'data': '会议纪要.pdf', 'isLeaf': true},
                    ],
                  },
                  {
                    'id': '1-2-1-3',
                    'data': 'Downloads',
                    'children': [
                      {'id': '1-2-1-3-1', 'data': 'flutter_windows.zip', 'isLeaf': true},
                      {'id': '1-2-1-3-2', 'data': 'android-studio.exe', 'isLeaf': true},
                      {'id': '1-2-1-3-3', 'data': 'vscode.exe', 'isLeaf': true},
                    ],
                  },
                  {'id': '1-2-1-4', 'data': 'Pictures', 'isLeaf': true},
                  {'id': '1-2-1-5', 'data': 'Videos', 'isLeaf': true},
                ],
              },
              {'id': '1-2-2', 'data': 'Public', 'isLeaf': true},
              {'id': '1-2-3', 'data': 'Default', 'isLeaf': true},
            ],
          },
          {
            'id': '1-3',
            'data': 'Windows',
            'children': [
              {'id': '1-3-1', 'data': 'System32', 'isLeaf': true},
              {'id': '1-3-2', 'data': 'SysWOW64', 'isLeaf': true},
              {'id': '1-3-3', 'data': 'Temp', 'isLeaf': true},
            ],
          },
        ],
      },
      {
        'id': '2',
        'data': '数据盘 (D:)',
        'children': [
          {
            'id': '2-1',
            'data': 'Projects',
            'children': [
              {
                'id': '2-1-1',
                'data': 'Flutter',
                'children': [
                  {'id': '2-1-1-1', 'data': 'toly_ui', 'isLeaf': true},
                  {'id': '2-1-1-2', 'data': 'my_app', 'isLeaf': true},
                  {'id': '2-1-1-3', 'data': 'demo_project', 'isLeaf': true},
                ],
              },
              {
                'id': '2-1-2',
                'data': 'Web',
                'children': [
                  {'id': '2-1-2-1', 'data': 'vue-project', 'isLeaf': true},
                  {'id': '2-1-2-2', 'data': 'react-app', 'isLeaf': true},
                ],
              },
            ],
          },
          {
            'id': '2-2',
            'data': 'Software',
            'children': [
              {'id': '2-2-1', 'data': 'Development', 'isLeaf': true},
              {'id': '2-2-2', 'data': 'Design', 'isLeaf': true},
              {'id': '2-2-3', 'data': 'Utilities', 'isLeaf': true},
            ],
          },
        ],
      },
    ];
List<Map<String, dynamic>> get natureScienceTree => [
      {
        'id': '1',
        'data': '自然科学',
        'isExpanded': true,
        'children': [
          {
            'id': '1-1',
            'data': '物理学 Physics',
            'children': [
              {
                'id': '1-1-1',
                'data': '力学 Mechanics',
                'children': [
                  {'id': '1-1-1-1', 'data': '经典力学 Classical Mechanics', 'isLeaf': true},
                  {'id': '1-1-1-2', 'data': '流体力学 Fluid Mechanics', 'isLeaf': true},
                  {'id': '1-1-1-3', 'data': '天体力学 Celestial Mechanics', 'isLeaf': true},
                ],
              },
              {
                'id': '1-1-2',
                'data': '电磁学 Electromagnetism',
                'children': [
                  {'id': '1-1-2-1', 'data': '电场 Electric Field', 'isLeaf': true},
                  {'id': '1-1-2-2', 'data': '磁场 Magnetic Field', 'isLeaf': true},
                  {'id': '1-1-2-3', 'data': '麦克斯韦方程组 Maxwell Equations', 'isLeaf': true},
                ],
              },
              {
                'id': '1-1-3',
                'data': '量子物理 Quantum Physics',
                'children': [
                  {'id': '1-1-3-1', 'data': '量子态 Quantum States', 'isLeaf': true},
                  {'id': '1-1-3-2', 'data': '波函数 Wave Function', 'isLeaf': true},
                  {'id': '1-1-3-3', 'data': '量子纠缠 Entanglement', 'isLeaf': true},
                ],
              },
              {
                'id': '1-1-4',
                'data': '热学 Thermodynamics',
                'children': [
                  {'id': '1-1-4-1', 'data': '温度 Temperature', 'isLeaf': true},
                  {'id': '1-1-4-2', 'data': '熵 Entropy', 'isLeaf': true},
                  {'id': '1-1-4-3', 'data': '热力学定律 Laws of Thermodynamics', 'isLeaf': true},
                ],
              },
            ],
          },

          // ---------------- 化学 ----------------
          {
            'id': '1-2',
            'data': '化学 Chemistry',
            'children': [
              {
                'id': '1-2-1',
                'data': '无机化学 Inorganic Chemistry',
                'children': [
                  {'id': '1-2-1-1', 'data': '酸碱 Acid-Base', 'isLeaf': true},
                  {'id': '1-2-1-2', 'data': '金属材料 Metals', 'isLeaf': true},
                  {'id': '1-2-1-3', 'data': '晶体结构 Crystal Structure', 'isLeaf': true},
                ],
              },
              {
                'id': '1-2-2',
                'data': '有机化学 Organic Chemistry',
                'children': [
                  {'id': '1-2-2-1', 'data': '烃类 Hydrocarbons', 'isLeaf': true},
                  {'id': '1-2-2-2', 'data': '聚合物 Polymers', 'isLeaf': true},
                  {'id': '1-2-2-3', 'data': '官能团 Functional Groups', 'isLeaf': true},
                ],
              },
              {
                'id': '1-2-3',
                'data': '分析化学 Analytical Chemistry',
                'children': [
                  {'id': '1-2-3-1', 'data': '色谱法 Chromatography', 'isLeaf': true},
                  {'id': '1-2-3-2', 'data': '光谱分析 Spectroscopy', 'isLeaf': true},
                  {'id': '1-2-3-3', 'data': '电化学分析 Electrochemical Analysis', 'isLeaf': true},
                ],
              },
            ],
          },

          // ---------------- 生物学 ----------------
          {
            'id': '1-3',
            'data': '生物学 Biology',
            'children': [
              {
                'id': '1-3-1',
                'data': '细胞生物学 Cell Biology',
                'children': [
                  {'id': '1-3-1-1', 'data': '细胞结构 Cell Structure', 'isLeaf': true},
                  {'id': '1-3-1-2', 'data': '细胞分裂 Mitosis/Meiosis', 'isLeaf': true},
                  {'id': '1-3-1-3', 'data': '细胞代谢 Metabolism', 'isLeaf': true},
                ],
              },
              {
                'id': '1-3-2',
                'data': '遗传学 Genetics',
                'children': [
                  {'id': '1-3-2-1', 'data': 'DNA 与 RNA', 'isLeaf': true},
                  {'id': '1-3-2-2', 'data': '基因表达 Gene Expression', 'isLeaf': true},
                  {'id': '1-3-2-3', 'data': '遗传规律 Mendelian Laws', 'isLeaf': true},
                ],
              },
              {
                'id': '1-3-3',
                'data': '生态学 Ecology',
                'children': [
                  {'id': '1-3-3-1', 'data': '生态系统 Ecosystem', 'isLeaf': true},
                  {'id': '1-3-3-2', 'data': '食物链 Food Chain', 'isLeaf': true},
                  {'id': '1-3-3-3', 'data': '种群 Population Dynamics', 'isLeaf': true},
                ],
              },
            ],
          },

          // ---------------- 地球科学 ----------------
          {
            'id': '1-4',
            'data': '地球科学 Earth Science',
            'children': [
              {
                'id': '1-4-1',
                'data': '地质学 Geology',
                'children': [
                  {'id': '1-4-1-1', 'data': '岩石 Rock Types', 'isLeaf': true},
                  {'id': '1-4-1-2', 'data': '矿物 Minerals', 'isLeaf': true},
                  {'id': '1-4-1-3', 'data': '板块运动 Plate Tectonics', 'isLeaf': true},
                ],
              },
              {
                'id': '1-4-2',
                'data': '气象学 Meteorology',
                'children': [
                  {'id': '1-4-2-1', 'data': '天气与气候 Weather & Climate', 'isLeaf': true},
                  {'id': '1-4-2-2', 'data': '大气环流 Circulation', 'isLeaf': true},
                  {'id': '1-4-2-3', 'data': '气象观测 Observation', 'isLeaf': true},
                ],
              },
              {
                'id': '1-4-3',
                'data': '海洋学 Oceanography',
                'children': [
                  {'id': '1-4-3-1', 'data': '海流 Ocean Currents', 'isLeaf': true},
                  {'id': '1-4-3-2', 'data': '珊瑚礁 Coral Reef', 'isLeaf': true},
                  {'id': '1-4-3-3', 'data': '海洋生态 Marine Ecology', 'isLeaf': true},
                ],
              },
            ],
          },

          // ---------------- 天文学 ----------------
          {
            'id': '1-5',
            'data': '天文学 Astronomy',
            'children': [
              {
                'id': '1-5-1',
                'data': '太阳系 Solar System',
                'children': [
                  {'id': '1-5-1-1', 'data': '行星 Planets', 'isLeaf': true},
                  {'id': '1-5-1-2', 'data': '卫星 Moons', 'isLeaf': true},
                  {'id': '1-5-1-3', 'data': '小行星 Asteroids', 'isLeaf': true},
                ],
              },
              {
                'id': '1-5-2',
                'data': '恒星物理 Stellar Physics',
                'children': [
                  {'id': '1-5-2-1', 'data': '恒星演化 Evolution', 'isLeaf': true},
                  {'id': '1-5-2-2', 'data': '超新星 Supernova', 'isLeaf': true},
                  {'id': '1-5-2-3', 'data': '中子星 Neutron Stars', 'isLeaf': true},
                ],
              },
              {
                'id': '1-5-3',
                'data': '宇宙学 Cosmology',
                'children': [
                  {'id': '1-5-3-1', 'data': '大爆炸 Big Bang', 'isLeaf': true},
                  {'id': '1-5-3-2', 'data': '暗物质 Dark Matter', 'isLeaf': true},
                  {'id': '1-5-3-3', 'data': '宇宙膨胀 Expansion', 'isLeaf': true},
                ],
              },
            ],
          },
        ],
      },
    ];
