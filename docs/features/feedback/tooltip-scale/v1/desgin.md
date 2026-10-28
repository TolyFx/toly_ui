# TolyTooltip面板整体缩放

- 日期：2026-10-24。
- 状态：本机源码已实现，未发布新版本。

CatPic节点使用Transform缩放，但提示在窗口Overlay上绘制，原本保持固定尺寸。新增scale参数，默认1且要求正有限数值；宿主只传入当前倍率，尺寸、字号、尖角、边框、留白及gap仍按100%定义。触发控件的缩放仍由宿主管理。

面板在窗口尺寸除以scale的坐标系中布局，统一Transform绘制与命中；目标边界在浮层布局阶段读取最新变换，避免画布缩放/平移时沿用上一帧位置。边界避让与箭头偏移在同一坐标系计算，几何变化清除旧箭头方向与偏移。默认倍率保持原有表现，不引入原生或产品依赖。

## 实际变更树

```text
modules/feedback/tolyui_feedback/
├── lib/toly_tooltip/toly_tooltip.dart
├── test/tooltip_scale_test.dart
├── README.md
└── CHANGELOG.md
docs/features/feedback/tooltip-scale/v1/desgin.md
```

验证已显示面板在50%/100%/200%下的大小、位置与间距，缩小后窗口右下区域的鼠标命中，靠近边缘时放大翻转再缩小的箭头方向，及既有重复悬浮和触控回归。CatPic另验证真实画布120%缩放后的面板位置与执行配方保持。
