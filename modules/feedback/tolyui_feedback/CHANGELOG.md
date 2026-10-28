## 0.3.7

- 修复延迟提示重复悬浮，支持scale整体缩放与当前布局定位。
* TolyTooltip增加scale参数（默认1），支持面板整体缩放及当前帧锚点定位，覆盖缩放中的边界避让、箭头和鼠标命中。

* 修复TolyTooltip设置非零waitDuration时，提示关闭后再次悬浮隔次不展示：关闭计时结束清空任务引用，安排展示时检查计时器是否仍有效。
* 补充连续进出、等待中移出、关闭延迟及淡出期间返回的回归测试。

## 0.3.6

* 0.3.6+17: 同步 ViewX 使用的消息、弹层与提示组件实现。
* 0.3.6+16: handle defaultOverflowAlgorithm error
* 0.3.6+4: handle scrollPosition#pixels error
* 0.3.6+2: tolyui_message -> 0.2.5

* 0.3.6+1: tolyui_message-> 0.2.4


## 0.3.5

* Support TolyPopover#marge check overflow
* Support overflow all position, display at center
* +1: fix scroll hide
* +2: update tolyui_message->0.2.3


## 0.3.4

* [tolyui_message](https://pub.dev/packages/tolyui_message) update v0.2.1
* +6 : Support TolyPopover#barrierDismissible


## 0.3.3

* DecorationConfig#BubbleMeta config Bubble △ height and angle


## 0.3.1

* Support Global Message Notification by [tolyui_message](https://pub.dev/packages/tolyui_message)


## 0.3.0

* TolyPopover
* 0.3.6+2: * tolyui_message -> 0.2.5
* TolyTooltip

