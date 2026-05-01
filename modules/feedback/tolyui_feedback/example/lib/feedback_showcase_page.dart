import 'package:flutter/material.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

class FeedbackShowcasePage extends StatefulWidget {
  const FeedbackShowcasePage({super.key});

  @override
  State<FeedbackShowcasePage> createState() => _FeedbackShowcasePageState();
}

class _FeedbackShowcasePageState extends State<FeedbackShowcasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件测试总览'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('TolyTooltip', const _TooltipSection()),
          _buildSection('TolyPopover', const _PopoverSection()),
          _buildSection('BubbleDecoration', const _BubbleDecorationSection()),
          _buildSection('Placement 方向', const _PlacementSection()),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Tooltip 测试区
// ============================================================
class _TooltipSection extends StatelessWidget {
  const _TooltipSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // 基础 Tooltip
        const TolyTooltip(
          message: '这是一个基础提示',
          child: _DemoChip(label: '基础', icon: Icons.info_outline),
        ),

        // 气泡样式
        const TolyTooltip(
          message: '气泡装饰样式',
          decorationConfig: DecorationConfig(
            isBubble: true,
            backgroundColor: Color(0xff303133),
          ),
          child: _DemoChip(label: '气泡', icon: Icons.chat_bubble_outline),
        ),

        // 非气泡（纯圆角）
        const TolyTooltip(
          message: '纯圆角矩形样式',
          decorationConfig: DecorationConfig(
            isBubble: false,
            backgroundColor: Colors.indigo,
            radius: Radius.circular(8),
          ),
          child: _DemoChip(label: '圆角', icon: Icons.rounded_corner),
        ),

        // 富文本
        const TolyTooltip(
          richMessage: TextSpan(children: [
            TextSpan(
                text: '加粗 ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '+ 普通文字'),
          ]),
          child: _DemoChip(label: '富文本', icon: Icons.text_fields),
        ),

        // 点击触发
        const TolyTooltip(
          message: '点击触发的提示',
          triggerMode: TooltipTriggerMode.tap,
          child: _DemoChip(label: '点击触发', icon: Icons.touch_app),
        ),

        // 自定义等待时间
        const TolyTooltip(
          message: '等待 500ms 后显示',
          waitDuration: Duration(milliseconds: 500),
          child: _DemoChip(label: '延迟显示', icon: Icons.timer),
        ),
      ],
    );
  }
}

// ============================================================
// Popover 测试区
// ============================================================
class _PopoverSection extends StatelessWidget {
  const _PopoverSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // Controller 模式
        _PopoverControllerDemo(),

        // Builder 模式
        _PopoverBuilderDemo(),

        // overlayBuilder 模式
        _PopoverOverlayBuilderDemo(),
      ],
    );
  }
}

class _PopoverControllerDemo extends StatelessWidget {
  _PopoverControllerDemo();

  final PopoverController _ctrl = PopoverController();

  @override
  Widget build(BuildContext context) {
    return TolyPopover(
      controller: _ctrl,
      placement: Placement.bottom,
      overlay: Container(
        padding: const EdgeInsets.all(12),
        child: const Text('Controller 控制的弹出层'),
      ),
      builder: (context, ctrl, child) {
        return ElevatedButton.icon(
          onPressed: () {
            if (ctrl.isOpen) {
              ctrl.close();
            } else {
              ctrl.open();
            }
          },
          icon: const Icon(Icons.toggle_on, size: 18),
          label: const Text('Controller 模式'),
        );
      },
    );
  }
}

class _PopoverBuilderDemo extends StatelessWidget {
  _PopoverBuilderDemo();

  final PopoverController _ctrl = PopoverController();

  @override
  Widget build(BuildContext context) {
    return TolyPopover(
      controller: _ctrl,
      placement: Placement.right,
      decorationConfig: const DecorationConfig(
        isBubble: true,
        backgroundColor: Colors.white,
        style: PaintingStyle.stroke,
      ),
      overlay: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('菜单项 A', style: TextStyle(fontSize: 14)),
            Divider(height: 12),
            Text('菜单项 B', style: TextStyle(fontSize: 14)),
            Divider(height: 12),
            Text('菜单项 C', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
      builder: (context, ctrl, child) {
        return ElevatedButton.icon(
          onPressed: () => ctrl.open(),
          icon: const Icon(Icons.menu, size: 18),
          label: const Text('右侧菜单'),
        );
      },
    );
  }
}

class _PopoverOverlayBuilderDemo extends StatelessWidget {
  _PopoverOverlayBuilderDemo();

  final PopoverController _ctrl = PopoverController();

  @override
  Widget build(BuildContext context) {
    return TolyPopover(
      controller: _ctrl,
      placement: Placement.bottom,
      overlayBuilder: (context, ctrl) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('动态构建的内容'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ctrl.close(),
                child: const Text('关闭'),
              ),
            ],
          ),
        );
      },
      builder: (context, ctrl, child) {
        return ElevatedButton.icon(
          onPressed: () => ctrl.open(),
          icon: const Icon(Icons.build, size: 18),
          label: const Text('overlayBuilder'),
        );
      },
    );
  }
}

// ============================================================
// BubbleDecoration 测试区
// ============================================================
class _BubbleDecorationSection extends StatelessWidget {
  const _BubbleDecorationSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _bubbleBox('Top', Placement.top),
        _bubbleBox('Bottom', Placement.bottom),
        _bubbleBox('Left', Placement.left),
        _bubbleBox('Right', Placement.right),
      ],
    );
  }

  Widget _bubbleBox(String label, Placement placement) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 50,
          decoration: BubbleDecoration(
            color: Colors.blue.shade50,
            boxSize: const Size(60, 30),
            placement: placement,
            borderColor: Colors.blue,
            shiftX: 0,
            style: PaintingStyle.stroke,
            radius: const Radius.circular(6),
            bubbleMeta: const BubbleMeta(spineHeight: 8, angle: 70),
          ),
          child: Center(
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
        ),
        const SizedBox(height: 4),
        Text(placement.name,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

// ============================================================
// Placement 12 方向测试区
// ============================================================
class _PlacementSection extends StatelessWidget {
  const _PlacementSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 300,
        child: Stack(
          children: [
            // 中心目标
            const Positioned(
              left: 150,
              top: 110,
              child: _CenterTarget(),
            ),
            // Top 行
            _placementBtn(Placement.topStart, 90, 10),
            _placementBtn(Placement.top, 155, 10),
            _placementBtn(Placement.topEnd, 220, 10),
            // Bottom 行
            _placementBtn(Placement.bottomStart, 90, 220),
            _placementBtn(Placement.bottom, 155, 220),
            _placementBtn(Placement.bottomEnd, 220, 220),
            // Left 列
            _placementBtn(Placement.leftStart, 0, 70),
            _placementBtn(Placement.left, 0, 120),
            _placementBtn(Placement.leftEnd, 0, 170),
            // Right 列
            _placementBtn(Placement.rightStart, 310, 70),
            _placementBtn(Placement.right, 310, 120),
            _placementBtn(Placement.rightEnd, 310, 170),
          ],
        ),
      ),
    );
  }

  Widget _placementBtn(Placement placement, double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: TolyTooltip(
        message: placement.name,
        placement: placement,
        decorationConfig: const DecorationConfig(
          isBubble: true,
          backgroundColor: Color(0xff303133),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            placement.name,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}

class _CenterTarget extends StatelessWidget {
  const _CenterTarget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple),
      ),
      child: const Center(
        child: Text('目标区域',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ============================================================
// 通用小组件
// ============================================================
class _DemoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DemoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
