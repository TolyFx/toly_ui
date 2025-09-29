part of 'main.dart';

void showThemeStylePicker(
  BuildContext context,
  DebugValueSetter setter,
) async {
  showTolyPopPicker(
    context: context,
    title: const Text('选中应用语言'),
    message: '选中的语言将会影响应用程序表现',
    theme: const TolyPopPickerTheme(
        borderRadius: 20.0,
        separatorHeight: 8,
        itemHeight: 54,
        titlePadding: EdgeInsets.symmetric(vertical: 12),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        itemTextStyle: TextStyle(
          color: Colors.indigo,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        cancelTextStyle: TextStyle(
          color: Colors.blueAccent,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
    tasks: ['简体中文', 'English']
        .map((e) => TolyMenuItem(info: e, task: () => setter(e)))
        .toList(),
  );
}
