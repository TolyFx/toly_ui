part of 'main.dart';

void showBasicPicker(
  BuildContext context,
  DebugValueSetter setter,
) {
  showTolyPopPicker(
    context: context,
    tasks: [
      TolyMenuItem(
        info: '拍照',
        task: () {
          setter.call('拍照');
        },
      ),
      TolyMenuItem(
        info: '从相册选择',
        task: () {
          setter.call('从相册选择');
        },
      ),
    ],
  );
}
