# F002 · 尺寸输入器

英文标识：**DimensionInput**。所属：**tolyui-form 通用表单组件**。

- 状态：已实现，版本0.0.2。
- 更新：2026-10-25。
- 使用入口：`TolyDimensionInput`、`TolyDimensionInputStyle`，由`tolyui_form.dart`导出。

## 职责

把W/H数字输入和比例锁合成一行。组件提供受控文本、焦点、数字过滤、回车事件和比例动作请求，适用于图片尺寸、画布尺寸及其他二维参数表单。

组件不读取图片、不执行尺寸计算、不绑定工作流，不自动修改另一边；范围校验、比例联动、撤销、保存和执行由宿主处理。输入控制器和焦点节点必须由宿主创建、同步及销毁。

## 结构

```text
[ W  宽度输入 ]  [ H  高度输入 ]  [ 比例锁 ]
```

两个字段共享同一组样式，短标签常驻。`showLock:false`移除比例区及其左间距。没有默认Tooltip、loading或独立运行按钮。

## 参数

| 分组 | 参数 | 规则 |
| --- | --- | --- |
| 草稿 | widthController / heightController | 必填TextEditingController，可为空草稿，不由组件销毁 |
| 焦点 | widthFocusNode / heightFocusNode | 必填FocusNode，宿主可监听失焦提交 |
| 锁定 | locked / onLockChanged | 受控bool与新值请求，回填不会触发；空回调只禁用比例区 |
| 输入 | onWidthChanged / onHeightChanged | 用户编辑后返回过滤后的原始文本，不等同业务提交 |
| 确认 | onWidthSubmitted / onHeightSubmitted | 回车确认；组件不再追加一次失焦提交 |
| 开关 | enabled / showLock | 默认均true；禁用后字段和比例动作均不可操作 |
| 文案 | widthLabel / heightLabel / placeholder | 默认W/H/—，不自动添加单位 |
| 无障碍 | widthSemanticLabel / heightSemanticLabel / lockSemanticLabel | 默认宽度/高度/锁定比例；宿主可补单位 |
| 输入长度 | maxDigits | 默认5，只接受数字；必须大于0，不负责业务范围或非零校验 |
| 密度 | density | 默认compact，由TolyFormThemeData提供默认高度 |
| 样式 | style | TolyDimensionInputStyle，见下表 |
| 定位 | widthFieldKey / heightFieldKey / lockKey | 可选Key，供宿主定位和测试 |

## 草稿与事件

1. 初始化、程序回填、重新构建与外部修改`locked`均不执行动作回调。
2. 用户编辑只触发对应的`on...Changed`。清空是合法编辑状态，是否允许提交空值由宿主判断。
3. 回车仅触发一次对应的`on...Submitted`；需要失焦提交时，宿主监听公开的FocusNode并通过dirty标记去重。
4. 比例区每次点击、Enter或Space请求一次`!locked`；宿主回填新锁状态。组件不会自动联动W/H。
5. 外层Form校验与保存仍由宿主注册，组件不悄悄执行上次有效参数。

## 布局与样式

| 属性 | 默认与用途 |
| --- | --- |
| height | 未设置时使用密度高度，当前主题默认compact28px/regular34px |
| fieldWidth | null时两个字段均分可用宽度，需要有界横向约束；指定时整行可包裹内容 |
| fieldGap / labelGap / lockGap | 默认6 / 4 / 4px |
| lockWidth / lockIconSize | 默认24 / 16px |
| padding | 默认单字段左右6px |
| borderRadius / fillColor / disabledFillColor | 未覆盖时采用表单主题；无默认Material边框 |
| textStyle / labelStyle / hintStyle | 可分别覆盖，默认数值12px、标签10px，颜色由当前主题提供 |
| activeColor / inactiveColor | 默认比例激活色取表单焦点色，解锁色取当前主题次级文字色 |
| cursorColor / cursorWidth / cursorHeight / cursorRadius | 默认取激活色、宽1px，高度及圆角随平台；可显式配置 |
| selectionColor | 可显式配置，未覆盖时继承TextSelectionTheme，再回退到20%激活色 |

固定宽度时总宽为`2×fieldWidth + fieldGap + (showLock ? lockGap + lockWidth : 0)`。在无界Row等布局中，使用固定字段宽度或由宿主包Expanded/SizedBox约束。

字段悬浮保持原背景，比例区只使用激活色6%悬浮/10%键盘焦点反馈；不使用默认灰色闪烁。选区手柄使用激活色。Tab依次进入W、H、比例区，比例区支持Enter/Space并提供锁定状态语义。

## CatPic接入事实

CatPic的WorkshopDimensionRow仅保留样式适配和事件转发，两个场景均使用本公共组件：

- 普通工坊：32px高、两字段均分、数值12px/前缀10px、圆角6px、20px比例区/17px图标。
- 工作流节点：字段48×16px、数值7px/前缀7px、圆角3px、16px比例区/10px图标，蓝色1×10px光标和20%浅蓝选区。

字段留白、间距、动作区、光标及节点承载尺寸集中记录在[紧凑表单基础尺寸](compact-layout.md)，供后续表单复用。

这些是产品覆盖值，不是公共组件默认值；CatPic继续负责原始比例、草稿校验、撤销和图像执行。

## 验证与示例

[嵌入式示例](../../example/dimension_input.dart)展示受控草稿、比例状态和回车事件，不需要原生宿主或媒体库。测试覆盖默认/固定布局、初始化和回填无回调、输入与确认分离、无自动比例计算、禁用、数字过滤、空白、键盘和光标选区覆盖。

[返回组件规范](README.md)
