part of 'main.dart';

void showAsyncStatusPicker(
  BuildContext context,
  DebugValueSetter setter,
) async {
  String? filePath = await showTolyPopPicker<String>(
    onStatusChange: _onStatusChange,
    context: context,
    tasks: [
      TolyMenuItem<String>(
        info: '同步数据(模拟 5s 超时)',
        popBeforeTask: true,
        task: () async {
          // 模拟异步任务
          await Future.delayed(Duration(milliseconds: 10000));
          return 'root/temp/foo';
        },
      ),
      TolyMenuItem<String>(
        info: '保存设置(成功)',
        popBeforeTask: true,
        task: () async {
          // 模拟异步任务
          await Future.delayed(Duration(milliseconds: 1000));
          return 'root/temp/foo/2';
        },
      ),
      TolyMenuItem<String>(
        info: '发送消息(异常)',
        popBeforeTask: true,
        task: () async {
          // 模拟异步任务
          await Future.delayed(Duration(milliseconds: 1000));
          throw "处理异常，请稍后重试";
          return 'root/temp/painter';
        },
      ),
    ],
  );
  if (filePath != null) {
    setter(filePath);
  }
}

void _onStatusChange(TaskStatus status, TolyMenuItem<String> item) {
  print("=====${status.runtimeType}==========");

  switch (status) {
    case Loading():
      $message.loading();
      return;
    case Idle():
    case Success():
    case Failure():
    case Timeout():
    case Canceled():
      $message.closeLoading();
  }
  if (status is Failure) {
    $message.error(message: '任务执行失败');
  }
  if (status is Timeout) {
    $message.warning(message: '任务执行超时');
  }
  if (status is Success) {
    $message.success(message: '任务执行成功!');
  }
}
