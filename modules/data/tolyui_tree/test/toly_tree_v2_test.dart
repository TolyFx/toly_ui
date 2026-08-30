import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_tree/toly_tree.dart';

void main() {
  testWidgets('TolyTreeV2 仅构建展开路径中的可见节点', (WidgetTester tester) async {
    final List<TreeNode<String>> nodes = <TreeNode<String>>[
      TreeNode<String>(
        id: 'root',
        data: 'root',
        isExpanded: false,
        children: <TreeNode<String>>[
          TreeNode<String>(id: 'child', data: 'child', isLeaf: true),
        ],
      ),
    ];
    await tester.pumpWidget(_buildTree(nodes: nodes));

    expect(find.text('root'), findsOneWidget);
    expect(find.text('child'), findsNothing);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
    await tester.pump();

    expect(find.text('child'), findsOneWidget);
  });

  testWidgets('TolyTreeV2 完整 itemBuilder 获得受控节点状态', (
    WidgetTester tester,
  ) async {
    final List<TreeNode<String>> nodes = <TreeNode<String>>[
      TreeNode<String>(id: 'root', data: 'root', isLeaf: true),
    ];
    TolyTreeItemDetails<String>? capturedDetails;
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 200,
          child: TolyTreeV2<String>(
            nodes: nodes,
            nodeBuilder: _buildNode,
            expandedIds: const <String>{},
            selectedIds: const <String>{'root'},
            itemBuilder:
                (BuildContext context, TolyTreeItemDetails<String> details) {
              capturedDetails = details;
              return Text(details.node.data);
            },
          ),
        ),
      ),
    );

    expect(capturedDetails?.isSelected, isTrue);
    expect(capturedDetails?.depth, 0);
  });

  testWidgets('TolyTreeV2 支持方向键选择与 F2 快捷操作', (WidgetTester tester) async {
    final List<TreeNode<String>> nodes = <TreeNode<String>>[
      TreeNode<String>(id: 'first', data: 'first', isLeaf: true),
      TreeNode<String>(id: 'second', data: 'second', isLeaf: true),
    ];
    String? renamedId;
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 200,
          child: TolyTreeV2<String>(
            nodes: nodes,
            nodeBuilder: _buildNode,
            autofocus: true,
            onRenameRequested: (TreeNode<String> node) {
              renamedId = node.id;
            },
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.f2);
    await tester.pump();

    expect(renamedId, 'first');
  });

  testWidgets('TolyTreeV2 拖拽只回调结果且不修改节点结构', (
    WidgetTester tester,
  ) async {
    final TreeNode<String> source = TreeNode<String>(
      id: 'source',
      data: 'source',
      isLeaf: true,
    );
    final TreeNode<String> folder = TreeNode<String>(
      id: 'folder',
      data: 'folder',
      isLeaf: false,
    );
    final List<TreeNode<String>> nodes = <TreeNode<String>>[source, folder];
    TolyTreeDropResult<String>? dropResult;
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 200,
          child: TolyTreeV2<String>(
            nodes: nodes,
            nodeBuilder: _buildNode,
            draggable: true,
            dropPositionResolver: _resolveInsideDrop,
            canDrop: _allowFolderDrop,
            onDrop: (TolyTreeDropResult<String> result) {
              dropResult = result;
            },
          ),
        ),
      ),
    );

    await tester.drag(find.text('source'), const Offset(0, 32));
    await tester.pumpAndSettle();

    expect(dropResult?.source.id, 'source');
    expect(dropResult?.target?.id, 'folder');
    expect(dropResult?.position, TolyTreeDropPosition.inside);
    expect(nodes, <TreeNode<String>>[source, folder]);
    expect(folder.children, isEmpty);
  });
}

Widget _buildTree({required List<TreeNode<String>> nodes}) {
  return MaterialApp(
    home: SizedBox(
      height: 200,
      child: TolyTreeV2<String>(nodes: nodes, nodeBuilder: _buildNode),
    ),
  );
}

Widget _buildNode(TreeNode<String> node) {
  return Text(node.data);
}

TolyTreeDropPosition _resolveInsideDrop(
  Offset localPosition,
  Size targetSize,
  TreeNode<String> target,
) {
  return TolyTreeDropPosition.inside;
}

bool _allowFolderDrop(
  TreeNode<String> source,
  TreeNode<String>? target,
  TolyTreeDropPosition position,
) {
  return target?.id == 'folder' && position == TolyTreeDropPosition.inside;
}
