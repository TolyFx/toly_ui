import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_default/toly_default.dart';
import 'package:tolyui_message/tolyui_message.dart';

@DisplayNode(
  title: '自定义样式的缺省页',
  desc: '展示缺省页的自定义能力。可以调整图片尺寸、元素间距，使用自定义图片或插画，以及添加多个操作按钮，灵活适配不同的设计需求和业务场景。',
)
class DefaultDemo4 extends StatelessWidget {
  const DefaultDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyDefault(
      image: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.shopping_cart_outlined,
          size: 50,
          color: Colors.blue.shade300,
        ),
      ),
      imageSize: 100,
      title: '购物车是空的',
      description: '还没有添加任何商品\n快去挑选心仪的商品吧',
      spacing: 18,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            onPressed: () {
              $message.info(message: '查看收藏');
            },
            child: Text('查看收藏'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              $message.success(message: '前往商品列表');
            },
            child: Text('去逛逛'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
