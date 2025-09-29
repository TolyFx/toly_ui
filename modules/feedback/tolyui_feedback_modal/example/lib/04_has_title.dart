part of 'main.dart';

void showHasTitlePicker(
  BuildContext context,
  DebugValueSetter setter,
) async {
  showTolyPopPicker(
    context: context,
    title: const Text('选择操作',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    tasks: [
      TolyMenuItem(
        info: '编辑',
        task: () {
          setter('编辑');
        },
      ),
      TolyMenuItem(
        info: '删除',
        task: () {
          setter('删除');
        },
      ),
      TolyMenuItem(
        info: '分享',
        task: () {
          setter('分享');
        },
      ),
    ],
  );
}
