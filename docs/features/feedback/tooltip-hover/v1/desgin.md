# TolyTooltip重复悬浮展示修复

- 日期：2026-10-24。
- 状态：当前源码已修复，未发布新版本。

CatPic节点问号配置250ms展示等待、100ms关闭等待；第一次移入显示，退出并完全关闭后第二次移入不显示，第三次恢复。组件的关闭Timer执行后没有清空引用，而安排延迟展示使用_timer ??=，导致已过期对象阻止新展示任务；再退出才清空引用，形成隔次失效。

关闭计时统一通过_hideTooltip清空引用再反向动画；新展示任务检查Timer.isActive而非仅检查对象是否为空，保留尚在等待的任务，不重复安排。展示等待、退出取消、淡出期间返回、全局关闭与触控语义保持。根因修复归属本反馈包，不在CatPic节点内额外叠加计时器。

## 实际变更树

```text
modules/feedback/tolyui_feedback/
├── lib/toly_tooltip/toly_tooltip.dart
├── test/tooltip_hover_test.dart
├── README.md
└── CHANGELOG.md
docs/features/feedback/tooltip-hover/v1/desgin.md
```

回归覆盖非零等待下连续四次完整进出、等待中移出、关闭延迟及淡出中返回，并执行原有Tooltip测试。CatPic以本地path覆写接入相同源码，包版本保持0.3.6+17，不代表已发布到pub.dev。

组件相关14项测试通过；针对修改文件的分析仍有5项既有提示（未用成员/导入及withOpacity弃用），本次修复未新增相关提示。
