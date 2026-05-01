# TolyUI 项目汇报

> 汇报日期：2026-05-02
> 项目仓库：[TolyFx/toly_ui](https://github.com/TolyFx/toly_ui)
> 在线演示：[http://toly1994.com/ui](http://toly1994.com/ui)
> 开源协议：MIT

---

## 一、项目概述

**TolyUI** 是一个面向 Flutter 全平台的现代化响应式 UI 组件库，由张风捷特烈（toly）主导开发。项目采用 **Monorepo + 模块化** 架构，将 UI 组件拆分为可独立发布的 Flutter Package，同时提供一个交互式展示应用（Showcase App）用于组件的在线预览与文档查阅。

### 核心定位

| 维度 | 说明 |
|------|------|
| 目标用户 | Flutter 开发者 |
| 产品形态 | 组件库（pub.dev 发布）+ 展示应用（Web/桌面/移动端） |
| 设计理念 | 模块化、按需引入、响应式、类型安全 |
| 当前版本 | 展示应用 v1.0.0 / 核心库 tolyui v0.0.4+16 |

---

## 二、技术栈

| 类别 | 技术选型 | 版本 |
|------|---------|------|
| 框架 | Flutter / Dart | SDK ≥3.3.0 |
| 状态管理 | flutter_bloc (Cubit) | ^8.1.5 |
| 路由 | go_router | ^13.2.3 |
| 代码高亮 | flutter_highlight | ^0.7.0 |
| SVG 渲染 | flutter_svg | ^2.0.10+1 |
| 数据表格 | syncfusion_flutter_datagrid | ^27.1.58 |
| 消息提示 | oktoast | ^3.4.0 |
| URL 跳转 | url_launcher | ^6.2.5 |
| 国际化 | intl | ^0.19.0 |
| 应用启动 | app_boot_starter | ^1.0.0 |
| 设计规范 | Material Design 3 | — |

---

## 三、架构设计

### 3.1 整体架构

```
┌─────────────────────────────────────────────────────┐
│                   展示应用 (toly_ui)                  │
│  ┌──────────┐  ┌──────────┐  ┌───────────────────┐  │
│  │ 首页     │  │ 组件展示  │  │ 生态/赞助/指南    │  │
│  └──────────┘  └──────────┘  └───────────────────┘  │
│  ┌──────────────────────────────────────────────┐   │
│  │         导航层 (GoRouter + ShellRoute)         │   │
│  └──────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────┐   │
│  │         状态层 (BLoC / Cubit)                  │   │
│  └──────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────┤
│              组件库 modules/ (独立 Package)           │
│  ┌────────┐ ┌────────┐ ┌──────────┐ ┌───────────┐  │
│  │ basic  │ │  form  │ │navigation│ │   data     │  │
│  ├────────┤ ├────────┤ ├──────────┤ ├───────────┤  │
│  │feedback│ │advanced│ │  media   │ │   core     │  │
│  └────────┘ └────────┘ └──────────┘ └───────────┘  │
└─────────────────────────────────────────────────────┘
```

### 3.2 状态管理

采用 **BLoC (Cubit)** 模式，当前全局状态较轻量：

- `AppLogic`（Cubit）：管理主题模式（亮色/暗色切换）
- `AppState`（Equatable）：不可变状态对象，支持 `copyWith`
- `AppScope`：通过 `MultiBlocProvider` 注入全局依赖

### 3.3 路由体系

基于 `GoRouter` 的声明式路由，采用 `ShellRoute` 实现持久化导航布局：

```
/                    → 重定向至 /home
├── /home            → 首页（项目介绍、功能概览）
├── /guide/*         → 使用指南
├── /widgets/*       → 组件展示（核心页面）
│   ├── /basic/*     → 基础组件
│   ├── /form/*      → 表单组件
│   ├── /navigation/*→ 导航组件
│   ├── /data/*      → 数据展示
│   ├── /feedback/*  → 反馈组件
│   └── /advanced/*  → 高级组件
├── /sponsor         → 赞助页
├── /ecological      → 生态页
└── /404             → 错误页
```

### 3.4 响应式策略

自定义断点系统（`Rx` 枚举）：

| 断点 | 宽度范围 | 适用场景 |
|------|---------|---------|
| xs | < 768px | 手机竖屏 |
| sm | 768–991px | 平板竖屏 |
| md | 992–1199px | 平板横屏 |
| lg | 1200–1919px | 桌面端 |
| xl | ≥ 1920px | 大屏桌面 |

---

## 四、模块清单

### 4.1 组件库模块（modules/）

| 分类 | 模块名 | 说明 |
|------|--------|------|
| **核心** | `tolyui` | 聚合包，整合所有基础组件 |
| **基础** | `tolyui_rx_layout` | 响应式布局 |
| | `tolyui_text` | 文本组件 |
| **表单** | `tolyui_rich_input` | 富文本输入 |
| | `toly_check_box` | 复选框 |
| **导航** | `tolyui_navigation` | 菜单、面包屑、标签页等 |
| **数据展示** | `tolyui_carousel` | 轮播图 |
| | `tolyui_collapse` | 折叠面板 |
| | `tolyui_default` | 缺省页 |
| | `tolyui_skeleton` | 骨架屏 |
| | `tolyui_statistic` | 数据统计 |
| | `tolyui_table` | 表格 |
| | `tolyui_tag` | 标签 |
| | `tolyui_timeline` | 时间线 |
| | `tolyui_tree` | 树形控件 |
| | `tolyui_watermark` | 水印 |
| | `wrapper` | 包装器工具 |
| **反馈** | `tolyui_feedback` | 反馈组件集合 |
| | `tolyui_feedback_modal` | 模态反馈 |
| | `tolyui_message` | 消息提示 |
| **高级** | `tolyui_color` | 调色板 |
| | `tolyui_debug` | 调试工具 |
| | `tolyui_refresh` | 刷新组件 |
| **媒体** | `media` | 图片等媒体处理 |
| **工具** | `publish` | 自动化发布脚本 |

### 4.2 展示应用组件覆盖（lib/view/widgets/）

| 分类 | 已实现组件 | 数量 |
|------|-----------|------|
| Basic 基础 | Button, Icon, Text, TolyUI Text, Link, Layout, Action | 7 |
| Form 表单 | Input, Select, Checkbox, Radio, Switch, Slider, DatePicker, Autocomplete, Transfer | 9 |
| Navigation 导航 | Tabs, Stepper, Breadcrumb, DropMenu, RailMenuBar, RailMenuTree | 6 |
| Data 数据展示 | Tree, Table, Tag, Card, Carousel, Collapse, Avatar, Badge, Progress, Pagination, Skeleton, Image, Segmented, Statistics, Timeline, Timeline(new), Watermark, Default | 18 |
| Feedback 反馈 | Message, Notification, Loading, Tooltip, Popover, Shortcuts | 6 |
| Advanced 高级 | Color, DeviceFrame | 2 |
| **合计** | | **48** |

---

## 五、项目目录结构

```
toly_ui/
├── lib/                          # 展示应用源码
│   ├── main.dart                 # 入口文件
│   ├── app/                      # 应用配置
│   │   ├── logic/                # 状态管理（BLoC）
│   │   ├── theme/                # 主题定义（亮色/暗色）
│   │   ├── res/                  # 资源（图标字体）
│   │   ├── utils/                # 工具类
│   │   └── view/                 # AppScope 依赖注入
│   ├── view/                     # 页面视图
│   │   ├── home_page/            # 首页
│   │   ├── widgets/              # 组件展示（核心）
│   │   ├── ecological/           # 生态页
│   │   ├── sponsor/              # 赞助页
│   │   ├── guide/                # 指南页
│   │   └── debugger/             # 调试页
│   ├── navigation/               # 导航系统
│   │   ├── router/               # GoRouter 路由配置
│   │   ├── menu/                 # 菜单数据定义
│   │   └── view/                 # 导航 UI 组件
│   ├── components/               # 通用组件
│   │   ├── code_display.dart     # 代码展示器
│   │   └── node_display.dart     # 节点展示器
│   └── incubator/                # 实验性功能
├── modules/                      # 独立组件库（可发布）
│   ├── tolyui/                   # 核心聚合包
│   ├── basic/                    # 基础组件
│   ├── form/                     # 表单组件
│   ├── navigation/               # 导航组件
│   ├── data/                     # 数据展示组件
│   ├── feedback/                 # 反馈组件
│   ├── advanced/                 # 高级组件
│   ├── media/                    # 媒体组件
│   ├── core/                     # 核心工具
│   └── publish/                  # 发布工具
├── assets/                       # 静态资源
│   ├── code_res/                 # 代码示例文件（212 个）
│   ├── images/                   # 图片资源
│   ├── fonts/                    # 字体文件
│   ├── iconfont/                 # 图标字体
│   └── data/                     # 数据文件
├── doc/                          # 文档
├── android/                      # Android 平台配置
├── ios/                          # iOS 平台配置
└── pubspec.yaml                  # 项目依赖配置
```

---

## 六、核心特性

### 6.1 组件展示系统

- **@DisplayNode 注解**：通过注解标记组件示例，自动发现并渲染
- **代码展示器**：集成语法高亮、一键复制、折叠展开
- **资源加载**：212 个代码示例文件，按需从 assets 加载
- **响应式网格**：组件展示页面自适应不同屏幕尺寸

### 6.2 主题系统

- 完整的亮色/暗色主题定义
- Material Design 3 支持
- 平台自适应页面过渡动画（移动端滑动、桌面端淡入）
- 自定义消息样式主题扩展

### 6.3 开发工具链

- `toly ui` CLI 命令：生成路由和代码资源
- `publish.dart` 脚本：自动化批量发布模块到 pub.dev
- 热重载支持：路由状态在热重载时自动保持

---

## 七、项目亮点与评价

### 优势

1. **模块化程度高**：每个组件独立为 Package，可按需引入，降低应用体积
2. **组件覆盖面广**：6 大分类、48 个组件，覆盖常见 UI 场景
3. **展示体验好**：交互式在线演示，代码与效果对照，开发者友好
4. **响应式设计**：5 级断点适配，支持手机到大屏桌面全场景
5. **架构清晰**：BLoC 状态管理 + GoRouter 声明式路由，职责分明
6. **自动化工具**：CLI 代码生成 + 批量发布脚本，提升开发效率

### 待改进方向

1. **状态管理较轻量**：当前仅管理主题模式，随功能增长可能需要扩展
2. **部分模块版本较低**：核心库 tolyui 仍为 0.0.x 阶段，API 稳定性待验证
3. **测试覆盖**：未见完善的单元测试和集成测试体系
4. **国际化**：已引入 intl 依赖，但多语言支持尚未全面落地
5. **文档体系**：有集成指南和分析文档，但组件级 API 文档可进一步完善

---

## 八、总结

TolyUI 是一个设计精良、架构清晰的 Flutter 全平台 UI 组件库项目。通过 Monorepo 模块化架构实现了组件的独立开发与发布，展示应用提供了优秀的交互式文档体验。项目已覆盖 48 个常用 UI 组件，具备响应式布局、主题切换、代码展示等完整功能。

作为一个活跃开发中的开源项目，TolyUI 在 Flutter 社区中具有良好的实用价值和参考意义。后续可重点关注 API 稳定性、测试覆盖率和文档完善度的提升。

---

*本报告基于项目源码分析自动生成，如有疑问请联系项目维护者。*
