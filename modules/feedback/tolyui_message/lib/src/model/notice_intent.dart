/// 通知的语义级别，与宿主业务事件解耦。
enum NoticeLevel { info, success, warning, error }

/// 通知附带的语义动作，具体系统能力由使用方实现。
abstract class NoticeIntent {
  const NoticeIntent({this.allowAutoClose = false});

  /// 带动作的通知默认常驻，显式允许后才按时关闭。
  final bool allowAutoClose;

  /// 动作按钮的可读文字。
  String get label;
}

/// 使用方提供动作支持检查与执行能力，组件不依赖系统插件。
abstract interface class NoticeIntentHandler {
  bool supports(NoticeIntent intent);
  Future<void> execute(NoticeIntent intent);
}

/// 使用方接管动作失败的反馈方式。
typedef NoticeIntentErrorHandler = void Function(
    Object error, StackTrace stack);

/// 调度与倒计时边线共用自动关闭策略。
Duration noticeDisplayDuration(Duration duration, NoticeIntent? intent) =>
    intent?.allowAutoClose == false ? Duration.zero : duration;
