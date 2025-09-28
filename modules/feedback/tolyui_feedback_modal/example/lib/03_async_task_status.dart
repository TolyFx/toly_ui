part of 'main.dart';

void showAsyncStatusPicker(
  BuildContext context,
  DebugValueSetter setter,
) async {
  String? filePath = await showTolyPopPicker<String>(
    onStatusChange: onStatusChange,
    context: context,
    tasks: [
      TolyMenuItem<String>(
        info: '拍照(模拟超时)',
        popBeforeTask: true,
        task: () async {
          // 模拟异步任务
          await Future.delayed(Duration(milliseconds: 10000));
          return 'root/temp/foo';
        },
      ),
      TolyMenuItem<String>(
        info: '从相册选择',
        popBeforeTask: true,
        task: () async {
          // 模拟异步任务
          await Future.delayed(Duration(milliseconds: 1000));
          return 'root/temp/foo/2';
        },
      ),
      TolyMenuItem<String>(
        info: '白板绘制',
        popBeforeTask: true,
        task: () async {
          // 模拟异步任务
          await Future.delayed(Duration(milliseconds: 1000));
          return 'root/temp/painter';
        },
      ),
    ],
  );
  if (filePath != null) {
    setter(filePath);
  }
}

void onStatusChange(TaskStatus status, TolyMenuItem<String> item) {
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
    $message.error(message: '任务执行超时');
  }

  if (status is Success) {
    $message.success(message: '任务执行成功!');
  }
  print("=====${status.runtimeType}==========");
}
