import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_carousel/tolyui_carousel.dart';

@DisplayNode(
  title: '基础轮播',
  desc: '展示轮播图的基础用法。通过 children 属性传入子组件列表，组件会自动循环展示。底部的指示器显示当前位置，点击指示器可以快速跳转到对应页面。',
)
class CarouselDemo1 extends StatelessWidget {
  const CarouselDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyCarousel(
      height: 200,
      children: [
        _buildSlide('1'),
        _buildSlide('2'),
        _buildSlide('3'),
        _buildSlide('4'),
      ],
    );
  }

  Widget _buildSlide(String text) {
    return Container(
      color: Color(0xff3f51b5),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 48,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
