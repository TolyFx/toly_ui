# TolyUI 组件快速集成规范

本规范说明如何快速集成新组件到 TolyUI 框架。项目使用 `toly ui` 命令自动生成路由和代码资源文件。

## 快速集成（推荐）

使用自动化脚本一键集成：

```bash
dart test/script/integrate_component.dart <component_name> <module> <label> <subtitle>
```

示例：
```bash
dart test/script/integrate_component.dart phone_frame advanced PhoneFrame 手机外观
```

脚本会自动：
- 更新模块导出文件
- 添加菜单配置
- 注册路由

使用前提：已创建组件目录和 demo 文件。

## 集成步骤

### 1. 创建组件目录和案例文件

在对应模块下创建组件目录：

```
lib/view/widgets/{module}/{component}/
├── {component}_demo1.dart
├── {component}_demo2.dart
├── {component}_demo3.dart
├── {component}_demo4.dart
└── {component}.dart  # 导出文件
```

每个案例文件必须使用 `@DisplayNode` 注解：

```dart
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '基础用法',
  desc: '展示组件的基础用法...',
)
class ComponentDemo1 extends StatelessWidget {
  const ComponentDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### 2. 创建组件导出文件

在组件目录下创建 `{component}.dart`：

```dart
export '{component}_demo1.dart';
export '{component}_demo2.dart';
export '{component}_demo3.dart';
export '{component}_demo4.dart';
```

### 3. 更新模块导出

在模块导出文件中添加组件导出：

```dart
// lib/view/widgets/{module}/{module}.dart
export '{component}/{component}.dart';
```

**重要**：模块导出文件必须导出所有 demo 文件，这样 `toly ui` 命令才能扫描到 `@DisplayNode` 注解。

### 4. 添加菜单配置

在对应模块的菜单文件中添加菜单项：

```dart
// lib/navigation/menu/{module}.dart
{
  'path': '/{component}',
  'label': 'Component',
  'subtitle': '组件名',
  'tag': '新'  // 可选：标记为新组件
}
```

### 5. 注册路由

在路由配置文件中添加路由：

```dart
// lib/navigation/router/widgets_route.dart
GoRoute(
  path: '{module}',
  routes: [
    _customRoute('{component}'),  // 添加这一行
  ]
)
```

### 6. 添加 Overview 显示组件（可选）

在 overview 文件中添加组件的缩略展示：

```dart
// lib/view/widgets/overview/data.dart
class ComponentDisplay extends StatelessWidget {
  const ComponentDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.component, size: 48, color: hitColor);
  }
}
```

在 display_map.dart 中注册：

```dart
// lib/view/widgets/overview/display_map.dart
Widget overviewDisplayMap(String key){
  return switch(key){
    'Component' => ComponentDisplay(),
    // ...
  };
}
```

### 7. 运行自动集成脚本（可选）

如果已创建好组件目录和 demo 文件，可以使用自动化脚本完成步骤 3-5：

```bash
dart test/script/integrate_component.dart <component_name> <module> <label> <subtitle>
```

### 8. 运行自动生成命令

完成上述步骤后，运行命令自动生成路由和代码资源：

```bash
toly ui
```

该命令会自动：
- 扫描所有 `@DisplayNode` 注解
- 生成 `lib/view/widgets/display_nodes/gen/{component}.g.dart` 文件
- 更新 `lib/view/widgets/display_nodes/gen/node.g.dart` 注册
- 复制案例代码到 `assets/code_res/{component}_demo{n}.txt`

## 核心要点

1. **目录结构**：`lib/view/widgets/{module}/{component}/`
2. **文件命名**：`{component}_demo{number}.dart`
3. **注解标注**：每个案例必须使用 `@DisplayNode` 注解
4. **导出层级**：组件导出 → 模块导出（模块导出文件必须导出所有 demo）
5. **路径一致**：菜单 path 必须与路由 path 一致（小写）
6. **自动生成**：使用 `toly ui` 命令生成路由和资源文件

## 检查清单

集成完成后，确认以下事项：

- [ ] 组件目录已创建
- [ ] 案例文件已编写，包含 `@DisplayNode` 注解
- [ ] 组件导出文件已创建
- [ ] 模块导出文件已更新
- [ ] 菜单配置已添加
- [ ] 路由已注册
- [ ] Overview 显示组件已添加（可选）
- [ ] 已运行 `toly ui` 命令生成资源

## 验证集成

启动应用后：

1. 在左侧菜单找到对应模块
2. 点击组件菜单项
3. 右侧展示页面应显示所有案例
4. 每个案例可以独立预览和交互

## 常见问题

**Q: 案例没有显示？**
- 检查是否添加了 `@DisplayNode` 注解
- 检查是否运行了 `toly ui` 命令
- 检查导出文件是否正确

**Q: 菜单点击无反应？**
- 检查路由是否注册
- 检查路径是否使用小写
- 检查菜单 path 与路由 path 是否一致

**Q: 代码资源文件没有生成？**
- 确认已运行 `toly ui` 命令
- 检查案例文件是否有 `@DisplayNode` 注解
- 检查 assets/code_res/ 目录是否存在

## 示例：Default 组件集成

```
1. 创建目录和案例
   lib/view/widgets/data/default/
   ├── default_demo1.dart
   ├── default_demo2.dart
   ├── default_demo3.dart
   ├── default_demo4.dart
   └── default.dart

2. 更新导出
   lib/view/widgets/data/data.dart
   export 'default/default.dart';
   
   注意：data.dart 必须导出 default.dart，而 default.dart 导出所有 demo 文件

3. 添加菜单
   lib/navigation/menu/data.dart
   {'path': '/default', 'label': 'Default', 'subtitle': '缺省页', 'tag': '新'}

4. 注册路由
   lib/navigation/router/widgets_route.dart
   _customRoute('default')

5. 添加 Overview
   lib/view/widgets/overview/data.dart
   class DefaultDisplay extends StatelessWidget {...}
   
   lib/view/widgets/overview/display_map.dart
   'Default' => DefaultDisplay()

6. 运行生成命令
   toly ui
```

## 注意事项

- 组件名使用小写加下划线（如 `default`、`check_box`）
- 类名使用大驼峰（如 `DefaultDemo1`、`CheckBoxDemo1`）
- 菜单 label 使用大驼峰（如 `Default`、`CheckBox`）
- 所有路径使用小写（如 `/default`、`/check_box`）
- 运行 `toly ui` 命令前确保所有案例文件已保存
