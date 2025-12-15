# TolySheet 设计理念

## 一、命名哲学

TolySheet 的命名源于"工作表"（Spreadsheet）的概念，强调数据的流动性和操作的直观性。我们避免使用传统的 DataGrid、Table 等命名，建立独特的概念体系。

### 核心术语

- **Sheet** - 数据表单，而非 Grid 或 Table
- **Field** - 数据字段，而非 Column
- **Pick** - 数据选取，而非 Selection
- **Pin** - 字段固定，而非 Frozen
- **Provider** - 数据提供者，而非 DataSource
- **Strategy** - 行为策略，而非 Configuration
- **Capability** - 字段能力，而非 Feature
- **Spec** - 规格定义，而非 Definition

## 二、架构设计

### 2.1 分层架构

```
┌─────────────────────────────────────┐
│         TolySheet (View)            │  展示层
├─────────────────────────────────────┤
│    SheetController (Control)        │  控制层
├─────────────────────────────────────┤
│   SheetDataProvider (Data)          │  数据层
├─────────────────────────────────────┤
│  Strategy/Capability (Behavior)     │  行为层
└─────────────────────────────────────┘
```

### 2.2 设计模式

**Provider 模式** - 数据层采用 Provider 模式，支持本地/远程/流式数据源，统一数据访问接口。

**Strategy 模式** - 行为配置采用 Strategy 模式，通过组合不同策略实现功能扩展，避免继承层级过深。

**Builder 模式** - 复杂组件采用 Builder 模式构建，提供灵活的定制能力。

**Mixin 组合** - 功能通过 Mixin 组合而非继承，保持代码的扁平化和可维护性。

## 三、核心概念

### 3.1 数据流动

TolySheet 采用响应式数据流设计，数据变化自动触发视图更新：

```dart
SheetDataProvider → Stream<SheetDataSnapshot> → TolySheet → UI
```

数据提供者通过 Stream 发送数据快照，组件监听流变化自动重建。这种设计天然支持异步数据加载、实时数据更新等场景。

### 3.2 字段规格（FieldSpec）

字段规格是 TolySheet 的核心概念，定义了数据如何展示和交互：

- **Header** - 表头配置（标题、图标、提示）
- **Builder** - 单元格构建器（自定义渲染）
- **Constraint** - 约束条件（宽度、对齐、换行）
- **Capability** - 字段能力（排序、过滤、编辑、固定）

字段规格将展示逻辑和交互逻辑解耦，每个字段独立配置，互不干扰。

### 3.3 行为策略（Strategy）

行为策略定义了表格的交互方式，通过组合不同策略实现功能定制：

- **PickStrategy** - 选取策略（单选/多选/范围选择）
- **ScrollStrategy** - 滚动策略（虚拟化/缓冲区）
- **ExpandStrategy** - 展开策略（主从表/嵌套表）
- **EditStrategy** - 编辑策略（单元格编辑/行编辑）
- **GroupStrategy** - 分组策略（数据分组/折叠）

策略之间相互独立，可以自由组合，实现复杂的业务需求。

### 3.4 上下文传递（Context）

TolySheet 通过 Context 对象传递上下文信息，避免回调地狱：

```dart
CellContext {
  data,           // 当前行数据
  rowIndex,       // 行索引
  fieldKey,       // 字段键
  isEditing,      // 编辑状态
  requestEdit,    // 请求编辑
}
```

Context 包含了构建单元格所需的所有信息，Builder 函数签名简洁清晰。

## 四、功能特性

### 4.1 数据管理

**多源支持** - 支持本地数据、远程数据、流式数据，统一接口访问。

**懒加载** - 支持按需加载数据，减少初始加载时间。

**缓存策略** - 内置缓存机制，减少重复请求，提升性能。

**数据转换** - 支持数据排序、过滤、分组等转换操作。

### 4.2 虚拟滚动

采用虚拟滚动技术，只渲染可见区域的数据行，支持百万级数据流畅滚动：

- 视口缓冲区可配置
- 自动计算行高
- 支持动态行高
- 平滑滚动体验

### 4.3 字段固定（Pin）

支持左右固定字段，滚动时固定字段保持可见：

- 左侧固定（常用于序号、选择框）
- 右侧固定（常用于操作列）
- 固定字段层级管理
- 阴影效果提示

### 4.4 数据选取（Pick）

灵活的数据选取机制：

- 单选模式（radio）
- 多选模式（checkbox）
- 范围选择（shift + click）
- 跨页保持选择状态
- 选择验证器

### 4.5 排序与过滤

**多列排序** - 支持同时对多个字段排序，设置优先级。

**内置过滤器** - 提供常用过滤操作符（包含、等于、大于、小于等）。

**自定义过滤** - 支持自定义过滤器 UI 和逻辑。

**即时过滤** - 输入即时生效，无需点击确认。

### 4.6 单元格编辑

**多种编辑器** - 文本、数字、日期、下拉等内置编辑器。

**自定义编辑器** - 支持自定义编辑器组件。

**数据验证** - 内置验证器，支持自定义验证规则。

**编辑模式** - 单元格编辑、行编辑、批量编辑。

### 4.7 行展开

支持主从表格，点击展开查看详细信息：

- 自定义展开内容
- 展开触发方式可配置
- 保持展开状态
- 嵌套展开支持

### 4.8 数据分组

支持按字段分组显示数据：

- 自定义分组逻辑
- 分组头部定制
- 分组折叠/展开
- 分组聚合计算

### 4.9 数据聚合

支持对数据进行聚合计算：

- 求和、平均、最大、最小
- 自定义聚合函数
- 聚合结果显示位置可配置
- 分组聚合支持

### 4.10 导出功能

支持多种格式导出：

- Excel 导出（.xlsx）
- CSV 导出（.csv）
- PDF 导出（.pdf）
- JSON 导出（.json）

## 五、性能优化

### 5.1 虚拟化渲染

只渲染可见区域的数据行，大幅减少 Widget 数量，提升渲染性能。

### 5.2 增量更新

数据变化时只更新受影响的行，避免全量重建。

### 5.3 懒加载

按需加载数据，减少初始加载时间和内存占用。

### 5.4 缓存机制

缓存已加载的数据和计算结果，减少重复计算。

### 5.5 防抖节流

对频繁触发的操作（如滚动、输入）进行防抖节流处理。

## 六、使用示例

### 6.1 基础用法

```dart
TolySheet<User>(
  provider: LocalSheetProvider(data: users),
  fields: [
    FieldSpec(
      key: 'name',
      header: FieldHeader(title: '姓名'),
      builder: (ctx) => Text(ctx.data.name),
    ),
    FieldSpec(
      key: 'age',
      header: FieldHeader(title: '年龄'),
      builder: (ctx) => Text('${ctx.data.age}'),
    ),
  ],
)
```

### 6.2 高级用法

```dart
TolySheet<User>(
  provider: RemoteSheetProvider(
    fetcher: (req) => api.fetchUsers(req),
    cacheStrategy: SheetCacheStrategy(duration: Duration(minutes: 5)),
  ),
  fields: [
    FieldSpec(
      key: 'name',
      header: FieldHeader(title: '姓名'),
      builder: (ctx) => Text(ctx.data.name),
      capability: FieldCapability(
        sortable: SortConfig(multiSort: true),
        filterable: FilterConfig(operator: FilterOperator.contains),
        pinnable: PinConfig(position: PinPosition.left),
      ),
    ),
  ],
  behavior: SheetBehavior(
    pickStrategy: PickStrategy(mode: PickMode.multiple),
    scrollStrategy: ScrollStrategy(enableVirtual: true),
    expandStrategy: ExpandStrategy(
      builder: (data, index) => UserDetailPanel(user: data),
      trigger: ExpandTrigger.icon,
    ),
  ),
  appearance: SheetAppearance(
    layoutMode: LayoutMode.fluid,
    stripedStyle: StripedStyle(color: Colors.grey[50]),
  ),
)
```

## 七、设计原则

### 7.1 声明式优先

采用声明式 API 设计，配置即代码，所见即所得。

### 7.2 组合优于继承

通过组合不同的 Strategy 和 Capability 实现功能扩展，避免继承层级过深。

### 7.3 约定优于配置

提供合理的默认值，常见场景无需额外配置即可使用。

### 7.4 渐进式增强

基础功能开箱即用，高级功能按需启用，学习曲线平缓。

### 7.5 性能优先

内置性能优化机制，大数据场景下保持流畅体验。

## 八、与其他方案的差异

### 8.1 命名体系

完全独立的命名体系，避免与现有方案混淆。

### 8.2 架构模式

采用 Provider + Strategy + Builder 组合，而非传统的配置对象模式。

### 8.3 数据流

基于 Stream 的响应式数据流，而非回调或状态管理。

### 8.4 功能组合

通过 Capability 组合功能，而非通过属性开关控制。

### 8.5 上下文传递

通过 Context 对象传递上下文，而非多参数回调。

## 九、未来规划

- 支持树形表格
- 支持透视表
- 支持图表集成
- 支持协同编辑
- 支持移动端优化
- 支持主题定制
- 支持国际化

---

TolySheet 致力于打造 Flutter 生态中最优雅、最强大的数据表格解决方案。
