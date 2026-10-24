# tolyui_message

全局短消息与通知组件。Notice 缺省使用磨砂玻璃卡片，包含加粗标题、左对齐正文、状态图标、可选缩略图及右对齐的浅灰圆角动作按钮。

需要 Flutter 3.27 / Dart 3.6 起。不依赖产品、文件系统或平台插件；缩略图使用 `ImageProvider`，系统动作由宿主提供执行器。

## 注册宿主

在应用 builder 中注册一次，使通知处于路由之上并继承主题：

```dart
import 'package:flutter/material.dart';
import 'package:tolyui_message/tolyui_message.dart';

MaterialApp(
  builder: (context, child) => TolyMessage(
    theme: Theme.of(context),
    child: child ?? const SizedBox.shrink(),
  ),
  home: const HomePage(),
);
```

宿主更新会刷新子内容，卸载时清理消息、动作分发及动画引用。

## 默认通知

既有四类 API 保留，直接获得新的缺省样式：

```dart
$message.infoNotice(title: const Text('提示'), subtitle: const Text('路径已复制'));
$message.successNotice(title: const Text('保存成功'), subtitle: const Text('图片已保存'));
$message.warningNotice(title: const Text('请注意'), subtitle: const Text('部分文件未导出'));
$message.errorNotice(title: const Text('操作失败'), subtitle: const Text('文件无法读取'));
```

- 默认显示三秒，外沿细线按剩余时间逆时针缩短；`Duration.zero` 常驻且不绘制计时边线。
- 普通通知的强调色取主题主色；成功、警告、错误保留语义色。
- 深浅主题、高对比模式均有缺省处理，标题和正文也支持自己的 Widget 样式。
- 默认卡片宽 300；缩略图为 56×64 矩形，读取失败时回退状态图标。
- 主题中的 `noticeBorderRadius` 可覆盖圆角，计时边线同步采用相同形状。

通用入口支持任意标题和正文组件：

```dart
$message.notice(
  title: const Text('导出完成'),
  subtitle: const Text('已导出 1 张图片'),
  level: NoticeLevel.success,
  thumbnail: MemoryImage(imageBytes),
);
```

`thumbnail` 也接受 AssetImage、NetworkImage 或应用按平台提供的 FileImage。消息包本身不导入 dart:io。

## 内置 Intent 机制

动作携带数据，宿主实现系统行为；通知不会自动执行动作。

```dart
class RevealResultIntent extends NoticeIntent {
  const RevealResultIntent(this.path, {super.allowAutoClose});
  final String path;
  @override
  String get label => '查看结果';
}

class ResultIntentHandler implements NoticeIntentHandler {
  @override
  bool supports(NoticeIntent intent) => intent is RevealResultIntent;

  @override
  Future<void> execute(NoticeIntent intent) async {
    if (intent is RevealResultIntent) {
      await revealResult(intent.path); // 应用自己的平台服务。
    }
  }
}

$message.successNotice(
  title: const Text('保存成功'),
  subtitle: const Text('图片已保存'),
  intent: RevealResultIntent(outputPath),
  intentHandler: ResultIntentHandler(),
);
```

- 有 Intent 默认不自动关闭；`allowAutoClose: true` 才按通知时长自动关闭。
- 不提供执行器或 `supports` 返回 false 时隐藏按钮。
- 用户点击后才执行，同一动作执行中不重复触发；点击动作不主动关闭通知。
- 执行失败默认展示错误通知，也可通过 `onIntentError` 交给宿主事件总线处理。
- 宿主解绑后不再执行旧动作，也不将未完成动作的错误发送回已释放界面；已经开始的系统操作不会被强制取消。
- Intent 不限定产品、平台或事件总线，FxEvent 等分发方式由应用自行桥接。

## 自定义通知与短消息

`emitNotice(builder: ...)` 保留，用于完全自定义通知内容；该低层入口自行负责内容内的 Intent 及计时 UI，仍复用浮层定位、堆叠和自动消失。

`$message.info/success/warning/error` 继续使用短消息面板，本次缺省 UI 调整只作用于 Notice。
