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
