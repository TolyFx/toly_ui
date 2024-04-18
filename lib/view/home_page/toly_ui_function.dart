import 'package:flutter/material.dart';

import '../../app/res/toly_icon.dart';
import '../../incubator/components/layout/grid_layout/wrap_grid_layout.dart';

class TolyUIFunction extends StatelessWidget {
  const TolyUIFunction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 36.0),
          child: Text(
            '组件库特性',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xff606266)),),
        ),
        WrapGridLayout(
          maxWidth: 300,
          height: 240,
          spacing: 24,
          runSpacing: 12,
          children: [
            ShowPanel(
              color: Colors.blue,
              icon: TolyIcon.iconMultiPlatform,
              title: '全平台支持',
              info:
              '支持全平台应用开发中的视图构建。Android、iOS、MacOS、Linux、Windows、Web',
            ),
            ShowPanel(
              color: Colors.orange,
              icon: TolyIcon.iconLink,
              title: '组件化',
              info: '组件独立存在，可选择使用个体组件。不侵入你原有的项目代码结构。',
            ),
            ShowPanel(
              color: Colors.green,
              icon: TolyIcon.iconOpenSrc,
              title: '源代码开放',
              info: 'MIT 开源协议，源代码完全公开，允许任何个人和企业使用。',
            ),
            ShowPanel(
              color: Colors.red,
              icon: TolyIcon.iconReactive,
              title: '响应式布局',
              info: '根据设备屏幕信息，让视图可以响应式变化。',
            ),
          ],
        )
      ],
    );
  }
}

class ShowPanel extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String info;

  const ShowPanel(
      {super.key,
        required this.title,
        required this.info,
        required this.icon,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffdcdfe6)),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Icon(
              icon,
              size: 60,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff303133)),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            info,
            style: TextStyle(fontSize: 14, color: Color(0xff99a9bf)),
          ),
        ],
      ),
    );
  }
}
