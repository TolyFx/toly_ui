import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_carousel/tolyui_carousel.dart';

@DisplayNode(
  title: '淡入淡出效果',
  desc: '展示淡入淡出切换效果。通过 effect 属性设置为 fade，页面切换时会使用淡入淡出动画，而不是默认的滑动效果。这种效果适合图片展示等场景。',
)
class CarouselDemo3 extends StatelessWidget {
  const CarouselDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyCarousel(
      height: 200,
      effect: CarouselEffect.fade,
      autoplay: true,
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
