part of 'main.dart';

void showDesktopModalPicker(BuildContext context, DebugValueSetter setValue) {
  showTolyPopPicker(
    context: context,
    title: const Text('桌面端模态框'),
    message: '在桌面平台会显示为居中对话框',
    tasks: [
      TolyMenuItem<String>(
        info: '保存文档',
        task: () async {
          await Future.delayed(Duration(seconds: 1));
          return '文档已保存';
        },
      ),
      TolyMenuItem<String>(
        info: '导出PDF',
        task: () async {
          await Future.delayed(Duration(seconds: 2));
          return 'PDF导出完成';
        },
      ),
      TolyMenuItem<String>(
        info: '发送邮件',
        task: () async {
          await Future.delayed(Duration(seconds: 3));
          return '邮件发送成功';
        },
      ),
    ],
    // onStatusChange: (status) {
    //   if (status is Success<String>) {
    //     setValue(status.data);
    //   } else if (status is Failure) {
    //     setValue('操作失败: ${status.error}');
    //   } else if (status is Timeout) {
    //     setValue('操作超时');
    //   }
    // },
  );
}
