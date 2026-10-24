# TolyUI组件补丁版本发布

- 日期：2026-10-25。
- 状态：GitHub Actions成功，8个版本均已通过pub.dev API核验收录。

按用户要求，将仍保留且有源码变化的七个包递增第三位版本号，并更新聚合包：

| 包 | 版本 |
| --- | --- |
| tolyui_action | 0.1.1 |
| tolyui_message | 0.2.7 |
| tolyui_feedback | 0.3.7 |
| tolyui_form | 0.0.2 |
| tolyui_menu | 0.1.1 |
| tolyui_pop_panel | 0.0.2 |
| tolyui_navigation | 0.2.2 |
| tolyui | 0.0.6 |

使用现有Publish package工作流与批量标签，按动作、消息、反馈、表单、菜单、确认面板、导航、聚合包顺序发布；依赖版本同步。聚合包新增导出纯Flutter动作/反馈契约。tolyui_action首次公开发布；不发布已从当前Workspace移除的rich_input和image，不合入其暂存整包删除。

隔离发布分支从origin/main准备，原工作区其他未提交改动与暂存删除保持。Workspace增加action、移除已退出的两个成员引用，历史源码未在此分支删除。发布解析使用--no-example，避免在新依赖尚未发布时提前解析独立示例；测试使用--no-pub复用Workspace解析结果。原有无main占位测试文件沿用Action过滤规则。

本地验证八个包的有效测试通过；反馈包校正五条旧避让测试预期，保持原算法；聚合入口静态检查通过，52个依赖的闭包无Flutter插件。更新包版本、依赖、README、CHANGELOG和表单规范。发布以Action成功和pub.dev API收录为准，不以推送标签代替结果确认。

## 代码变更树

```text
.github/workflows/publish-package.yml #ci [修改]
pubspec.yaml                        #workspace [修改]
pubspec.lock                        #workspace [修改]
modules/
├── basic/tolyui_action/             #package [新增]
├── feedback/tolyui_message/         #package [修改]
├── feedback/tolyui_feedback/        #package [修改]
├── feedback/tolyui_pop_panel/       #package [修改]
├── form/tolyui_form/                #package [修改]
├── navigation/tolyui_menu/          #package [修改]
├── navigation/tolyui_navigation/    #package [修改]
└── tolyui/                         #aggregate [修改]
docs/features/release/component-patches/v1/desgin.md #docs [新增]
```

Tag描述：#ci维护既有按序发布任务；#workspace确保待发布组件在同一解析图中；#package包含对应源码、测试及发布材料；#aggregate只更新纯Flutter公共依赖与导出；#docs记录本轮范围及结果。

发布结果：[GitHub Actions](https://github.com/TolyFx/toly_ui/actions/runs/40136791560)成功，耗时4分36秒；全部8个版本已由pub.dev版本API确认。发布源码提交7055cbc，分支codex/patch-release-20261025。
