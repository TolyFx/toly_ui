part of 'main.dart';

void showAsyncPicker(
  BuildContext context,
  DebugValueSetter setter,
) async {
  String? filePath = await showTolyPopPicker<String>(
    context: context,
    tasks: [
      TolyMenuItem<String>(
        info: '拍照',
        task: () async {
          // 模拟异步任务
          await Future.delayed(Duration(milliseconds: 1000));
          return 'root/temp/foo';
        },
      ),
      TolyMenuItem<String>(
        info: '从相册选择',
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
