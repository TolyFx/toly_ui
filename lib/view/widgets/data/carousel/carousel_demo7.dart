import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_carousel/tolyui_carousel.dart';

@DisplayNode(
  title: '指示器进度',
  desc: '展示指示器的进度动画效果。通过 dotDuration 属性启用指示器进度显示，在自动播放时，当前激活的指示器会显示进度条动画，直观展示切换倒计时。',
)
class CarouselDemo7 extends StatelessWidget {
  const CarouselDemo7({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyCarousel(
      height: 200,
      autoplay: true,
      autoplaySpeed: 5000,
      dotDuration: true,
      children: [
        _buildSlide('1', Colors.red),
        _buildSlide('2', Colors.blue),
        _buildSlide('3', Colors.green),
        _buildSlide('4', Colors.orange),
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
