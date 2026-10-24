# tolyui_form

面向 Toly UI 的紧凑、可组合 Flutter 表单控件。

## 组件规范

[tolyui-form 组件规范](docs/specs/README.md)用于逐项定义通用表单控件。第一项为[类型动作选择器](docs/specs/type-action-selector.md)，已在当前源码中实现，从0.0.2起提供。具体契约、参数与行为见规范正文。已确认的节点字段、字形、留白和动作区尺寸见[紧凑表单基础尺寸](docs/specs/compact-layout.md)。

## 类型动作选择器

`TolyTypeActionSelector<T>` 将类型下拉与动作图标合并为一行。`TolyTypeActionOption<T>` 定义类型值、标签、动作图标和提示。

```dart
TolyTypeActionSelector<String>(
  value: sourceType,
  options: const [
    TolyTypeActionOption(
      value: 'file',
      label: '系统文件',
      actionIcon: Icon(Icons.folder_open_outlined),
      actionLabel: '选择系统文件',
    ),
    TolyTypeActionOption(
      value: 'library',
      label: '媒体库',
      actionIcon: Icon(Icons.photo_library_outlined),
      actionLabel: '从媒体库选择图片',
    ),
  ],
  onTypeChanged: changeSourceType,
  onAction: requestSource,
  autoTriggerOnSelect: true,
  actionRunning: isChoosingSource,
)
```

宿主在`onTypeChanged`接收并更新`value`。`onAction`每次拿到本次操作的类型；如需异步选择文件或截图，由宿主执行并同步设置`actionRunning`，组件会保留原图标并禁用两区，不展示 loading。取消或失败由宿主处理，不回滚类型、不自动重试。

默认`autoTriggerOnSelect: false`，初始化、回填和修改开关不会自动执行；开启后每次选择菜单项执行一次，包括重复选择当前类型。`actionEnabled: false`仅禁用动作，`enabled: false`整体禁用。主题和密度沿用`TolyFormThemeData`，紧凑默认28px；可将主题`compactHeight`设为24px。类型文字默认11px，动作区26px，支持Tab、方向键、Enter/Space与Esc。

[独立示例组件](example/type_action_selector.dart)展示三种图片来源、自动触发开关和回调记录。它是可嵌入展示应用的Widget，不是带平台宿主的独立App。

```sh
flutter test --no-pub
flutter analyze --no-pub lib test example/type_action_selector.dart
```

## 尺寸输入器

`TolyDimensionInput`将W/H输入与比例锁合成一行。`TolyDimensionInputStyle`支持字段宽高、文字、圆角、光标、选区与动作区尺寸；未覆盖项沿用表单主题。详见[F002规范](docs/specs/dimension-input.md)和[可嵌入示例](example/dimension_input.dart)。

```dart
TolyDimensionInput(
  widthController: widthController,
  heightController: heightController,
  widthFocusNode: widthFocus,
  heightFocusNode: heightFocus,
  locked: lockAspectRatio,
  onLockChanged: changeLock,
  onWidthChanged: changeWidthDraft,
  onHeightChanged: changeHeightDraft,
  onWidthSubmitted: commitWidth,
  onHeightSubmitted: commitHeight,
  style: const TolyDimensionInputStyle(height: 28),
)
```

宿主拥有并销毁控制器与焦点。组件只返回草稿/回车/比例请求，不自动联动另一侧；失焦提交、Form校验、单位、范围及实际尺寸计算由宿主提供。固定fieldWidth时包裹内容，空值时均分有界宽度。默认没有Tooltip和loading。当前源码已实现，从0.0.2起提供。
