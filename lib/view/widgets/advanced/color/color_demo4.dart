import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'Material 色块网格',
  desc: 'TolyColorGrid 预设色值快速选择网格。支持 fullMaterial（灰度+主色变体）与 material（500号主色）两种内置色板，也可自定义传入颜色列表。当前选中色块以白色边框+阴影高亮。',
)
class ColorDemo4 extends StatefulWidget {
  const ColorDemo4({super.key});

  @override
  State<ColorDemo4> createState() => _ColorDemo4State();
}

class _ColorDemo4State extends State<ColorDemo4> {
  Color _color = Colors.blue;
  bool _fullMode = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _modeChip('Material', !_fullMode),
            const SizedBox(width: 8),
            _modeChip('FullMaterial', _fullMode),
          ],
        ),
        const SizedBox(height: 8),
        _fullMode
            ? TolyColorGrid.fullMaterial(
                selectedColor: _color,
                onChanged: (v) => setState(() => _color = v),
              )
            : TolyColorGrid.material(
                selectedColor: _color,
                onChanged: (v) => setState(() => _color = v),
              ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '#${_color.red.toRadixString(16).padLeft(2, '0')}${_color.green.toRadixString(16).padLeft(2, '0')}${_color.blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase(),
              style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _modeChip(String label, bool selected) {
    return GestureDetector(
      onTap: () => setState(() => _fullMode = label == 'FullMaterial'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
