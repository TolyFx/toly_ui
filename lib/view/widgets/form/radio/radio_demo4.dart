import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '列表单选',
  desc: '展示列表形式的单选按钮。通过 RadioListTile 可以创建带标题、副标题的单选列表项，提供更丰富的信息展示。适用于支付方式选择、配送地址选择、套餐选择等需要详细说明的场景。',
)
class RadioDemo4 extends StatefulWidget {
  const RadioDemo4({super.key});

  @override
  State<RadioDemo4> createState() => _RadioDemo4State();
}

class _RadioDemo4State extends State<RadioDemo4> {
  String _value = 'wechat';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          value: 'wechat',
          groupValue: _value,
          title: const Text('微信支付'),
          subtitle: const Text('推荐使用，快捷安全'),
          secondary: const Icon(Icons.payment, color: Colors.green),
          onChanged: (value) => setState(() => _value = value!),
        ),
        RadioListTile<String>(
          value: 'alipay',
          groupValue: _value,
          title: const Text('支付宝'),
          subtitle: const Text('支持花呗分期'),
          secondary: const Icon(Icons.account_balance_wallet, color: Colors.blue),
          onChanged: (value) => setState(() => _value = value!),
        ),
        RadioListTile<String>(
          value: 'card',
          groupValue: _value,
          title: const Text('银行卡'),
          subtitle: const Text('支持储蓄卡和信用卡'),
          secondary: const Icon(Icons.credit_card, color: Colors.orange),
          onChanged: (value) => setState(() => _value = value!),
        ),
      ],
    );
  }
}
