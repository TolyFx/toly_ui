import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_carousel/toly_carousel.dart';

@DisplayNode(
  title: '箭头按钮',
  desc: '展示带有箭头按钮的轮播图。通过 arrows 属性启用左右箭头按钮，用户可以点击箭头切换页面。箭头会根据是否可以继续滑动自动调整透明度。',
)
class CarouselDemo6 extends StatelessWidget {
  const CarouselDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyCarousel(
      height: 200,
      arrows: true,
      infinite: false,
      children: [
        _buildSlide('1', Colors.blue),
        _buildSlide('2', Colors.green),
        _buildSlide('3', Colors.orange),
        _buildSlide('4', Colors.purple),
      ],
    );
  }

  Widget _buildSlide(String text, Color color) {
    return Container(
      color: color,
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
