import '../../tolyui_feedback_modal.dart';

typedef OnStateChange<T> = void Function(
    TaskStatus status, TolyMenuItem<T> item);

typedef OnStatusChange<T> = void Function(TaskStatus status);

// 封装异步任务的生命周期状态
sealed class TaskStatus {
  const TaskStatus();

  bool get isIdle => this is Idle;
  bool get isLoading => this is Loading;
  bool get isSuccess => this is Success;
  bool get isFailure => this is Failure;
  bool get isCanceled => this is Canceled;
}

// 初始状态，任务未开始
class Idle extends TaskStatus {
  const Idle();
}

// 执行中
class Loading<T> extends TaskStatus {
  const Loading();
}

// 成功
class Success<T> extends TaskStatus {
  final T? data;
  const Success(this.data);
}

// 失败
class Failure extends TaskStatus {
  final Object error;
  final StackTrace? stackTrace;
  const Failure(this.error, [this.stackTrace]);
}

class Timeout extends TaskStatus {
  final Duration duration;
  const Timeout(this.duration);
}

// 取消
class Canceled extends TaskStatus {
  const Canceled();
}
