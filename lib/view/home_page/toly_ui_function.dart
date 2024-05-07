import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/app/logic/actions/navigation.dart';
import 'package:tolyui_rx_layout/tolyui_rx_layout.dart';

import '../../app/res/toly_icon.dart';
import '../../incubator/components/layout/grid_layout/wrap_grid_layout.dart';

List<FunPanelData> get kPanelDataList => [
      const FunPanelData(
        color: Colors.blue,
        icon: TolyIcon.iconMultiPlatform,
        title: '全平台支持',
        info: '支持全平台应用开发中的视图构建。Android、iOS、MacOS、Linux、Windows、Web',
        url: '',
      ),
      const FunPanelData(
        color: Colors.orange,
        icon: TolyIcon.iconLink,
        title: '组件化',
        info: '组件独立存在，可选择使用个体组件。不侵入你原有的项目代码结构。',
        url: '',
      ),
      const FunPanelData(
        color: Colors.green,
        icon: TolyIcon.iconOpenSrc,
        title: '源代码开放',
        info: 'MIT 开源协议，源代码完全公开，允许任何个人和企业使用。',
        url: kGithubUrl,
      ),
      const FunPanelData(
        color: Colors.red,
        icon: TolyIcon.iconReactive,
        title: '响应式布局',
        info: '根据设备屏幕信息，让视图可以响应式变化。',
        url: kRxLayoutUrl,
      ),
    ];

class TolyUIFunction extends StatelessWidget {
  const TolyUIFunction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 36.0),
          child: Text(
            '功能特性',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff606266)),
          ),
        ),
        Row$(
          padding: (r) => switch (r) {
            Rx.xs => const EdgeInsets.symmetric(horizontal: 24),
            Rx.sm => const EdgeInsets.symmetric(horizontal: 40),
            Rx.md => const EdgeInsets.symmetric(horizontal: 40),
            Rx.lg => const EdgeInsets.symmetric(horizontal: 40),
            Rx.xl => const EdgeInsets.symmetric(horizontal: 80),
          },
          gutter: (r) => switch (r) {
            Rx.xl => 28,
            Rx.sm => 24,
            Rx.md => 24,
            _ => 20,
          },
          verticalGutter: 20.0.rx,
          cells: kPanelDataList
              .map((data) => Cell(
                  child: ShowPanel(data: data),
                  span: (r) => switch (r) {
                        Rx.xs => 24,
                        Rx.sm => 12,
                        Rx.md => 12,
                        Rx.lg => 6,
                        Rx.xl => 6,
                      })).toList(),
        ),
      ],
    );
  }
}

class FunPanelData {
  final IconData icon;
  final Color color;
  final String title;
  final String info;
  final String url;

  const FunPanelData({
    required this.icon,
    required this.color,
    required this.title,
    required this.info,
    required this.url,
  });
}

class ShowPanel extends StatefulWidget {
  final FunPanelData data;

  const ShowPanel({
    super.key,
    required this.data,
  });

  @override
  State<ShowPanel> createState() => _ShowPanelState();
}

class _ShowPanelState extends State<ShowPanel> {
  bool hover = false;

  List<BoxShadow>? get shadow => hover
      ? [
          BoxShadow(
            color: Color(0xffe8f3ff),
            spreadRadius: 2,
            blurRadius: 6,
          )
        ]
      : null;


  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color labelColor = isDark?Colors.white: Color(0xff303133);

    return MouseRegion(
        onEnter: (_) {
          setState(() {
            hover = true;
          });
        },
        onExit: (_) {
          setState(() {
            hover = false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: (){
            String url = widget.data.url;
            if(url.isNotEmpty){
              if(url.startsWith('http')){
                jumpUrl(widget.data.url);
              }else{
                context.go(url);
              }
            }
          },
          child: Container(
            height: 240,
            decoration: BoxDecoration(
                boxShadow: shadow,
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: const Color(0xffdcdfe6)),
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(
                    widget.data.icon,
                    size: 60,
                    color: widget.data.color,
                  ),
                ),
                Text(
                  widget.data.title,
                  style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: labelColor),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.data.info,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Color(0xff99a9bf)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
