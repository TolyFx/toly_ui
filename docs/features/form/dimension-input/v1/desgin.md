# F002尺寸输入器公共化

- 日期：2026-10-24。
- 状态：源码已实现，尚未发布包版本；组件规范见[F002](../../../../../modules/form/tolyui_form/docs/specs/dimension-input.md)。

## 范围与依赖

将CatPic已确认的W/H输入与比例动作抽象为纯Flutter组件TolyDimensionInput，样式为TolyDimensionInputStyle。公共层只依赖Flutter，不反向导入CatPic、image_workshop、媒体或节点协议，不增加原生插件。CatPic通过既有path依赖复用，不复制第二份公共组件源码。

控制器、焦点与业务参数由宿主持有。组件仅负责草稿事件、回车确认、受控比例请求和视觉；算法、有效尺寸范围、失焦提交去重、Form校验、撤销和执行留在产品。允许空草稿，不静默执行上次合法值；初始化与恢复不触发动作。

## 布局与交互

默认使用TolyFormThemeData密度高度和颜色，局部样式可覆盖字段宽高、字形、留白、圆角、图标、光标及文字选区。字段宽空时均分有界宽度，固定时支持内容包裹。比例区复用既有键盘/鼠标操作区，支持Enter/Space、Tab、禁用和锁定语义，默认无Tooltip、loading或灰色hover闪烁。

## 实际变更树

```text
modules/form/tolyui_form/
├── lib/src/fields/dimension/
│   ├── input.dart               # 公开受控尺寸行与比例请求
│   ├── style.dart               # 产品无关的局部样式
│   └── value_field.dart         # 内部数字输入表面
├── lib/tolyui_form.dart         # 公开导出
├── test/dimension_input_test.dart
├── example/dimension_input.dart # 可嵌入示例，不启动展示应用
├── docs/specs/dimension-input.md
├── docs/specs/README.md         # F002登记
├── README.md
└── CHANGELOG.md                # 未发布记录
```

根组件包目录同步规范入口。未修改聚合包依赖或原生注册，未启动展示应用或发布包；聚合入口原有的tolyui_form导出可直接使用新组件。

## 验证

组件包测试覆盖原有表单及类型动作选择器，以及新增草稿/回填、回车去重、无自动比例运算、键盘、禁用、空白、数字过滤、默认/固定布局、选区光标覆盖和控制器生命周期。包内示例与公开入口静态检查通过；CatPic验证结果记录于其节点流v25。
