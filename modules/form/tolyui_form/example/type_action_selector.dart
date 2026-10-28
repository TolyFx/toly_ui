import 'package:flutter/material.dart';
import 'package:tolyui_form/tolyui_form.dart';

/// 示例宿主的业务类型，公共组件不内置这些类型。
enum ExampleImageSource { file, library, screenshot }

/// 展示受控值、自动触发配置与动作回调的独立组件示例。
class TypeActionSelectorExample extends StatefulWidget {
  const TypeActionSelectorExample({super.key});

  @override
  State<TypeActionSelectorExample> createState() =>
      _TypeActionSelectorExampleState();
}

class _TypeActionSelectorExampleState extends State<TypeActionSelectorExample> {
  /// 当前图片来源。
  ExampleImageSource _source = ExampleImageSource.file;

  /// 是否在选择类型后自动执行动作。
  bool _autoTrigger = false;

  /// 用于展示回调结果，不执行系统文件或截图能力。
  String _lastAction = '选择类型，再点击右侧动作图标';

  /// 示例中的动作调用次数。
  int _actionCount = 0;

  static const List<TolyTypeActionOption<ExampleImageSource>> _options = [
    TolyTypeActionOption(
      value: ExampleImageSource.file,
      label: '系统文件',
      actionIcon: Icon(Icons.folder_open_outlined),
      actionLabel: '选择系统文件',
    ),
    TolyTypeActionOption(
      value: ExampleImageSource.library,
      label: '媒体库',
      actionIcon: Icon(Icons.photo_library_outlined),
      actionLabel: '从媒体库选择图片',
    ),
    TolyTypeActionOption(
      value: ExampleImageSource.screenshot,
      label: '截图',
      actionIcon: Icon(Icons.screenshot_monitor),
      actionLabel: '开始截图',
    ),
  ];

  void _changeSource(ExampleImageSource source) =>
      setState(() => _source = source);

  void _changeAutoTrigger(bool enabled) =>
      setState(() => _autoTrigger = enabled);

  /// 由宿主根据类型分派具体业务，示例只显示调用记录。
  void _requestAction(ExampleImageSource source) {
    setState(() {
      _actionCount++;
      _lastAction = '动作 #$_actionCount：${source.name}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final TolyFormThemeData theme = TolyFormThemeData.of(context).copyWith(
      compactHeight: 24,
      borderColor: const Color(0xFFE2E7EE),
      focusBorderColor: const Color(0xFF3B82F6),
      fillColor: const Color(0xFFF7F8FA),
    );
    return Theme(
      data: Theme.of(context).copyWith(extensions: [theme]),
      child: SizedBox(
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TolyTypeActionSelector<ExampleImageSource>(
              value: _source,
              options: _options,
              autoTriggerOnSelect: _autoTrigger,
              onTypeChanged: _changeSource,
              onAction: _requestAction,
            ),
            const SizedBox(height: 8),
            TolyToggleField(
              value: _autoTrigger,
              label: const Text('选择类型后自动执行'),
              onChanged: _changeAutoTrigger,
            ),
            const SizedBox(height: 8),
            Text(_lastAction, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
