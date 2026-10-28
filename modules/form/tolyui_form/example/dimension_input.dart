import 'package:flutter/material.dart';
import 'package:tolyui_form/tolyui_form.dart';

/// 可嵌入组件展示页的尺寸输入示例，不接入媒体、磁盘或处理任务。
class DimensionInputExample extends StatefulWidget {
  const DimensionInputExample({super.key});

  @override
  State<DimensionInputExample> createState() => _DimensionInputExampleState();
}

class _DimensionInputExampleState extends State<DimensionInputExample> {
  /// 示例宿主持有的宽度草稿。
  final TextEditingController _width = TextEditingController(text: '576');

  /// 示例宿主持有的高度草稿。
  final TextEditingController _height = TextEditingController(text: '960');

  /// 宽度编辑焦点。
  final FocusNode _widthFocus = FocusNode();

  /// 高度编辑焦点。
  final FocusNode _heightFocus = FocusNode();

  /// 示例仅回填锁状态，比例计算由实际业务提供。
  bool _locked = true;

  /// 展示明确提交的原始值。
  String _lastSubmission = '回车确认尺寸；比例计算由宿主提供';

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 240,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TolyDimensionInput(
                widthController: _width,
                heightController: _height,
                widthFocusNode: _widthFocus,
                heightFocusNode: _heightFocus,
                locked: _locked,
                onLockChanged: _changeLock,
                onWidthSubmitted: _submitWidth,
                onHeightSubmitted: _submitHeight),
            const SizedBox(height: 8),
            Text(_lastSubmission, style: const TextStyle(fontSize: 11)),
          ]));

  void _changeLock(bool value) => setState(() => _locked = value);
  void _submitWidth(String value) =>
      setState(() => _lastSubmission = '确认宽度：$value');
  void _submitHeight(String value) =>
      setState(() => _lastSubmission = '确认高度：$value');

  @override
  void dispose() {
    _width.dispose();
    _height.dispose();
    _widthFocus.dispose();
    _heightFocus.dispose();
    super.dispose();
  }
}
