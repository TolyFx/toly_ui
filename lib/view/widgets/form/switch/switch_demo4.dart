import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '高度自定义',
  desc: '展示高度自定义的开关样式。通过自定义绘制实现独特的视觉效果，包括渐变色背景、图标切换、尺寸调整等。可以根据应用的设计语言创造出符合品牌特色的开关组件，提升界面的个性化和辨识度。',
)
class SwitchDemo4 extends StatefulWidget {
  const SwitchDemo4({super.key});

  @override
  State<SwitchDemo4> createState() => _SwitchDemo4State();
}

class _SwitchDemo4State extends State<SwitchDemo4> {
  bool _value1 = true;
  bool _value2 = false;
  bool _value3 = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSwitch(
              value: _value1,
              onChanged: (value) => setState(() => _value1 = value),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey.shade300,
            ),
            const SizedBox(width: 8),
            const Text('带图标'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSwitch(
              value: _value2,
              onChanged: (value) => setState(() => _value2 = value),
              activeColor: Colors.green,
              inactiveColor: Colors.grey.shade300,
              width: 60,
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text('大尺寸'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GradientSwitch(
              value: _value3,
              onChanged: (value) => setState(() => _value3 = value),
            ),
            const SizedBox(width: 8),
            const Text('渐变色'),
          ],
        ),
      ],
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double width;
  final double height;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.width = 50,
    this.height = 26,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: value ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? width - height + 2 : 2,
              top: 2,
              child: Container(
                width: height - 4,
                height: height - 4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  value ? Icons.check : Icons.close,
                  size: height - 12,
                  color: value ? activeColor : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GradientSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 26,
        decoration: BoxDecoration(
          gradient: value
              ? const LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                )
              : LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade400],
                ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 26 : 2,
              top: 2,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
