# F001 类型动作选择器 Flutter 封装

日期：2026-10-24 · 状态：源码已实现，验证结果见下文；未发布。

## 范围和边界

按用户“首先封装表单组件”的要求，在既有`tolyui_form`包实现首个通用组件：`TolyTypeActionSelector<T>`及`TolyTypeActionOption<T>`。不添加具体图片类型或平台依赖，应用负责文件选择、媒体库与截图回调。实际规范以[组件规范](../../../../../modules/form/tolyui_form/docs/specs/type-action-selector.md)为准。

单行统一边框、左侧类型选择、右侧纯图标动作；类型变更可自动调用一次动作。支持受控值、外部回填、禁用类型、独立动作禁用、宿主控制忙碌、悬浮主题反馈、Tooltip和键盘操作。自动触发默认false为实现选择，后续规范仍可调整。

复用现有表单主题和密度，不改变其他控件默认值。示例将紧凑高度配置为24px。组件不捕获或伪造业务执行结果；宿主在异步执行前同步设置`actionRunning`，完成或取消后恢复。

## 代码变更树

```text
toly_ui/
├── modules/form/tolyui_form/
│   ├── lib/tolyui_form.dart                      #api [修改]
│   ├── lib/src/fields/
│   │   ├── type_action_selector.dart             #field [新增]
│   │   ├── type_action_option.dart               #model [新增]
│   │   └── type_action_target.dart               #interaction [新增]
│   ├── example/type_action_selector.dart         #example [新增]
│   ├── test/type_action_selector_test.dart       #test [新增]
│   ├── docs/specs/README.md                      #docs [修改]
│   ├── docs/specs/type-action-selector.md        #docs [修改]
│   ├── README.md                                #docs [修改]
│   └── CHANGELOG.md                             #docs [修改]
└── docs/features/form/component-specification/
    ├── v1/desgin.md                              #history [修改]
    └── v2/desgin.md                              #record [新增]
```

Tag描述：

- **#api**：只导出新字段；既有`tolyui`聚合包的转导出自动可用，无需修改依赖。
- **#field**：控件布局、类型变化、自动/手动动作以及外部忙碌状态。
- **#model**：泛型类型选项及图标、提示、可用性。
- **#interaction**：内部鼠标、键盘、焦点和主题色反馈，不导出为公共组件。
- **#example**：可嵌入的示例Widget，记录动作回调，不伪装成真实系统操作。
- **#test**：实际菜单操作、事件次数、回填、禁用/忙碌、窄宽度、键盘和悬浮。
- **#docs**：当前API、默认值、生命周期责任及未发布状态。
- **#history / #record**：保留最初的规范提案与本轮实现记录。

## 验收与验证

确认触发顺序为“类型通知→一次动作”，同值选择和回填不触发，手动按钮独立触发；两类禁用和忙碌状态明确；窄布局无溢出；菜单可用Tab、方向键和Enter操作；悬浮为主题浅色且不闪灰。

未主动启动展示应用或截图，视觉验收由用户完成。包不新增插件、原生代码或产品依赖。

验证结果：`tolyui_form`整包13项测试通过（含7项新组件交互测试）；`tolyui`聚合包2项回归测试通过。组件包lib/test/示例和聚合入口静态分析无问题；文档相对链接与diff空白检查通过。未启动客户端、未发布。
