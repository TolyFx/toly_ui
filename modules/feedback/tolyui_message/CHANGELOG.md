## 0.2.7

- Notice 缺省采用磨砂玻璃 UI：主题色、加粗标题、矩形缩略图、右侧圆角动作按钮和逆时针计时边线。
- 内置 NoticeIntent / NoticeIntentHandler、执行中防重、默认常驻策略和可接管的动作失败反馈。
- 新增 notice 通用入口；既有四类 Notice API 与 emitNotice 保留。
- 宿主更新时刷新内容，在子浮层销毁前清理消息及动作生命周期。
- 最低 Flutter 版本调整为 3.27，保持纯 Flutter，无平台插件依赖。

- 更新通知面板、倒计时边框与NoticeIntent动作分发。

## 0.2.6

* 0.2.6+1: loadingTask return Future
* didUpdateWidget update overlay


## 0.2.5

*修复一些 bug


## 0.2.3

* Support TolyMessage#supportedLocales


## 0.2.2

* Support $message.loading


## 0.2.1

* Fix TapRegion Bug


## 0.2.0

* Support [TolyMessageShowTheme] and [TolyMessageStyleTheme] to set default Theme


## 0.1.0

* $message toast Message and Notification
