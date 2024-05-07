
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:toggle_rotate/toggle_rotate.dart';
import 'package:toly_ui/app/theme/code_theme.dart';
import 'package:toly_ui/app/utils/toast.dart';
import 'package:tolyui_feedback/toly_tooltip/toly_tooltip.dart';

import '../incubator/components/data/collapse.dart';

class CodeDisplay extends StatelessWidget {
  final Widget display;
  final String code;

  const CodeDisplay({super.key, required this.display, required this.code});

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerTheme.color ?? Colors.grey,
              width: Theme.of(context).dividerTheme.space ?? 1,
            ),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
              child: display,
            ),
            const Divider(),
            TolyCollapse(
              actionBuilder: (action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                          onTap: () async{
                            await Clipboard.setData(ClipboardData(text: code));
                            Toast.success(context, '代码复制成功!');
                          },
                          child: const TolyTooltip(
                              message: '复制代码',
                              gap: 20,
                              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                              child: Icon(Icons.copy_rounded, size: 20,color: Color(0xff828282),))),
                      const SizedBox(width: 16,),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: TolyTooltip(
                          message: '查看代码',
                          gap: 20,
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                          child: ToggleRotate(
                            child: const Icon(Icons.code, size: 22,color: Color(0xff828282)),
                            onEnd: (bool isExpanded) {
                              // 动画结束时间
                              // print("---expanded---:$isExpanded-------");
                            },
                            onTap: action, //点击事件
                          ),
                        ),
                      ),
                      // GestureDetector(onTap: action, child: Icon(Icons.code))
                    ],
                  ),
                );
              },
              content: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: const Color(0xfff5f7fa),
                child: HighlightView(
                  // The original code to be highlighted
                  code,

                  // Specify language
                  // It is recommended to give it a value for performance
                  language: 'dart',

                  // Specify highlight theme
                  // All available themes are listed in `themes` folder
                  // theme: tomorrowNightBlueTheme ,
                  theme: githubTheme ,
                  // theme: googlecodeTheme   ,
                  // theme: kimbieLightTheme    ,

                  // Specify padding
                  padding: const EdgeInsets.all(12),

                  // Specify text style
                  textStyle: const TextStyle(
                    fontFamily: 'Inconsolata',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),

    );
  }
}

