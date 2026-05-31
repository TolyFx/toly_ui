# tolyui_feedback v0.0.4 重构建议

> 日期：2026-05-02
> 基于 v0.3.6+9 源码审查

---

## 一、需立即修复的问题

### 1.1 algorithm.dart 引入了 `dart:io`

文件中没有任何地方使用 `dart:io`，但这个 import 会导致 Web 平台编译失败。直接删除。

```dart
// ❌ 删除这行
import 'dart:io';
```

### 1.2 `decration.dart` 文件名拼写错误

```
toly_popover/view/decration.dart  →  toly_popover/view/decoration.dart
```

发布后改文件名会破坏用户的 import 路径，趁 0.0.4 之前改掉。

### 1.3 注释乱码

`toly_tooltip.dart` 的 `TolyTooltip` 构造函数文档注释中有残留乱码：

```dart
// ❌ 第 178-179 行附近
///  \bv,m,
///  |
```

直接删除。

### 1.4 `_PopOverlay` 中的 `if(true)` 死代码

```dart
// ❌ _pop_overlay.dart
if(true){
   result = FadeTransition(
      opacity: widget.animation,
      child: result);
}

// ✅ 改为
result = FadeTransition(
  opacity: widget.animation,
  child: result,
);
```

---

## 二、代码组织重构

### 2.1 当前结构的问题

```
lib/
├── decoration/          # 按技术层分
├── mobile/              # 按平台分
├── toly_popover/        # 按组件分
├── toly_tooltip/        # 按组件分
└── tolyui_feedback.dart
```

分类维度不统一。`decoration` 是技术层，`mobile` 是平台，`toly_popover` 和 `toly_tooltip` 是组件。新增组件时没有明确的归属规则。

更深层的问题：`toly_popover` 反向依赖 `toly_tooltip` 的 `position_delegate.dart` 和 `tooltip_placement.dart`，说明有一层共享基础设施没有被显式提取。

### 2.2 建议的目录结构

```
lib/
├── src/
│   ├── core/                          # 共享基础设施（新增）
│   │   ├── placement.dart             # Placement 枚举
│   │   ├── placement_shift.dart       # PlacementShift
│   │   ├── overflow_algorithm.dart    # OverflowEdge + defaultOverflowAlgorithm
│   │   ├── position_delegate.dart     # PopoverPositionDelegate
│   │   └── types.dart                 # Calculator, OffsetCalculator 等公共类型
│   ├── decoration/                    # 装饰层（重组）
│   │   ├── bubble_decoration.dart     # BubbleDecoration + BubbleBoxPainter
│   │   ├── bubble_meta.dart           # BubbleMeta（从 bubble_decoration.dart 提取）
│   │   ├── decoration_config.dart     # DecorationConfig（从 toly_tooltip.dart 提取）
│   │   └── default_decoration.dart    # defaultDecorationBuilder（从 decration.dart 迁移）
│   ├── tooltip/                       # Tooltip 组件
│   │   ├── toly_tooltip.dart          # TolyTooltip + TolyTooltipState
│   │   ├── tooltip_overlay.dart       # _TooltipOverlay + State（从大文件拆出）
│   │   └── exclusive_mouse_region.dart # _ExclusiveMouseRegion（从大文件拆出）
│   ├── popover/                       # Popover 组件
│   │   ├── toly_popover.dart          # TolyPopover + State
│   │   ├── popover_controller.dart    # PopoverController（独立文件，不用 part）
│   │   ├── popover_delegate.dart      # PopoverDelegate 接口（新增）
│   │   ├── pop_overlay.dart           # _PopOverlay
│   │   └── auto_dismiss_mixin.dart    # PopHideMixin（重命名，职责更清晰）
│   └── picker/                        # Picker 组件（原 mobile/，按语义重命名）
│       ├── toly_pop_picker.dart
│       └── toly_pop_picker_theme.dart
└── tolyui_feedback.dart               # 入口，只做 export
```

核心变化：

- **提取 `core/`**：Placement、溢出算法、定位代理是 Tooltip 和 Popover 共享的，不应放在 `toly_tooltip/` 下
- **`decoration/` 独立**：DecorationConfig 从 1061 行的 toly_tooltip.dart 中提取出来
- **`picker/` 替代 `mobile/`**：按组件语义命名，Picker 未来也可能支持桌面端
- **消除 `part of`**：PopoverController 独立为文件

---

## 三、设计模式改进

### 3.1 Controller 接口化

当前 `PopoverController` 直接持有 `_TolyPopoverState?` 引用，通过 `part of` 访问私有成员：

```dart
// ❌ 当前实现
class PopoverController {
  _TolyPopoverState? _state;
  bool get isOpen => _state!._isOpen;       // 直接访问私有成员
  void open() => _state!._open();           // assert 在 release 下不执行
}
```

问题：
- 紧耦合，Controller 和 State 无法独立演进
- 不可 mock，无法单独测试 Controller
- release 模式下 `_state` 为 null 时静默崩溃

建议引入内部接口：

```dart
// ✅ 建议实现
abstract class PopoverDelegate {
  bool get isOpen;
  void open({Offset? position});
  void close();
}

class PopoverController {
  PopoverDelegate? _delegate;

  bool get isOpen => _delegate?.isOpen ?? false;

  void open({Offset? position}) {
    if (_delegate == null) {
      throw StateError('PopoverController is not attached to a TolyPopover');
    }
    _delegate!.open(position: position);
  }

  void close() => _delegate?.close();

  void _attach(PopoverDelegate d) => _delegate = d;
  void _detach(PopoverDelegate d) {
    if (_delegate == d) _delegate = null;
  }
}

// State 实现接口
class _TolyPopoverState extends State<TolyPopover>
    implements PopoverDelegate { ... }
```

收益：
- Controller 可独立单元测试（mock delegate）
- release 模式下有明确的错误信息
- 消除 `part of` 依赖

### 3.2 给 Tooltip 也加 Controller

`TolyTooltip` 的编程式控制需要通过 GlobalKey 获取 State：

```dart
// ❌ 当前方式
final key = GlobalKey<TolyTooltipState>();
key.currentState?.ensureTooltipVisible();
```

而 `TolyPopover` 已经有了 `PopoverController`。两个组件的 API 风格不一致。

建议：

```dart
// ✅ 统一风格
class TooltipController {
  void show();
  void dismiss();
}

TolyTooltip(
  controller: tooltipController,
  message: '提示',
  child: Icon(Icons.info),
)
```

### 3.3 统一主题系统

包内有三种主题方式：

| 组件 | 当前方式 | 问题 |
|------|---------|------|
| TolyTooltip | `TooltipTheme.of(context)` + `DecorationConfig` 参数 | 混合了 Flutter 内置主题和自定义参数 |
| TolyPopover | `DecorationConfig` 参数 + `defaultDecorationBuilder` | 无 ThemeExtension 支持 |
| TolyPopPicker | `TolyPopPickerTheme`（ThemeExtension） | ✅ 最规范 |

建议统一为 ThemeExtension 模式：

```dart
class TolyTooltipTheme extends ThemeExtension<TolyTooltipTheme> {
  final DecorationConfig? decorationConfig;
  final Duration? waitDuration;
  final Duration? showDuration;
  final Placement? placement;
  // ...
}

class TolyPopoverTheme extends ThemeExtension<TolyPopoverTheme> {
  final DecorationConfig? decorationConfig;
  final Duration? animDuration;
  final Placement? placement;
  // ...
}
```

优先级：参数传入 > ThemeExtension > 默认值。用户可以在 `ThemeData.extensions` 中全局配置，也可以在单个组件上覆盖。

---

## 四、可扩展性改进

### 4.1 溢出算法可插拔

`PopoverPositionDelegate` 已经接受 `OverflowAlgorithm?` 参数，但 `TolyTooltip` 没有暴露给用户。Tooltip 的溢出行为不可定制。

```dart
// ✅ 在 TolyTooltip 上暴露
const TolyTooltip({
  this.overflowAlgorithm,  // 新增
  // ...
});
```

### 4.2 Tooltip 的 Decoration 构建可插拔

`TolyPopover` 有 `overlayDecorationBuilder`，但 `TolyTooltip` 的装饰逻辑写死在 `_TooltipOverlayState.effectDecoration` 里。用户无法使用自定义 Decoration（渐变、图片背景等）。

```dart
// ✅ 给 Tooltip 也加 decorationBuilder
const TolyTooltip({
  this.decorationBuilder,  // 新增，类型同 Popover 的 OverlayDecorationBuilder
  // ...
});
```

### 4.3 动画可定制

两个组件的动画都是硬编码的 FadeTransition + `Curves.fastOutSlowIn`。Popover 暴露了 duration 但没暴露 curve，Tooltip 两者都没暴露。

```dart
// ✅ 统一暴露
const TolyTooltip({
  this.animDuration,
  this.reverseDuration,
  this.curve,
  this.transitionBuilder,  // 完全自定义过渡动画
  // ...
});

const TolyPopover({
  this.curve,              // 新增
  this.transitionBuilder,  // 新增
  // ...
});
```

### 4.4 参数校验

`TolyPopover` 的 `overlay` 和 `overlayBuilder` 都是可选的，但至少需要提供一个。`child` 和 `builder` 同理。

```dart
// ✅ 加 assert
const TolyPopover({
  this.overlay,
  this.overlayBuilder,
  this.child,
  this.builder,
}) : assert(
       overlay != null || overlayBuilder != null,
       'Either overlay or overlayBuilder must be provided',
     ),
     assert(
       child != null || builder != null,
       'Either child or builder must be provided',
     );
```

---

## 五、可维护性改进

### 5.1 拆分 toly_tooltip.dart（1061 行）

当前单文件包含 6 个类/mixin，职责过多：

| 类 | 行数（约） | 建议归属 |
|----|-----------|---------|
| `_ExclusiveMouseRegion` + `_RenderExclusiveMouseRegion` | ~50 | `exclusive_mouse_region.dart` |
| `TolyTooltip` + `TolyTooltipState` | ~600 | `toly_tooltip.dart` |
| `_TooltipOverlay` + `_TooltipOverlayState` | ~150 | `tooltip_overlay.dart` |
| `DecorationConfig` | ~20 | `decoration/decoration_config.dart` |

### 5.2 重构 PopHideMixin

当前 `PopHideMixin` 同时监听滚动和窗口尺寸变化，通过 `offset` 字段过滤"不必要的滑动变化"，逻辑隐晦。

建议：
- 重命名为 `AutoDismissMixin`，语义更清晰
- 给 `offset` 字段加注释说明用途
- 或者拆成 `ScrollDismissMixin` + `ResizeDismissMixin`

### 5.3 溢出算法死代码分支

`defaultOverflowAlgorithm` 中，`leftStart`/`leftEnd`/`rightStart`/`rightEnd` 的 switch case 中关于 outBottom/outTop 的分支实际上是死代码。原因是在 switch 之前有提前拦截逻辑：

```dart
if (!outLeft && input.isLeft) {
  return Placement.left;  // leftStart.isLeft == true，直接返回
}
```

这导致 switch 中以下分支永远不会执行：

```dart
case Placement.leftStart:
  if (outBottom) return Placement.leftEnd;   // 死代码
  // ...
case Placement.leftEnd:
  if (outTop) return Placement.leftStart;    // 死代码
  // ...
```

需要明确意图：
- 如果希望 `leftStart` 在 bottom 溢出时调整为 `leftEnd`，则提前拦截逻辑应排除 Start/End 变体
- 如果当前行为（统一回退到基础方向）是正确的，则删除 switch 中的死代码分支

### 5.4 BubbleBoxPainter 中的 `whitePaint` 命名

```dart
// ❌ 变量名有误导性，实际颜色可能是任何颜色
Paint whitePaint = Paint()..color = decoration.color ?? Colors.black;

// ✅ 改为
Paint fillPaint = Paint()..color = decoration.color ?? Colors.black;
```

### 5.5 硬编码中文

`TolyPopPicker` 的默认取消文字：

```dart
// ❌ 国际化组件库不应默认中文
cancelText = "取消"

// ✅ 方案 A：改为英文
cancelText = "Cancel"

// ✅ 方案 B：改为 required
required this.cancelText,
```

### 5.6 scheduleMicrotask 时序风险

`PopoverPositionDelegate.getPositionForChild` 中：

```dart
if (onSizeFind != null) {
  scheduleMicrotask(() {
    onSizeFind!(overlaySize);  // layout 阶段触发回调
  });
}
```

在 layout 阶段通过 microtask 触发回调可能导致 "setState during build"。虽然当前 `onSizeFind` 被注释掉未使用，但如果将来启用，建议改为：

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  onSizeFind!(overlaySize);
});
```

### 5.7 标注 Fork 来源

`toly_tooltip.dart` 大部分代码 fork 自 Flutter SDK 的 `tooltip.dart`。建议在文件头部注释标明：

```dart
/// Forked from Flutter SDK tooltip.dart (Flutter 3.x.x)
/// 新增: Placement 多方向定位、BubbleDecoration 气泡装饰
/// 修改: 定位算法替换为 PopoverPositionDelegate
```

方便后续与上游 diff 同步 bug 修复。

---

## 六、执行优先级

| 阶段 | 改动 | 预估工作量 | 收益 |
|------|------|-----------|------|
| **P0 立即** | 删 `dart:io`、修文件名拼写、清理乱码和 `if(true)` | 10 分钟 | 消除 Web 编译失败和技术债 |
| **P1 短期** | 提取 `core/` 层、DecorationConfig 独立 | 2-3 小时 | 解除循环依赖，新组件可复用 |
| **P1 短期** | Controller 接口化、消除 `part of` | 1-2 小时 | 可测试性大幅提升 |
| **P1 短期** | 参数校验 assert | 15 分钟 | 防止误用 |
| **P2 中期** | 统一 ThemeExtension 主题系统 | 3-4 小时 | 用户体验一致性 |
| **P2 中期** | Tooltip 暴露 overflowAlgorithm、decorationBuilder、动画参数 | 2-3 小时 | 可扩展性对齐 Popover |
| **P2 中期** | 给 Tooltip 加 Controller | 1-2 小时 | API 风格统一 |
| **P3 长期** | 拆分 toly_tooltip.dart 大文件 | 2-3 小时 | 长期可维护性 |
| **P3 长期** | 重构 PopHideMixin | 1 小时 | 代码可读性 |
| **P3 长期** | 清理溢出算法死代码 | 1 小时 | 逻辑正确性 |
