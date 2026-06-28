/// ===================================================
/// Power By 张风捷特烈 --- Generated file. Do not edit.
/// github: https://github.com/toly1994328
/// ===================================================

part of 'node.g.dart';

Map<String, dynamic> get _anchorData => {"AnchorDemo1":{"title":"基础用法","desc":"TolyAnchor 用于锚点导航，基于 ScrollablePositionedList 实现索引级滚动控制。\n左侧 TolyAnchor 显示导航列表，右侧 TolyAnchorScrollable 显示对应内容区域。\n点击左侧导航项时，右侧内容会平滑滚动到对应位置；滚动右侧内容时，左侧导航会自动高亮当前可见区域对应的项。\nTolyAnchor 内部使用 ListView.builder，支持大量导航项的性能优化。","code":"assets/code_res/anchor_demo1.txt"},"AnchorDemo2":{"title":"设置面板样式","desc":"模拟飞书桌面端设置面板的交互体验，展示 TolyAnchor 在实际应用场景中的使用方式。\n左侧导航使用 linkBuilder 自定义渲染，包含图标和文字，激活项有左侧高亮边框和背景色。\n右侧内容区域按分组展示设置项，每个设置项使用不同颜色的色块区分，内容高度自适应。\n当激活项超出可视区域时，左侧导航会自动滚动确保激活项可见。","code":"assets/code_res/anchor_demo2.txt"},"AnchorDemo4":{"title":"横向标签导航","desc":"顶部横向标签导航，内容区域竖直滚动。\nTolyAnchor 设置 scrollDirection: Axis.horizontal 实现横向标签列表。\nTolyAnchorScrollable 保持默认垂直滚动，内容按页面分段。\n适用于文档目录、章节导航等场景。","code":"assets/code_res/anchor_demo3.txt"},"AnchorDemo3":{"title":"大量数据测试","desc":"测试 TolyAnchor 在极端数据量（300 项）场景下的性能表现。\nTolyAnchor 内置 ListView.builder 实现虚拟滚动，仅渲染可视区域的导航项，内存占用稳定。\nTolyAnchorScrollable 基于 ScrollablePositionedList，同样支持高效的按需构建。\n滚动过程中，左侧导航会自动跟随高亮并滚动确保激活项可见，交互流畅无卡顿。\n可用于验证长列表场景下的滚动监听、高亮切换、导航跟随等功能稳定性。","code":"assets/code_res/anchor_demo4.txt"}};