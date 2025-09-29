part of 'main.dart';

void showGlobalThemeStylePicker(
  BuildContext context,
  DebugValueSetter setter,
) async {
  TolyPopPickerTheme pickerTheme = const TolyPopPickerTheme(
      borderRadius: 20.0,
      separatorHeight: 8,
      itemHeight: 54,
      cancelHeight: 50,
      separatorColor: Color(0xffE5E3E4),
      titlePadding: EdgeInsets.symmetric(vertical: 12),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.black,
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
      ));

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          extensions: [pickerTheme],
        ),
        child: Builder(builder: (ctx) {
          return Scaffold(
            appBar: AppBar(title: const Text('自定义主题页面')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showTolyPopPicker(
                    context: ctx,
                    title: const Text('选中应用语言'),
                    message: '选中的语言将会影响应用程序表现',
                    tasks: ['简体中文', 'English']
                        .map(
                            (e) => TolyMenuItem(info: e, task: () => setter(e)))
                        .toList(),
                  );
                },
                child: const Text('显示主题选择器'),
              ),
            ),
          );
        }),
      ),
    ),
  );
}
