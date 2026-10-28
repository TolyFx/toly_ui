# tolyui-form 组件规范建立

版本：v1 · 日期：2026-10-24。

历史记录：当前Flutter实现见[后续实现记录](../v2/desgin.md)。

状态：规范文档已建立；第一个组件的基础规则已由用户确认，API和建议默认值待评审，Flutter组件未实现。

## 背景与归属

在 CatPic 媒体工作流的 Web 节点设计中，用户将“类型选择 + 动作按钮”命名为“类型动作选择器”，随后要求建立 tolyui-form 组件规范。通用规范归属 TolyUI 独立仓库中的既有 `modules/form/tolyui_form` 包，产品映射与原生能力继续留在产品侧。

现有包已经提供文字、数字、选择、开关、按钮组、表单行和主题导出，没有类型动作选择器导出。本轮只制定规范，不修改公开Dart API、包依赖、版本或聚合导出。

## 文档分工

[规范目录](../../../../../modules/form/tolyui_form/docs/specs/README.md)维护当前组件列表；[F001 类型动作选择器](../../../../../modules/form/tolyui_form/docs/specs/type-action-selector.md)为结构、参数及事件规则的唯一规范正文。本文记录需求来源、实施范围和实际变更，不重复维护组件参数。

已确认：名称、左类型右动作的单行结构、动作纯图标、按类型变化、可配置的选择后单次自动执行。

建议：`autoTriggerOnSelect`默认false、受控值、重复同值不触发、回填不触发、禁用/忙碌行为和主题映射。建议不冒充用户已确认结论。

## 代码变更树

```text
toly_ui/
├── modules/form/tolyui_form/
│   ├── README.md                          #entry [修改]
│   └── docs/specs/
│       ├── README.md                      #index [新增]
│       └── type-action-selector.md        #contract [新增]
├── docs/packages/README.md                #entry [修改]
└── docs/features/form/component-specification/v1/
    └── desgin.md                         #record [新增]
```

Tag 描述：

- **#entry**：在既有包说明和项目包文档中提供规范入口。
- **#index**：规范范围、命名和组件清单，当前只登记F001。
- **#contract**：已确认规则、参数提案、事件、状态、边界及验收。
- **#record**：记录本轮范围和变更；不代表Flutter实现已交付。

## 后续实现连接点

后续实际实现应在此包新增纯Flutter字段控件，复用既有主题、密度和公开导出规则。具体API和文件树在用户要求实现时再制定；不在本轮创建空实现文件。文件、媒体库和截图由宿主注入回调，禁止公共UI反向依赖CatPic或原生插件。

## 验证与待定

本轮仅文档修改，验证相对链接、目录、命名和仓库边界，不声称运行了Flutter组件测试。待后续决定参数最终默认值和Flutter API；不阻断当前规范记录与继续讨论新组件。
