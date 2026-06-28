# TolyUI 展示组件体系分析报告

> 生成时间：2026-06-29  
> 项目：toly_ui (TolyFx)  
> 作者：张风捷特烈

---

## 一、总体概述

TolyUI 的展示组件体系是一套**基于注解驱动的代码生成框架**，用于将组件库中的 Demo 代码自动收集、注册并渲染为一个可浏览、可交互的展示页面。整个体系由四个层次组成，通过代码生成工具打通从源码标记到 UI 渲染的完整链路。

### 核心理念

- **一处注解，多处可用**：开发者只需在 Demo 类上添加 `@DisplayNode` 注解，代码生成工具会自动完成数据提取、源文件保存、映射注册等工作。
- **声明式展示**：运行时通过组件名查询已注册的 Demo 列表，无需手动维护路由或注册表。
- **代码即文档**：每个 Demo 同时展示运行效果和源码，既是交互演示也是开发文档。

---

## 二、整体架构

```
┌─────────────────────────────────────────────────────┐
│                  Demo 源文件层                        │
│  @DisplayNode(title: '基础用法', desc: '...')        │
│  class ButtonDemo1 extends StatefulWidget { ... }    │
│  位置: lib/view/widgets/<category>/xxx_demo.dart     │
└────────────────────────┬────────────────────────────┘
                         │ 扫描 & 解析
                         ▼
┌─────────────────────────────────────────────────────┐
│               代码生成工具层                          │
│  test/toly_ui_gen_tool/                              │
│  ├── DisplayFileParser  正则扫描 @DisplayNode 注解    │
│  ├── FileGen            生成 .g.dart 映射文件         │
│  └── NodeMeta.saveCode  保存源码到 assets/code_res/   │
└────────────────────────┬────────────────────────────┘
                         │ 生成
                         ▼
┌─────────────────────────────────────────────────────┐
│               生成数据层                              │
│  lib/view/widgets/display_nodes/gen/                 │
│  ├── node.g.dart          主入口 + queryDisplayNodes │
│  ├── widget_display_map.g.dart    Widget→Demo映射    │
│  └── <category>.g.dart     55个分类数据文件           │
│  assets/code_res/                             源文件 │
└────────────────────────┬────────────────────────────┘
                         │ 运行时查询
                         ▼
┌─────────────────────────────────────────────────────┐
│                 UI 展示层                             │
│  WidgetDisplayPage → SliverDisplayNodeList           │
│                    → NodeDisplay (标题+描述)          │
│                    → CodeDisplay (效果+源码)           │
└─────────────────────────────────────────────────────┘
```

---

## 三、数据模型层

### 3.1 DisplayNode（运行时注解/数据模型）

**文件**：`lib/view/widgets/display_nodes/display_nodes.dart`

```dart
class DisplayNode {
  final String title;   // Demo 标题
  final String desc;    // Demo 描述

  static final RegExp _titleRegex = RegExp(r"""title.*('|")(?<title>.*)('|")""");
  static final RegExp _descRegex = RegExp(r"""desc.*('|")(?<desc>.*)('|")""");

  const DisplayNode({required this.title, required this.desc});

  // 从 @DisplayNode(...) 注解文本中解析元数据
  factory DisplayNode.fromString(String text) { ... }
}
```

`DisplayNode` 具有**双重身份**：
- **编译时注解**：以 `@DisplayNode(title: '...', desc: '...')` 形式标记 Demo 类
- **运行时数据模型**：通过 `fromString` 工厂方法从注解文本中提取 title 和 desc

### 3.2 NodeMeta（编译时元数据）

**文件**：`test/toly_ui_gen_tool/display_meta.dart`

```dart
class NodeMeta {
  final String filePath;     // Demo 源码文件路径
  final String code;          // Demo 类完整源码
  final String name;          // Demo 类名 (如 ButtonDemo1)
  final DisplayNode display;  // 从注解解析的显示信息

  String get assetPath => 'assets/code_res/${basename(filePath)}.txt';

  Map<String, dynamic> get valueMap => {
    'title': display.title,
    'desc': display.desc,
    'code': assetPath,     // 指向 assets 中的资源路径
  };

  void saveCode() { ... }   // 将源码保存到 assets/code_res/
}
```

- `filePath`：Demo 类所在源码文件路径
- `code`：通过正则提取的完整类代码
- `name`：类名，用作运行时映射的 key
- `display`：从 `@DisplayNode` 注解中解析的标题和描述

### 3.3 Node（运行时展示模型）

**文件**：`lib/components/node_display.dart`

```dart
class Node {
  final String title;
  final String desc;
  final String code;  // assets 资源路径或直接代码字符串

  factory Node.fromMap(dynamic map) {
    return Node(title: map['title'], desc: map['desc'], code: map['code']);
  }
}
```

运行时从生成数据中构建的轻量模型，用于传递给 UI 组件。

---

## 四、代码生成工具层

### 4.1 工具入口

**文件**：`test/toly_ui_gen_tool/toly_ui_gen_tool.dart`

```dart
void main() async {
  await TolyUIGenTool().gen();
}

class TolyUIGenTool {
  Future<void> gen() async {
    String dataPath = path.join(Directory.current.path, 'lib/view/widgets');
    Map<String, List<NodeMeta>> displayMap = {};
    await parserDir(dataDir, displayMap);     // 1. 扫描源码目录

    String genPath = path.join(Directory.current.path, 'lib/view/widgets/display_nodes/gen');
    await FileGen(displayMap).genNode(out);   // 2. 生成映射文件
  }
}
```

执行流程：扫描 `lib/view/widgets` 目录 → 解析每个包含 `@DisplayNode` 注解的 `_demo` 文件 → 生成映射文件。

### 4.2 文件解析器

**文件**：`test/toly_ui_gen_tool/display_file_parser.dart`

```dart
class DisplayFileParser {
  static final RegExp _codeRegex = RegExp(r'class (?<name>\w+)(.|\s)*');
  static final RegExp _displayRegex = RegExp(r'@DisplayNode(.|\s)*?\)');

  Future<NodeMeta?> parser() async {
    // 仅处理包含 '_demo' 的文件
    if (!path.contains('_demo')) return null;
    // 仅处理包含 @DisplayNode 注解的文件
    if (!content.contains('@DisplayNode(')) return null;
    // 提取类名、完整源码、注解信息
    return _parserContent(path, content);
  }
}
```

解析规则：
- **文件过滤**：只扫描文件名包含 `_demo` 的 `.dart` 文件
- **注解识别**：通过正则 `@DisplayNode(.|\s)*?\)` 匹配注解块
- **源码提取**：通过正则 `class <name>(.|\s)*` 提取完整类代码
- **代码保存**：调用 `nodeMeta.saveCode()` 将源码写入 `assets/code_res/` 目录

### 4.3 文件生成器

**文件**：`test/toly_ui_gen_tool/file_gen.dart`

`FileGen` 负责生成以下三类文件：

| 生成文件 | 作用 | 数量 |
|---------|------|------|
| `node.g.dart` | 主入口，声明所有 part 文件 + `queryDisplayNodes(name)` 查询函数 | 1 |
| `widget_display_map.g.dart` | 类名 → Widget 实例的 switch 映射 | 1 |
| `<category>.g.dart` | 各分类下 Demo 的 JSON 数据（title/desc/code） | 55 |

生成策略是**基于模板字符串拼接**，将 `displayMap` 中的数据填充到预设模板中。

### 4.4 配置类

**文件**：`test/toly_ui_gen_tool/config_reader.dart`

```dart
class TolyUIGenConfig {
  final String parserDir;   // 扫描源目录
  final String genDistDir;  // 生成目标目录
}
```

---

## 五、生成数据层

### 5.1 目录结构

```
display_nodes/gen/
├── node.g.dart                 # 主入口文件（part声明 + queryDisplayNodes）
├── widget_display_map.g.dart   # Widget→Demo 实例映射
├── action.g.dart               # 动作类组件
├── anchor.g.dart               # 锚点导航组件
├── autocomplete.g.dart         # 自动完成
├── avatar.g.dart               # 头像
├── badge.g.dart                # 徽章
├── breadcrumb.g.dart           # 面包屑
├── button.g.dart               # 按钮
├── card.g.dart                 # 卡片
├── carousel.g.dart             # 走马灯
├── checkbox.g.dart             # 复选框
├── collapse.g.dart             # 折叠面板
├── color.g.dart                # 颜色
├── date_picker.g.dart          # 日期选择
├── default.g.dart              # 默认样式
├── device_frame.g.dart         # 设备框架
├── drop_menu.g.dart            # 下拉菜单
├── icon.g.dart                 # 图标
├── image.g.dart                # 图片
├── input.g.dart                # 输入框
├── layout.g.dart               # 布局
├── link.g.dart                 # 链接
├── loading.g.dart              # 加载
├── message.g.dart              # 消息
├── notification.g.dart         # 通知
├── pagination.g.dart           # 分页
├── phone_frame.g.dart          # 手机框架
├── popover.g.dart              # 弹出框
├── progress.g.dart             # 进度条
├── radio.g.dart                # 单选框
├── rail_menu_bar.g.dart        # 侧边菜单栏
├── rail_menu_tree.g.dart       # 侧边菜单树
├── segmented.g.dart            # 分段器
├── select.g.dart               # 选择器
├── shortcuts.g.dart            # 快捷键
├── skeleton.g.dart             # 骨架屏
├── slider.g.dart               # 滑块
├── slideshow.g.dart            # 轮播图
├── statistics.g.dart           # 统计组件
├── steps.g.dart                # 步骤条
├── stepper.g.dart              # 步进器
├── switch.g.dart               # 开关
├── table.g.dart                # 表格
├── tabs.g.dart                 # 标签页
├── tag.g.dart                  # 标签
├── text.g.dart                 # 文本
├── timeline_new.g.dart         # 时间线
├── tolyui_text.g.dart          # TolyUI 文本
├── tooltip.g.dart              # 工具提示
├── transfer.g.dart             # 穿梭框
├── tree.g.dart                 # 树形控件
└── watermark.g.dart            # 水印
```

共 **55 个分类数据文件**，对应 55 个组件分类。

### 5.2 数据文件格式

每个 `<category>.g.dart` 文件结构如下（以 `button.g.dart` 为例）：

```dart
part of 'node.g.dart';

Map<String, dynamic> get _buttonData => {
  "ButtonDemo1": {
    "title": "填充样式",
    "desc": "按钮的填充样式。通过 FillButtonPalette 调色形成样式...",
    "code": "assets/code_res/button_demo1.txt"
  },
  "ButtonDemo2": {
    "title": "边线样式",
    "desc": "按钮的边线样式...",
    "code": "assets/code_res/button_demo2.txt"
  },
  ...
};
```

每组数据包含：
- **key**：Demo 类名（如 `ButtonDemo1`）
- **title**：从 `@DisplayNode` 注解提取的标题
- **desc**：从注解提取的描述
- **code**：指向 `assets/code_res/` 目录下保存的源码文件

### 5.3 主入口文件

**`node.g.dart`** 通过 `part` 指令组合所有分类文件，并提供运行时的查询入口：

```dart
part 'button.g.dart';
part 'anchor.g.dart';
// ... 52 个 part 声明

Map<String, dynamic> queryDisplayNodes(String name) {
  return switch(name) {
    "button" => _buttonData,
    "anchor" => _anchorData,
    // ... 53 个映射
    _ => {},
  };
}
```

### 5.4 Widget 映射表

**`widget_display_map.g.dart`** 提供类名到 Widget 实例的映射：

```dart
Widget widgetDisplayMap(String key) {
  return switch(key) {
    "ButtonDemo1" => const ButtonDemo1(),
    "ButtonDemo2" => const ButtonDemo2(),
    "AnchorDemo1" => const AnchorDemo1(),
    // ... 约 200+ 个映射
    _ => const SizedBox(),
  };
}
```

这是一个集中式的工厂函数，通过类名字符串返回对应的 Widget 实例，避免使用反射。

---

## 六、UI 展示层

### 6.1 WidgetDisplayPage（展示页面）

**文件**：`lib/view/widgets/widget_display_page/widget_display_page.dart`

```dart
class WidgetDisplayPage extends StatefulWidget {
  final String name;  // 组件分类名，如 "button"、"anchor" 等
}

class _WidgetDisplayPageState extends State<WidgetDisplayPage>
    with AutomaticKeepAliveClientMixin {

  // 保存各组件页面的滚动位置，切换标签时恢复
  static final Map<String, double> _scrollPositions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDisplayNodeList(name: widget.name),   // Demo 列表
          SliverList(delegate: SliverChildListDelegate([
            if (hasPitch(widget.name)) WidgetPitch(name: widget.name),  // 附加说明
            const CooperationPanel(),     // 协作面板
            const LinkPanel(),            // 相关链接
          ])),
        ],
      ),
    );
  }
}
```

**设计特点**：
- 使用 `CustomScrollView` + `Sliver` 实现高性能滚动
- `AutomaticKeepAliveClientMixin` 保留页面状态，避免切换标签时重建
- `_scrollPositions` 静态 Map 记忆每个页面的滚动位置

### 6.2 SliverDisplayNodeList（Demo 列表）

**文件**：`lib/view/widgets/widget_display_page/sliver_display_node_list.dart`

```dart
class SliverDisplayNodeList extends StatelessWidget {
  final String name;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> displayNodes = queryDisplayNodes(name);   // 1. 查询数据
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) => NodeDisplay(
          display: widgetDisplayMap(keys[index]),   // 2. 创建 Widget 实例
          node: Node.fromMap(data[index]),           // 3. 传递元数据
        ),
        childCount: displayNodes.length,
      ),
    );
  }
}
```

**工作流程**：
1. 调用 `queryDisplayNodes(name)` 获取该分类下所有 Demo 的数据 Map
2. 遍历所有 Demo，通过 `widgetDisplayMap(key)` 创建 Widget 实例
3. 通过 `Node.fromMap(map)` 构建元数据对象
4. 组合为 `NodeDisplay` 组件渲染

### 6.3 NodeDisplay（Demo 展示单元）

**文件**：`lib/components/node_display.dart`

```dart
class NodeDisplay extends StatelessWidget {
  final Widget display;   // Demo Widget 实例
  final Node node;        // 元数据（title + desc + code）

  @override
  Widget build(BuildContext context) {
    return Padding$(    // 响应式间距
      child: Column(
        children: [
          TitleShow(title: node.title, desc: node.desc),  // 标题和描述
          CodeDisplay(display: display, code: node.code), // 效果展示+源码
        ],
      ),
    );
  }
}

class TitleShow extends StatelessWidget {
  // 展示 Demo 标题（24px 加粗）和描述（16px 正文）
}
```

**布局结构**：
- `Padding$` 组件根据屏幕断点（xs/sm/md/lg/xl）自适应水平间距
- `TitleShow` 展示标题和描述文本
- `CodeDisplay` 展示 Demo 运行效果 + 可展开查看/复制的源代码

### 6.4 CodeDisplay（代码与效果展示）

**文件**：`lib/components/code_display.dart`

```dart
class CodeDisplay extends StatefulWidget {
  final Widget display;   // Demo 组件
  final String code;      // 源码资源路径

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: ..., borderRadius: ...),
      child: Column(
        children: [
          widget.display,          // 上面：Demo 运行效果
          Divider(),
          TolyCollapse(            // 下面：可折叠的代码区域
            titleBuilder: (ctx, anima, ctrl) => Row(
              children: [
                TolyAction(tooltip: "复制代码", onTap: _copyCode),
                TolyAction(tooltip: "查看代码", onTap: () => _toggleCode(ctrl)),
              ],
            ),
            content: HighlightView(      // 语法高亮显示
              codeRes!, language: 'dart', theme: githubTheme,
            ),
          ),
        ],
      ),
    );
  }
}
```

**功能特点**：
- 上半部分展示 Demo 的实际运行效果
- 下半部分通过 `TolyCollapse` 实现可折叠的源代码展示
- 使用 `flutter_highlight` 进行 Dart 代码语法高亮
- 支持一键复制代码到剪贴板
- 代码采用懒加载策略（展开时才从 assets 加载）

### 6.5 WidgetPitch（组件附加说明）

**文件**：`lib/view/widgets/widget_display_page/widget_pitch.dart`

```dart
bool hasPitch(String name) => ['icon'].contains(name);

class WidgetPitch extends StatelessWidget {
  // 为特定组件（目前仅 icon）提供额外的使用说明
}
```

这是一个扩展点，允许特定组件在 Demo 列表后追加自定义说明内容。当前只有 `icon` 组件使用了此功能。

---

## 七、完整数据流

以下以 Anchor 组件为例，展示从源码到渲染的完整数据流：

```
1. 开发者在 anchor_demo1.dart 中编写 Demo：
   ┌──────────────────────────────────────────────────┐
   │ @DisplayNode(title: '基础用法', desc: '...')      │
   │ class AnchorDemo1 extends StatefulWidget { ... }  │
   └──────────────────────────────────────────────────┘

2. 执行代码生成工具：
   ┌──────────────────────────────────────────────┐
   │ parserDir 扫描 lib/view/widgets/navigation/  │
   │   → 发现 anchor_demo1.dart 包含 @DisplayNode │
   │   → 正则提取类名: AnchorDemo1                │
   │   → 正则提取注解: title='基础用法', desc='...'│
   │   → 正则提取源码: class AnchorDemo1 {...}    │
   │   → saveCode() → assets/code_res/anchor_demo1.txt │
   │   → 构建 NodeMeta 加入 displayMap["anchor"]  │
   └──────────────────────────────────────────────┘

3. FileGen 生成文件：
   ┌──────────────────────────────────────────────┐
   │ anchor.g.dart:                               │
   │   _anchorData = {"AnchorDemo1": {...}, ...}  │
   │                                              │
   │ node.g.dart (更新):                          │
   │   part 'anchor.g.dart';                      │
   │   "anchor" => _anchorData,                   │
   │                                              │
   │ widget_display_map.g.dart (更新):             │
   │   "AnchorDemo1" => const AnchorDemo1(),      │
   └──────────────────────────────────────────────┘

4. 运行时渲染流程：
   ┌──────────────────────────────────────────────┐
   │ WidgetDisplayPage(name: "anchor")            │
   │   → SliverDisplayNodeList(name: "anchor")   │
   │     → queryDisplayNodes("anchor")            │
   │       → 返回 {AnchorDemo1: {title, desc, code}, ...} │
   │     → 遍历每个 Demo:                         │
   │       → widgetDisplayMap("AnchorDemo1")      │
   │         → const AnchorDemo1()                │
   │       → Node.fromMap({title, desc, code})    │
   │     → NodeDisplay(widget: ..., node: ...)   │
   │       → TitleShow(title, desc)               │
   │       → CodeDisplay(display, code)           │
   │         → AnchorDemo1 运行效果                │
   │         → 从 assets 加载源码 + 语法高亮       │
   └──────────────────────────────────────────────┘
```

---

## 八、组件分类统计

| 分类 | 文件数 | 组件类别 |
|------|--------|---------|
| 基本元素 | 5 | color, icon, link, text, tolyui_text |
| 容器布局 | 9 | card, carousel, collapse, default, image, layout, pagination, segmented, skeleton |
| 数据展示 | 7 | progress, statistics, table, tag, timeline_new, tree, watermark |
| 反馈提示 | 6 | loading, message, notification, popover, shortcuts, tooltip |
| 表单输入 | 10 | autocomplete, checkbox, date_picker, input, radio, select, slider, switch, transfer, steps |
| 导航菜单 | 7 | anchor, breadcrumb, drop_menu, rail_menu_bar, rail_menu_tree, stepper, tabs |
| 高级组件 | 5 | action, avatar, badge, button, device_frame, phone_frame |
| 总计 | **55** | 覆盖 200+ 个 Demo |

---

## 九、架构优点

### 9.1 自动化程度高
- 开发者只需在 Demo 类上添加 `@DisplayNode` 注解和对应的描述信息
- 运行代码生成工具即可自动完成所有注册和映射
- 无需手动维护路由表或注册文件

### 9.2 零运行时反射
- 通过代码生成将所有映射关系编译为静态的 `switch` 语句
- 避免 Flutter 中 `dart:mirrors` 限制和性能问题
- `widgetDisplayMap(key)` 直接返回 `const` Widget 实例，性能优秀

### 9.3 代码即文档
- 每个 Demo 同时展示运行效果和完整源代码
- 源码以 assets 资源形式存储，可独立引用
- 语法高亮 + 一键复制，开发者体验好

### 9.4 响应式设计
- 使用 `Padding$` 组件根据屏幕断点自适应间距
- WidgetDisplayPage 使用 `CustomScrollView` + `Sliver` 高效滚动
- 页面状态保持（`AutomaticKeepAliveClientMixin`）和滚动位置记忆

### 9.5 可扩展性强
- 新增组件分类只需添加目录和 Demo 文件，运行生成工具即可
- `WidgetPitch` 机制支持特定组件的附加说明
- `CooperationPanel` + `LinkPanel` 在页面底部提供统一的信息展示

---

## 十、架构图

```
                  ┌─────────────────────────────────┐
                  │    lib/view/widgets/<category>/  │
                  │    xxx_demo.dart                 │
                  │    @DisplayNode(title, desc)     │
                  │    class XxxDemo extends ...     │
                  └───────────────┬─────────────────┘
                                  │
                  ┌───────────────▼─────────────────┐
                  │  test/toly_ui_gen_tool/         │
                  │  ├─ DisplayFileParser           │
                  │  │  正则扫描 _demo 文件           │
                  │  │  提取注解、类名、源码           │
                  │  │  saveCode → assets/code_res/ │
                  │  ├─ FileGen                     │
                  │  │  生成 <cat>.g.dart            │
                  │  │  生成 node.g.dart             │
                  │  │  生成 widget_display_map.g.dart│
                  │  └─ TolyUIGenTool               │
                  │     入口 + 目录遍历               │
                  └───────────────┬─────────────────┘
                                  │
          ┌───────────────────────┼───────────────────────┐
          ▼                       ▼                       ▼
┌─────────────────┐  ┌─────────────────┐  ┌──────────────────────┐
│ <cat>.g.dart    │  │ node.g.dart     │  │ widget_display_map   │
│ (55 files)      │  │ queryDisplayNodes│  │ .g.dart (1 file)     │
│                 │  │ switch(name) {} │  │ widgetDisplayMap(key) │
│ _buttonData     │  │                 │  │ switch(key) {}        │
│ _anchorData     │  │ Part: 55 files  │  │ 200+ Widget映射       │
│ ...             │  │                 │  │                       │
└────────┬────────┘  └────────┬────────┘  └───────────┬───────────┘
         │                    │                        │
         └────────────────────┼────────────────────────┘
                              │ 运行时查询
                              ▼
         ┌─────────────────────────────────────────┐
         │         WidgetDisplayPage                │
         │  ┌─────────────────────────────────┐    │
         │  │  SliverDisplayNodeList           │    │
         │  │  ├─ queryDisplayNodes(name)      │    │
         │  │  ├─ widgetDisplayMap(key)        │    │
         │  │  └─ forEach → NodeDisplay        │    │
         │  │      ├─ TitleShow(title, desc)    │    │
         │  │      └─ CodeDisplay(display,code) │    │
         │  │          ├─ Demo 运行效果          │    │
         │  │          └─ 语法高亮源码           │    │
         │  ├─ WidgetPitch (可选)               │    │
         │  ├─ CooperationPanel                 │    │
         │  └─ LinkPanel                        │    │
         └─────────────────────────────────────────┘
```

---

## 十一、关键文件索引

| 层次 | 文件路径 | 职责 |
|------|---------|------|
| 数据模型 | `lib/view/widgets/display_nodes/display_nodes.dart` | DisplayNode 运行时模型 |
| 数据模型 | `lib/view/widgets/display_nodes/display_meta/display_meta.dart` | NodeMeta 编译时元数据 |
| 代码生成 | `test/toly_ui_gen_tool/toly_ui_gen_tool.dart` | 生成工具入口 |
| 代码生成 | `test/toly_ui_gen_tool/display_file_parser.dart` | Demo 文件解析器 |
| 代码生成 | `test/toly_ui_gen_tool/file_gen.dart` | .g.dart 文件生成器 |
| 代码生成 | `test/toly_ui_gen_tool/display_meta.dart` | 生成工具的元数据模型 |
| 生成数据 | `lib/view/widgets/display_nodes/gen/node.g.dart` | 主入口 + 查询函数 |
| 生成数据 | `lib/view/widgets/display_nodes/gen/widget_display_map.g.dart` | Widget 实例映射 |
| 生成数据 | `lib/view/widgets/display_nodes/gen/*.g.dart` | 55 个分类数据文件 |
| UI 展示 | `lib/view/widgets/widget_display_page/widget_display_page.dart` | 展示页面 |
| UI 展示 | `lib/view/widgets/widget_display_page/sliver_display_node_list.dart` | Demo 列表 |
| UI 展示 | `lib/view/widgets/widget_display_page/widget_pitch.dart` | 组件附加说明 |
| UI 组件 | `lib/components/node_display.dart` | Demo 展示单元 + Node 模型 |
| UI 组件 | `lib/components/code_display.dart` | 代码与效果展示 |

---

## 十二、总结

TolyUI 的展示组件体系是一个设计精巧、高度自动化的组件展示框架。它通过以下机制实现了高效且可维护的组件文档生成：

1. **注解驱动**：`@DisplayNode` 注解使元数据与代码紧密关联
2. **正则解析**：通过正则表达式提取注解信息和源码，无需引入 build_runner 等重型工具链
3. **模板生成**：基于模板字符串拼接生成映射文件，简洁高效
4. **零反射映射**：静态 switch 语句实现 Widget 实例化，性能优异
5. **响应式布局**：适配多端断点的自适应间距和 Sliver 懒加载渲染
6. **代码可视化**：每个 Demo 同时展示效果和源码，配合语法高亮和复制功能

整个体系覆盖 55 个组件分类、200+ 个 Demo，是 TolyUI 组件库文档化和展示能力的核心基础设施。
