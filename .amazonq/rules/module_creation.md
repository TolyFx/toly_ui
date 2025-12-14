# TolyUI 模块创建流程

从 React 组件参考实现到 Flutter 组件模块的完整流程。

## 流程概览

1. **创建模块骨架** - 使用脚本创建基础结构
2. **准备参考资料** - 粘贴 React 组件源码到 doc/ref/
3. **分析并实现** - 参考 React 实现 Flutter 组件
4. **集成到主项目** - 添加依赖、创建案例、配置路由
5. **生成资源** - 运行 toly ui 命令

---

## 一、创建模块骨架

使用脚本快速创建模块骨架：

```bash
dart test/script/create_module.dart {module_name} {category}
```

示例：
```bash
dart test/script/create_module.dart toly_table data
```

生成的目录结构：
```
modules/data/toly_table/
├── lib/
│   ├── src/              # 组件源码目录
│   └── toly_table.dart   # 导出文件
├── doc/
│   └── ref/              # 参考资料目录（空）
├── test/
├── pubspec.yaml
├── README.md
└── LICENSE
```

## 二、准备参考资料

**❗️ 重要：在实现组件前，先准备好 React 组件源码**

将 React 组件源码粘贴到 `modules/{category}/{module_name}/doc/ref/{component}/` 目录：

```
modules/data/toly_table/doc/ref/table/
├── demo/           # 案例代码（必需）
│   ├── basic.tsx
│   ├── bordered.tsx
│   └── ...
├── style/          # 样式定义（必需）
│   └── index.ts
├── index.tsx       # 主组件（必需）
└── *.tsx           # 子组件
```

**关键文件说明：**
- `index.tsx` - 主组件，查看 props 定义
- `demo/*.tsx` - 使用案例，确定需要实现的功能
- `style/index.ts` - 样式规范，获取尺寸、颜色、间距

## 三、分析并实现组件

### 1. 分析 React 组件

**查看 `index.tsx`**：
- 组件 props 定义
- 默认值
- 子组件结构

**查看 `demo/*.tsx`**：
- 有多少个案例
- 每个案例展示什么功能
- 数据结构

**查看 `style/index.ts`**：
- 颜色值（如 #f0f0f0）
- 尺寸值（如 padding: 16）
- 动画时长

### 2. 创建 Flutter 组件

在 `lib/src/` 创建组件文件：

```dart
// lib/src/toly_{component}.dart
import 'package:flutter/material.dart';

class Toly{Component} extends StatelessWidget {
  // 参考 React props 定义属性
  final bool prop1;
  final String? prop2;
  
  const Toly{Component}({
    super.key,
    this.prop1 = false,
    this.prop2,
  });

  @override
  Widget build(BuildContext context) {
    // 实现组件
  }
}
```

### 3. 更新导出文件

```dart
// lib/{module_name}.dart
library {module_name};

export 'src/toly_{component}.dart';
```

## 四、集成到主项目

### 1. 添加依赖

编辑 `pubspec.yaml`：

```yaml
dependencies:
  {module_name}:
    path: modules/{category}/{module_name}
```

### 2. 创建案例目录

```bash
mkdir -p lib/view/widgets/{category}/{component}
```

### 3. 创建案例文件

参考 `doc/ref/{component}/demo/` 创建对应案例：

```dart
// lib/view/widgets/{category}/{component}/{component}_demo1.dart
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:{module_name}/{module_name}.dart';

@DisplayNode(
  title: '基础用法',
  desc: '展示组件的基础用法...',
)
class {Component}Demo1 extends StatelessWidget {
  const {Component}Demo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Toly{Component}();
  }
}
```

### 4. 创建导出文件

```dart
// lib/view/widgets/{category}/{component}/{component}.dart
export '{component}_demo1.dart';
export '{component}_demo2.dart';
// ...
```

### 5. 更新模块导出

```dart
// lib/view/widgets/{category}/{category}.dart
export '{component}/{component}.dart';
```

### 6. 配置路由和菜单

### 1. 添加菜单项

编辑 `lib/navigation/menu/{category}.dart`：

```dart
{
  'path': '/{component}',
  'label': '{Component}',
  'subtitle': '组件名',
}
```

### 2. 注册路由

编辑 `lib/navigation/router/widgets_route.dart`：

```dart
GoRoute(
  path: '{category}',
  routes: [
    _customRoute('{component}'),
  ]
)
```

## 五、生成资源

运行命令生成路由和代码资源：

```bash
toly ui
```

自动生成：
- `lib/view/widgets/display_nodes/gen/{component}.g.dart`
- `assets/code_res/{component}_demo*.txt`

## 六、验证

1. 运行 `flutter pub get`
2. 启动应用
3. 在左侧菜单找到组件
4. 验证所有案例正常显示

## 关键要点

### React 到 Flutter 映射

| React | Flutter |
|-------|---------|
| props | 构造函数参数 |
| useState | StatefulWidget + State |
| useEffect | initState / didUpdateWidget |
| className | decoration / style |
| style | TextStyle / BoxDecoration |
| children | child / children |

### 样式转换

```typescript
// React CSS
{
  width: 16,
  height: 3,
  borderRadius: 4,
  backgroundColor: '#f0f0f0'
}
```

```dart
// Flutter
Container(
  width: 16,
  height: 3,
  decoration: BoxDecoration(
    color: Color(0xFFF0F0F0),
    borderRadius: BorderRadius.circular(4),
  ),
)
```

### 动画实现

React 使用 CSS animation，Flutter 使用 AnimationController：

```dart
class _State extends State<Widget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    if (widget.active) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## 常见问题

**Q: 如何处理复杂的子组件？**
- 主组件：公开导出
- 子组件：私有类（`_ClassName`）或独立文件

**Q: 如何确定默认值？**
- 参考 React 组件的 defaultProps
- 参考 Ant Design 文档的默认值说明

**Q: 样式如何适配？**
- 优先使用 Material Design 标准
- 参考 React 组件的 style/index.ts 中的 token 定义
- 保持视觉一致性

**Q: 案例数量如何确定？**
- 参考 React demo 目录的案例数量
- 通常 3-7 个案例
- 覆盖基础、进阶、特殊场景
