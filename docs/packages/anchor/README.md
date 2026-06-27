# Anchor 锚点组件调研报告

## 二、 核心实现方案：深度解析 scrollable_positioned_list

### 1. 核心机制：逻辑支点布局 (Logical Anchor Layout)
`scrollable_positioned_list` 并非使用原生的 `ListView`。它的“严格方案”是重写了 Viewport 的布局协议：

*   **Anchor Index (布局支点)**：打破“布局必须从 index 0 开始”的限制。当跳转到 index X 时，它直接通知 Viewport：“以索引 X 为 0 坐标点开始布局”。
*   **双向渲染 (Two-way Slivers)**：内部使用两个背靠背的 Sliver。一个负责 X 之后的布局，一个负责 X 之前的布局。这使得即便跳转到未渲染的条目，也能立即生成其周围的 UI。
*   **逻辑坐标系**：它不使用物理像素作为唯一真理，而是维护一套 (Index, Offset) 的逻辑坐标。

### 2. 精准跳转的秘密：Registry 模式
*   **组件追踪**：`ElementRegistry` 追踪所有 `Mounted` 的组件。
*   **后置修正**：在跳转后，利用组件上报的真实高度进行像素级微调。

---

## 三、 TolyUI 技术路线图

为了兼顾“严格性”与“易用性”，TolyUI 将提供以下两种模式：

### 1. 标准模式 (Standard Mode)
*   **实现**：基于方案 D（盲跳 + 修正）。
*   **场景**：用户已有的原生 `ListView`。
*   **体验**：通过高度预估实现“近似跳转”，待组件加载后二次对齐。

### 2. 增强模式 (Strict Mode / TolyPositionedList)
*   **实现**：严格遵循 `scrollable_positioned_list` 的双向 Sliver 架构。
*   **场景**：对跳转精度要求极高、数据量巨大的专业长列表。
*   **体验**：跳转 100% 精准，无任何视觉跳动。

## 四、 结论
`scrollable_positioned_list` 的成功在于它从渲染引擎层面解决了问题。TolyUI 应当吸收其**“逻辑坐标”**和**“组件注册”**的思想，在保持轻量化的同时，为开发者提供应对长列表挑战的专业方案。

---
*调研员：TolyAI*
*日期：2024-10-31*
