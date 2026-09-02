# TolyUI 项目规则

## 聚合包边界

- `modules/tolyui` 是纯 Dart/Flutter UI 聚合包，只能依赖和导出不包含原生平台实现的组件包。
- 禁止 `tolyui` 直接或间接引入需要 Flutter Plugin 注册、平台通道、FFI 或平台专属原生代码的依赖。
- 新增或调整 `tolyui` 的依赖前，必须检查目标包及其传递依赖是否包含 Android、iOS、macOS、Windows、Linux 或 Web 平台插件实现。
- 包含原生能力的功能包可以作为 Workspace 中独立发布、按需引用的扩展包维护，但不得加入 `tolyui` 的 `dependencies`，也不得由 `lib/tolyui.dart` 聚合导出。
- `tolyui_rich_input` 当前属于独立扩展包，不得集成进 `tolyui`；其 `quill_native_bridge` 等原生依赖是该边界的典型判定依据。

## 变更验证

- 修改 `modules/tolyui/pubspec.yaml` 后，必须检查 Flutter 生成的各平台插件注册文件；若仅修改聚合包就新增插件注册项，应视为违反聚合包边界。
- 修改聚合导出后，至少执行入口文件静态分析和 `modules/tolyui` 的相关测试，确认没有导出冲突或契约回退。
