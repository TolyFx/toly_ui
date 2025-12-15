import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_carousel/tolyui_carousel.dart';

@DisplayNode(
  title: '指示器位置',
  desc: '展示不同的指示器位置配置。通过 dotPlacement 属性可以将指示器放置在顶部、底部、左侧或右侧。示例展示了四种位置的效果，适配不同的布局需求。',
)
class CarouselDemo4 extends StatelessWidget {
  const CarouselDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildCarousel('顶部', DotPlacement.top),
        _buildCarousel('底部', DotPlacement.bottom),
        _buildCarousel('左侧', DotPlacement.start),
        _buildCarousel('右侧', DotPlacement.end),
      ],
    );
  }

  Widget _buildCarousel(String label, DotPlacement placement) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        SizedBox(
          width: 280,
          height: 160,
          child: TolyCarousel(
            dotPlacement: placement,
            children: [
              _buildSlide('1'),
              _buildSlide('2'),
              _buildSlide('3'),
            ],
          ),
        ),
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
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
