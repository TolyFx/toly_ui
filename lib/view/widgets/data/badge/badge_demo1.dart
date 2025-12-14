import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/basic/basic.dart';

@DisplayNode(
  title: 'Badge 圆点标记的使用',
  desc: '在指定的子组件上，展示小圆点。注意自定义 label 时 offset 才会生效，如下第三个案例：',
)
class BadgeDemo1 extends StatelessWidget {
  const BadgeDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    Widget child = TolyAction(
      selected: true,
      child: const Icon(Icons.update, size: 24, color: Colors.green),
      onTap: () {},
    );

    return Wrap(
      spacing: 20,
      children: [
        Badge(
          backgroundColor: Colors.redAccent,
          smallSize: 6,
          child: child,
        ),
        Badge(
          backgroundColor: Colors.orange,
          alignment: Alignment.bottomRight,
          smallSize: 8,
          child: child,

        ),
        Badge(
          largeSize: 14,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          offset: Offset(5, -5),
          label: ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                    // border: Border.all( width: 2),
                    color: Colors.blue,
                    shape: BoxShape.circle),
                width: 8,
                height: 8,
              ),
            ),
          ),
          // alignment: Alignment.center,
          child: child,
        ),
        Badge(
          backgroundColor: Colors.redAccent,
          smallSize: 6,
          isLabelVisible: false,
          child: child,
        ),
      ],
    );
  }
}
