# TolyUI Pop Panel

统一的 Flutter 底部弹出面板模板，提供拖拽条、标题栏、关闭按钮、有限高度内容区与可选底部操作区。

```dart
await TolyPopPanel.show<void>(
  context: context,
  title: '元素配置',
  child: const PropertyForm(),
);
```

确认类交互使用独立的统一面板：

```dart
final bool accepted = await TolyConfirmPanel.show(
  context: context,
  title: '隐私协议',
  message: '请先阅读并同意用户协议和隐私政策',
  cancelLabel: '取消',
  confirmLabel: '同意并继续',
);
```
