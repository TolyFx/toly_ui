import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '基础步骤条',
  desc: '展示步骤条的基本用法，通过水平或垂直布局呈现多个步骤。每个步骤包含标题和可选的副标题，当前步骤会高亮显示。适用于表单填写、任务流程、引导页等需要分步骤完成的场景。',
)
class StepsDemo1 extends StatefulWidget {
  const StepsDemo1({super.key});

  @override
  State<StepsDemo1> createState() => _StepsDemo1State();
}

class _StepsDemo1State extends State<StepsDemo1> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stepper(
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          steps: const [
            Step(
              title: Text('选择商品'),
              subtitle: Text('浏览并选择心仪商品'),
              content: SizedBox.shrink(),
              isActive: true,
            ),
            Step(
              title: Text('确认订单'),
              subtitle: Text('核对商品信息'),
              content: SizedBox.shrink(),
            ),
            Step(
              title: Text('支付'),
              subtitle: Text('选择支付方式'),
              content: SizedBox.shrink(),
            ),
            Step(
              title: Text('完成'),
              subtitle: Text('等待发货'),
              content: SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}
