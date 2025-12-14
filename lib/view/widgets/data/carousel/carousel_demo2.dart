import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_carousel/toly_carousel.dart';

@DisplayNode(
  title: '自动播放',
  desc: '展示自动播放功能。通过 autoplay 属性启用自动播放，autoplaySpeed 设置切换间隔时间。轮播图会按照设定的时间间隔自动切换到下一页，鼠标悬停时不会暂停。',
)
class CarouselDemo2 extends StatelessWidget {
  const CarouselDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyCarousel(
      height: 200,
      autoplay: true,
      autoplaySpeed: 2000,
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
