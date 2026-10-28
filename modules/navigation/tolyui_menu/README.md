# tolyui_menu

`tolyui_menu` 是面向 Flutter 桌面与 Web 的独立菜单包，覆盖普通下拉菜单、级联菜单、上下文菜单和顶部菜单栏。

原 `toly_menu` 已迁移为 `tolyui_menu`，所有 `TolyMenu*` Dart API 保持不变。新项目应使用：

```yaml
dependencies:
  tolyui_menu: ^0.1.0
```

第一版采用单 Overlay 和单 `TolyMenuController` 管理整条菜单路径，避免每一级菜单独立创建浮层造成的关闭竞态和点击区域分裂。

```dart
TolyMenuAnchor(
  entries: <TolyMenuEntry>[
    TolyMenuItem(
      id: 'export',
      label: '导出',
      children: <TolyMenuEntry>[
        TolyMenuItem(
          id: 'json',
          label: 'JSON',
          shortcut: 'Ctrl+E',
          onSelected: exportJson,
        ),
      ],
    ),
  ],
  builder: (BuildContext context, TolyMenuController controller) {
    return const Text('文件');
  },
)
```

当前能力：

- 任意深度的菜单树与同级互斥展开。
- 单一控制器统一打开、关闭和活动路径。
- 禁用项、分隔线、图标、尾缀、快捷键和勾选状态。
- 鼠标悬浮展开与点击外部整组关闭。
- 上下、左右、Enter、Space 和 Esc 键盘操作。
- `TolyMenuAnchor` 和 `TolyMenuBar` 两种入口。
- 亮色、暗色及 `ThemeExtension` 自定义主题。

## 按内容包裹宽度

在 `TolyMenuThemeData` 中设置 `fitContent: true`，每一级面板按该级最长条目及图标、快捷键、尾缀、展开箭头的真实布局宽度收拢。此时 `panelWidth` 表示单个面板最大宽度，超长名称继续省略显示。关闭时保持原有固定宽度，默认关闭以兼容已有界面。

```dart
final TolyMenuThemeData menuTheme =
    TolyMenuThemeData.fromColorScheme(colorScheme).copyWith(
  fitContent: true,
  panelWidth: 210,
);
```

将该主题加入 `ThemeData.extensions`。浮层根据实际菜单尺寸定位，并在窗口边缘避让。

每一层菜单独立判断左侧图标列：整层没有 `leading` 且没有勾选标记时，省去图标占位；同层存在图标或勾选时，所有条目保留图标列以对齐文字。此规则也适用于子菜单，开启 `fitContent` 时面板随之收紧。
