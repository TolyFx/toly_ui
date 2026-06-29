import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';

@DisplayNode(
  title: 'TolyColorPicker 颜色选择器',
  desc: 'Ant Design 风格的全功能颜色选择器，整合 HSV 调色面板、透明度滑条、十六进制输入和预设色块网格。可嵌入页面或通过 showColorPicker 弹出使用。',
)
class ColorDemo6 extends StatefulWidget {
  const ColorDemo6({super.key});

  @override
  State<ColorDemo6> createState() => _ColorDemo6State();
}

class _ColorDemo6State extends State<ColorDemo6> {
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trigger button (Ant Design style)
        GestureDetector(
          onTap: () async {
            final result = await showColorPicker(context, color: _color);
            if (result != null) setState(() => _color = result);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '#${_color.red.toRadixString(16).padLeft(2, '0')}${_color.green.toRadixString(16).padLeft(2, '0')}${_color.blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase(),
                  style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.unfold_more, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Embedded panel
        SizedBox(
          width: 340,
          child: TolyColorPickerPanel(
            color: _color,
            onChanged: (v) => setState(() => _color = v),
          ),
        ),
      ],
    );
  }
}
