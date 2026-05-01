# TolyUI 包结构树

> 更新日期：2026-05-02
> 基于项目源码 modules/ 目录实际结构生成

---

## 总览

```
modules/
├── 📦 tolyui                          # 核心聚合包
├── 📂 basic/                           # 基础组件 (2 packages)
│   ├── 📦 tolyui_rx_layout
│   └── 📦 tolyui_text
├── 📂 form/                            # 表单组件 (2 packages)
│   ├── 📦 toly_check_box
│   └── 📦 tolyui_rich_input
├── 📂 navigation/                      # 导航组件 (1 package)
│   └── 📦 tolyui_navigation
├── 📂 data/                            # 数据展示 (11 packages)
│   ├── 📦 tolyui_carousel
│   ├── 📦 tolyui_collapse
│   ├── 📦 tolyui_default
│   ├── 📦 tolyui_skeleton
│   ├── 📦 tolyui_statistic
│   ├── 📦 tolyui_table
│   ├── 📦 tolyui_tag
│   ├── 📦 tolyui_timeline
│   ├── 📦 tolyui_tree
│   ├── 📦 tolyui_watermark
│   └── 📦 wrapper
├── 📂 feedback/                        # 反馈组件 (3 packages)
│   ├── 📦 tolyui_feedback
│   ├── 📦 tolyui_feedback_modal
│   └── 📦 tolyui_message
├── 📂 advanced/                        # 高级组件 (3 packages)
│   ├── 📦 tolyui_color
│   ├── 📦 tolyui_debug
│   └── 📦 tolyui_refresh
├── 📂 media/                           # 媒体组件 (2 packages)
│   ├── 📦 tolyui_image
│   └── 📦 toly_image_io
├── 📂 core/                            # 核心工具 (1 package)
│   └── 📦 tolyui_meta
└── 📂 publish/                         # 发布工具
    ├── module.dart
    ├── tolyui_0.0.4+6.json
    └── tolyui_0.0.4+7.json

共计：26 个独立 Package
```

---

## 详细包结构

### 📦 tolyui `v0.0.4+16` — 核心聚合包

TolyUI 的顶层入口包。一次 import 即可获得 Button、Link、Card、Pagination、Input、Select、Autocomplete、Transfer、Checkbox 等内置组件，同时统一转导出 tolyui_navigation、tolyui_color、tolyui_statistic、tolyui_rx_layout、tolyui_tree、tolyui_collapse 等子包，是整个组件库的"一站式"依赖。

```
modules/tolyui/
├── lib/
│   ├── tolyui.dart                     # 包入口，统一导出
│   ├── app/
│   │   └── toly_ui.dart                # TolyUiApp 应用壳
│   ├── basic/
│   │   ├── basic.dart                  # 基础组件导出
│   │   ├── button/                     # 按钮组件
│   │   └── link/                       # 链接组件
│   ├── data/
│   │   ├── data.dart                   # 数据组件导出
│   │   ├── card/                       # 卡片组件
│   │   ├── empty/                      # 空状态组件
│   │   └── pagination/                 # 分页组件
│   ├── form/
│   │   ├── form.dart                   # 表单组件导出
│   │   ├── autocomplete/               # 自动补全
│   │   ├── checkbox/                   # 复选框
│   │   ├── input/                      # 输入框
│   │   ├── select/                     # 选择器
│   │   └── transfer/                   # 穿梭框
│   ├── ext/
│   │   └── context.dart                # BuildContext 扩展
│   ├── mixin/
│   │   └── hover_action_mixin.dart     # 悬停交互 Mixin
│   └── res/
│       ├── cons.dart                   # 常量定义
│       └── tolyui_icon.dart            # 图标字体
├── assets/
│   └── iconfont/
│       └── tolyui_icon.ttf             # 图标字体文件
├── doc/
│   ├── changelog.json
│   └── screen/
│       └── display.webp                # 展示截图
├── test/
│   └── tolyui_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 basic/ — 基础组件

#### 📦 tolyui_rx_layout `v1.0.0+1`

响应式布局引擎。提供 `Row$` / `Cell` 栅格系统（支持 gutter、offset、push/pull）、`Size$` / `Padding$` 响应式尺寸包装器，以及 `WindowRespondBuilder` 断点构建器。通过 `RxParserStrategy` 可自定义 xs/sm/md/lg/xl 断点阈值，是 TolyUI 全平台适配的基石。

```
modules/basic/tolyui_rx_layout/
├── lib/
│   ├── tolyui_rx_layout.dart           # 包入口
│   └── src/                            # 响应式布局实现
├── doc/
│   └── changelog.json
├── test/
│   └── tolyui_rx_layout_test.dart
├── main.dart                           # 示例入口
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_text `v0.0.1+5`

基于正则的文本高亮组件。核心类 `HighlightText` 接受一组 `Rule`（正则 → 样式映射），自动对匹配文本着色并支持点击回调。内置智能冲突消解：重叠匹配时长文本优先、同长度靠前优先。`HighlightText.withArg` 提供快捷搜索高亮。

```
modules/basic/tolyui_text/
├── lib/
│   ├── tolyui_text.dart                # 包入口
│   └── src/                            # 文本组件实现
├── doc/
│   └── HighlightText组件介绍.md         # 高亮文本组件文档
├── test/
│   └── tolyui_text_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 form/ — 表单组件

#### 📦 toly_check_box `v0.0.1`

自定义复选框组件。支持选中、未选中、半选（indeterminate）三态，带桌面端悬停效果和禁用态。可配置尺寸、圆角、标签文字及间距。

```
modules/form/toly_check_box/
├── lib/
│   ├── toly_check_box.dart             # 包入口
│   └── src/                            # 复选框实现
├── test/
│   └── toly_check_box_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_rich_input `v1.0.0`

富文本输入组件，基于 flutter_quill 封装。支持图片、表情、文件等富媒体内容的嵌入式编辑，提供 TolyUI 风格的编辑器外观。附带完整的多平台示例应用。

```
modules/form/tolyui_rich_input/
├── lib/
│   ├── tolyui_rich_input.dart          # 包入口
│   └── src/                            # 富文本输入实现
├── example/                            # 完整示例应用
│   ├── lib/
│   ├── android/ ios/ linux/ macos/ web/ windows/
│   ├── pubspec.yaml
│   └── pubspec.lock
├── test/
│   └── tolyui_rich_input_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 navigation/ — 导航组件

#### 📦 tolyui_navigation `v0.2.0+5`

导航组件套件，涵盖五大导航模式：`TolyBreadcrumb`（面包屑）、`DropMenu`（下拉菜单，含样式/Mixin/碰撞检测）、`RailMenuTree`（树形侧边栏菜单）、`RailMenuBar`（轨道菜单栏）、`TolyTabs` / `FlutterTabBar`（标签页）。内部依赖 `tolyui_meta` 提供 `MenuMeta` / `DisplayMeta` 数据模型。

```
modules/navigation/tolyui_navigation/
├── lib/
│   ├── tolyui_navigation.dart          # 包入口
│   └── src/
│       ├── breadcrumb/                 # 面包屑导航
│       ├── drop_menu/                  # 下拉菜单
│       ├── rail_menu_tree/             # 侧边栏树形菜单
│       ├── tabs/                       # 标签页
│       ├── model/                      # 数据模型
│       └── view/                       # 通用视图
├── doc/
│   └── changelog.json
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 data/ — 数据展示组件

#### 📦 tolyui_carousel `v0.0.1`

轮播图组件。支持水平/垂直滚动、滚动与淡入两种过渡效果、自动播放（可配间隔）、无限循环、圆点指示器（可自定义位置和样式），以及通过 GlobalKey 进行 goTo/next/prev 编程控制。

```
modules/data/tolyui_carousel/
├── lib/
│   ├── tolyui_carousel.dart
│   └── src/
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_collapse `v0.0.1`

折叠面板 / 手风琴组件。支持展开收起动画，适用于 FAQ、分组内容等需要折叠展示的场景。

```
modules/data/tolyui_collapse/
├── lib/
│   ├── tolyui_collapse.dart
│   └── src/
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_default `v0.0.1`

缺省页 / 空状态组件。内置 6 种预设类型：empty（无数据）、noResult（无结果）、networkError（网络错误）、noPermission（无权限）、notFound（404）、serverError（服务器错误）。支持自定义图标/图片、标题、描述、操作按钮，以及通过 `DefaultThemeScope` 全局定制主题。

```
modules/data/tolyui_default/
├── lib/
│   ├── tolyui_default.dart
│   └── src/
├── test/
│   └── toly_default_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_skeleton `v0.0.1`

骨架屏加载占位组件。提供 `TolySkeleton`（通用骨架）、`SkeletonButton`、`SkeletonAvatar`、`SkeletonInput`、`SkeletonImage` 等变体，用于在数据加载期间展示内容轮廓，提升感知性能。

```
modules/data/tolyui_skeleton/
├── lib/
│   ├── tolyui_skeleton.dart
│   └── src/
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_statistic `v0.0.1`

数据统计展示组件。`Statistic` 用于格式化展示数值（支持精度、千分位、前缀/后缀）；`StatisticTimer` 提供倒计时和正计时功能，支持 Y/M/D/H/m/s/S 格式模板及 onFinish/onChange 回调。

```
modules/data/tolyui_statistic/
├── lib/
│   ├── tolyui_statistic.dart
│   └── src/
├── example/
│   └── main.dart
├── test/
│   └── tolyui_statistic_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_table `v0.0.1`

表格与电子表格组件。包含基础版 `TolyTable` 和新版 `TolyTableNew`，以及底层 Sheet 系统（`TolySheet` + `SheetController` + `DataProvider` + `FieldSpec`），支持列定义、数据绑定和滚动控制。附带迁移指南和设计文档。

```
modules/data/tolyui_table/
├── lib/
│   ├── tolyui_table.dart
│   └── src/
│       ├── toly_table.dart             # 表格组件
│       ├── toly_table_new.dart         # 新版表格
│       └── sheet/                      # 表格内部实现
├── doc/
│   ├── migration_guide.md              # 迁移指南
│   └── tolysheet_design.md             # 设计文档
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_tag `v0.0.1`

标签组件。提供三种样式变体（filled 填充、solid 实色、outlined 描边），支持可关闭（带动画）、图标、禁用态。`CheckableTag` 支持选中/取消切换，`CheckableTagGroup` 支持单选和多选模式。完整的 `TagTheme` 主题系统和悬停动效。

```
modules/data/tolyui_tag/
├── lib/
│   ├── tolyui_tag.dart
│   └── src/
├── doc/
│   └── leading_distribution_explained.md
├── test/
│   └── tolyui_tag_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_timeline `v0.0.1`

时间线组件。用于按时间顺序展示事件流，适用于操作日志、流程进度等场景。

```
modules/data/tolyui_timeline/
├── lib/
│   ├── tolyui_timeline.dart
│   └── src/
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_tree `v0.0.1`

树形控件，用于展示层级数据。核心能力：展开/收起动画、三态复选框（父子联动自动计算）、异步懒加载子节点、虚拟滚动（大数据量）、连接线绘制。额外提供 `TolyDraggableTree`（可拖拽排序）和 `TolyTreeSelector`（树选择器）。

```
modules/data/tolyui_tree/
├── lib/
│   ├── toly_tree.dart
│   └── src/
│       ├── toly_tree.dart              # 树形控件
│       ├── toly_tree_selector.dart     # 树选择器
│       ├── toly_draggable_tree.dart    # 可拖拽树
│       └── tree_line_painter.dart      # 连线绘制
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_watermark `v0.0.1`

水印覆盖组件。在内容上方叠加半透明文字/图案水印，用于版权保护或文档标记。

```
modules/data/tolyui_watermark/
├── lib/
│   ├── tolyui_watermark.dart
│   └── src/
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 wrapper `v1.0.2`

气泡 / 对话框形状容器。通过 CustomPaint 绘制带"尖角"（spine）的圆角矩形，尖角可置于上下左右任意方向。支持配置角度、高度、偏移、阴影/投影、描边模式，以及通过 `spinePathBuilder` 自定义尖角路径。`Wrapper.just` 提供无尖角的纯圆角盒子。

```
modules/data/wrapper/
├── lib/
│   └── wrapper.dart
├── example/
│   └── main.dart
├── test/
│   └── wrapper_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 feedback/ — 反馈组件

#### 📦 tolyui_feedback `v0.3.6+9`

反馈交互组件集合，是 TolyUI 反馈层的核心包。包含：`TolyTooltip`（悬停气泡提示，支持多方向定位和气泡装饰）、`TolyPopover`（智能弹出框，带控制器模式和碰撞检测）、`BubbleDecoration`（气泡装饰绘制器）、`TolyPopPicker`（移动端底部弹出选择器）。同时转导出 tolyui_message。

```
modules/feedback/tolyui_feedback/
├── lib/
│   ├── tolyui_feedback.dart            # 包入口
│   ├── decoration/
│   │   └── bubble_decoration.dart      # 气泡装饰
│   ├── mobile/
│   │   └── toly_pop_picker/            # 移动端弹出选择器
│   ├── toly_popover/
│   │   ├── toly_popover.dart           # Popover 入口
│   │   ├── logic/                      # 逻辑层
│   │   ├── model/                      # 数据模型
│   │   └── view/                       # 视图层
│   └── toly_tooltip/
│       ├── toly_tooltip.dart           # Tooltip 组件
│       ├── algorithm.dart              # 定位算法
│       ├── position_delegate.dart      # 位置代理
│       └── tooltip_placement.dart      # 放置策略
├── doc/
│   └── changelog.json
├── example/                            # 完整示例应用
│   ├── lib/
│   ├── android/ ios/ linux/ macos/ web/ windows/
│   └── pubspec.yaml
├── test/
│   └── tolyui_feedback_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_feedback_modal `v0.0.1`

异步任务模态选择器。底部弹出式 Picker，内置异步任务执行与状态监控（Loading → Success / Failure / Timeout），支持超时自动取消（默认 5 秒）、亮色/暗色主题预设、泛型数据类型，以及桌面端和移动端双布局适配。

```
modules/feedback/tolyui_feedback_modal/
├── lib/
│   ├── tolyui_feedback_modal.dart
│   └── src/
├── example/                            # 完整示例应用
│   ├── lib/
│   ├── android/ ios/ linux/ macos/ web/ windows/
│   └── pubspec.yaml
├── test/
│   └── tolyui_feedback_modal_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_message `v0.2.6+1`

全局消息与通知系统。使用 `TolyMessage(child: MyApp())` 包裹应用后，即可在任意位置调用 Toast 消息、通知弹窗和加载指示器。支持多位置定位、主题定制（`TolyMessageShowTheme` / `TolyMessageStyleTheme`）和基于任务的消息流。

```
modules/feedback/tolyui_message/
├── lib/
│   ├── tolyui_message.dart             # 包入口
│   └── src/
│       ├── logic/                      # 消息逻辑
│       ├── model/                      # 消息模型
│       └── widget/                     # 消息组件
├── doc/
│   └── changelog.json
├── test/
│   └── tolyui_message_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 advanced/ — 高级组件

#### 📦 tolyui_color `v0.0.2`

调色板组件。提供 `RGBColorPainter`（RGB 渐变色板绘制）和 `TolyHuePanel`（色相选择面板），用于颜色选取和展示场景。

```
modules/advanced/tolyui_color/
├── lib/
│   ├── tolyui_color.dart
│   └── src/
│       └── painter/                    # 颜色绘制器
├── doc/
│   └── changelog.json
├── test/
│   └── toly_color_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_debug `v0.0.1`

调试与设备模拟组件。核心组件 `DeviceFrame` 将内容包裹在手机外观框架中（含刘海模拟），适用于 Web 端展示移动端效果。支持自定义宽高、像素密度、边框颜色、圆角和刘海尺寸。另含 `DebugConstraintsDisplay` 约束调试工具。

```
modules/advanced/tolyui_debug/
├── lib/
│   ├── tolyui_debug.dart
│   └── src/
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 tolyui_refresh `v0.0.1+1`

下拉刷新与上拉加载组件。提供 `RefreshController` 控制器、状态模型和可定制的刷新指示器，简化列表的刷新/加载更多交互。附带完整的多平台示例应用。

```
modules/advanced/tolyui_refresh/
├── lib/
│   ├── tolyui_refresh.dart
│   └── src/
├── example/                            # 完整示例应用
│   ├── lib/
│   ├── android/ ios/ linux/ macos/ web/ windows/
│   └── pubspec.yaml
├── test/
│   └── tolyui_refresh_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 media/ — 媒体组件

#### 📦 tolyui_image `v0.0.1+2`

全功能图片组件。支持网络/文件/内存/Asset 四种图片源，手势操作（双指缩放、平移、双击、鼠标滚轮），图片编辑（裁剪、旋转、翻转、撤销/重做），智能缓存（内存 + 磁盘，可配最大时长），以及滑动翻页和边框装饰。跨平台支持 iOS、Android、Web、Desktop。

```
modules/media/tolyui_image/
├── lib/
│   ├── tolyui_image.dart
│   └── src/
├── test/
│   └── tolyui_image_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

#### 📦 toly_image_io `v0.0.1`

图片 I/O 工具包。当前为脚手架状态，尚未实现具体功能，预留用于图片的读写与格式转换。

```
modules/media/toly_image_io/
├── lib/
│   └── toly_image_io.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 core/ — 核心工具

#### 📦 tolyui_meta `v0.0.2+1`

TolyUI 的基础元数据层。定义 `MenuMeta`、`MenuNode` 等菜单数据模型和核心工具类，被 tolyui_navigation 等上层包依赖。是组件库共享数据结构的基石。

```
modules/core/tolyui_meta/
├── lib/
│   ├── tolyui_meta.dart
│   └── src/
├── test/
│   └── tolyui_meta_test.dart
├── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

### 📂 publish/ — 发布工具

自动化批量发布脚本，遍历 modules/ 下所有包执行 `dart pub publish`，附带版本配置快照。

```
modules/publish/
├── module.dart                         # 模块发布脚本
├── tolyui_0.0.4+6.json                # 发布配置快照
└── tolyui_0.0.4+7.json                # 发布配置快照
```

---

## 版本汇总

| # | 包名 | 版本 | 分类 | 说明 |
|---|------|------|------|------|
| 1 | `tolyui` | 0.0.4+16 | 核心 | 聚合包，一次导入所有基础组件 |
| 2 | `tolyui_rx_layout` | 1.0.0+1 | 基础 | 响应式栅格布局引擎 |
| 3 | `tolyui_text` | 0.0.1+5 | 基础 | 正则文本高亮组件 |
| 4 | `toly_check_box` | 0.0.1 | 表单 | 三态复选框 |
| 5 | `tolyui_rich_input` | 1.0.0 | 表单 | 富文本输入（基于 flutter_quill） |
| 6 | `tolyui_navigation` | 0.2.0+5 | 导航 | 面包屑、下拉菜单、树形菜单、标签页 |
| 7 | `tolyui_carousel` | 0.0.1 | 数据 | 轮播图（自动播放、无限循环） |
| 8 | `tolyui_collapse` | 0.0.1 | 数据 | 折叠面板 / 手风琴 |
| 9 | `tolyui_default` | 0.0.1 | 数据 | 缺省空状态（6 种预设类型） |
| 10 | `tolyui_skeleton` | 0.0.1 | 数据 | 骨架屏加载占位 |
| 11 | `tolyui_statistic` | 0.0.1 | 数据 | 数值统计与倒计时 |
| 12 | `tolyui_table` | 0.0.1 | 数据 | 表格与 Sheet 系统 |
| 13 | `tolyui_tag` | 0.0.1 | 数据 | 标签（三种样式、可选中） |
| 14 | `tolyui_timeline` | 0.0.1 | 数据 | 时间线 |
| 15 | `tolyui_tree` | 0.0.1 | 数据 | 树形控件（虚拟滚动、拖拽） |
| 16 | `tolyui_watermark` | 0.0.1 | 数据 | 水印覆盖 |
| 17 | `wrapper` | 1.0.2 | 数据 | 气泡形状容器（可配尖角） |
| 18 | `tolyui_feedback` | 0.3.6+9 | 反馈 | Tooltip、Popover、气泡装饰 |
| 19 | `tolyui_feedback_modal` | 0.0.1 | 反馈 | 异步任务模态选择器 |
| 20 | `tolyui_message` | 0.2.6+1 | 反馈 | 全局 Toast 消息与通知 |
| 21 | `tolyui_color` | 0.0.2 | 高级 | 调色板（RGB + 色相面板） |
| 22 | `tolyui_debug` | 0.0.1 | 高级 | 设备框架模拟器 |
| 23 | `tolyui_refresh` | 0.0.1+1 | 高级 | 下拉刷新 / 上拉加载 |
| 24 | `tolyui_image` | 0.0.1+2 | 媒体 | 全功能图片（手势、编辑、缓存） |
| 25 | `toly_image_io` | 0.0.1 | 媒体 | 图片 I/O（脚手架） |
| 26 | `tolyui_meta` | 0.0.2+1 | 核心 | 菜单元数据模型 |
