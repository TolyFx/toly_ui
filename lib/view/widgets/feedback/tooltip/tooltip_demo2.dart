import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui/basic/basic.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

class TooltipDemo2 extends StatelessWidget {
  const TooltipDemo2({super.key});

  @override
  Widget build(BuildContext context) {
   return Wrap(
     spacing: 40,
     runSpacing: 20,
     crossAxisAlignment: WrapCrossAlignment.center,
     children: [
       buildTolyTooltipDisplay(),
       buildTolyTooltipDisplay2(),
       buildTolyTooltipDisplay3(),
     ],
   );
  }

  Widget buildTolyTooltipDisplay(){
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));
    const InlineSpan span = TextSpan(children: [
      TextSpan(text: '请通过此邮箱联系我们\n '),
      TextSpan(
        style: TextStyle(color: Colors.blue),
        text: '1981462002@qq.com ',
      )
    ]);
    return TolyTooltip(
      richMessage: span,
      placement: TooltipPlacement.top,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gap: 12,
      child: ElevatedButton(
          style: OutlineButtonPalette(
            borderRadius: BorderRadius.circular(20),
            foregroundPalette: foreground,
            borderPalette: border,
            backgroundPalette: bg,
          ).style,
          // FillButtonPalette(
          //   borderRadius: BorderRadius.circular(20),
          //   palette: const Palette(
          //     normal: Color(0xff1890ff),
          //     hover: Color(0xffecf5ff),
          //     foregroundPalette: Color(0xff606266),
          //     pressed: Color(0xff096dd9),
          //   ),
          // ).style

          onPressed: () {
            // context.go('/sponsor');
          },
          child: const Text('成为赞助商!')),
    );
  }
  Widget buildTolyTooltipDisplay2(){
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));
    return TolyTooltip(
      richMessage: TextSpan(
          children: [
        WidgetSpan(
          alignment:PlaceholderAlignment.middle,
            child: FlutterLogo()),
        TextSpan(
          text: ' Flutter是Google开源的 ',
        ),
            TextSpan(
              text: '构建用户界面（UI）工具包',
              style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold)
            ),
            TextSpan(
              text:
                  '，帮助开发者通过一套代码库高效构建多平台精美应用，支持移动、Web、桌面和嵌入式平台。 Flutter 开源、免费，拥有宽松的开源协议，适合商业项目。',
            ),
      ]),
      placement: TooltipPlacement.top,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gap: 12,
      child: ElevatedButton(
          style: OutlineButtonPalette(
            borderRadius: BorderRadius.circular(20),
            foregroundPalette: foreground,
            borderPalette: border,
            backgroundPalette: bg,
          ).style,
          onPressed: () {
            // context.go('/sponsor');
          },
          child: const Text('Flutter 介绍')),
    );
  }
  Widget buildTolyTooltipDisplay3(){
    return TolyTooltip(

      richMessage: const TextSpan(
        children: <InlineSpan>[
          TextSpan(
              text: ' TolyUI',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          TextSpan(text: '是'),
          TextSpan(
            text: '张风捷特烈',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
          TextSpan(text: '打造的 Flutter('),
          WidgetSpan(
              child: FlutterLogo(size: 14),
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.ideographic),
          TextSpan(text: ')全平台响应式应用开发 UI 框架'),
          TextSpan(
              text: '全平台响应式',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  decoration: TextDecoration.underline)),
          TextSpan(text: '应用开发 UI 框架'),
          TextSpan(text: '具备'),
          TextSpan(
            text: '全平台',
            style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '、'),
          TextSpan(
              text: '组件化',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          TextSpan(text: '、'),
          TextSpan(
              text: '源码开放',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          TextSpan(text: '、'),
          TextSpan(
              text: '响应式',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          TextSpan(text: '四大特点。'),
          TextSpan(
            text: '提供大量 Flutter 框架内部之外的常用组件，帮助开发者迅速构建具有响应式的全平台应用软件。',
          ),
        ],
      ),
      placement: TooltipPlacement.left,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gap: 18,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TolyLink(
          text: 'TolyUI', href: '', onTap: (String value) {  },
        ),
      ),
    );
  }
}
