import '../../model/notice_intent.dart';

/// 通知生命周期内共享的动作分发器，防止重复执行和销毁后反馈。
class NoticeIntentDispatcher {
  /// 当前正在执行的动作，以实例身份区分不同通知。
  final Set<NoticeIntent> _pending = Set<NoticeIntent>.identity();

  /// 宿主解绑后拒绝执行并停止向旧界面报告错误。
  bool _disposed = false;

  /// 仅在用户触发时执行，动作执行期间忽略重复点击。
  Future<void> execute(NoticeIntent intent, NoticeIntentHandler handler,
      NoticeIntentErrorHandler onError) async {
    if (_disposed || !handler.supports(intent) || !_pending.add(intent)) return;
    try {
      await handler.execute(intent);
    } catch (error, stack) {
      if (!_disposed) onError(error, stack);
    } finally {
      _pending.remove(intent);
    }
  }

  void dispose() {
    _disposed = true;
    _pending.clear();
  }
}
