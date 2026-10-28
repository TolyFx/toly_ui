# tolyui_action

桌面工具栏与面板的轻量动作按钮，支持鼠标悬停、按压、键盘焦点和 Enter/Space 激活。只依赖 Flutter，无平台插件；默认无水波纹和描边。

```dart
TolyActionButton(
  onPressed: onMove,
  child: const Text('移动'),
)
```

可通过 foregroundColor、backgroundColor、hoverColor 和 selectedColor 定制产品样式。onPressed 为空时禁用；autofocus 适合让确认面板默认聚焦取消操作。

按钮在 Row 和 Wrap 中按内容宽度收缩；需要占满容器时由外部提供明确的宽度约束。
