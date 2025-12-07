import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '步骤状态展示',
  desc: '展示步骤条的不同状态：完成、进行中、错误、禁用。通过不同的视觉样式区分各个步骤的状态，帮助用户快速了解流程进度和问题所在。支持自定义图标和颜色，适用于订单跟踪、任务进度、审批流程等需要明确状态展示的场景。',
)
class StepsDemo4 extends StatelessWidget {
  const StepsDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: 2,
      controlsBuilder: (context, details) => const SizedBox.shrink(),
      steps: const [
        Step(
          title: Text('订单提交'),
          subtitle: Text('2024-01-15 10:30'),
          content: SizedBox.shrink(),
          isActive: true,
          state: StepState.complete,
        ),
        Step(
          title: Text('支付完成'),
          subtitle: Text('2024-01-15 10:32'),
          content: SizedBox.shrink(),
          isActive: true,
          state: StepState.complete,
        ),
        Step(
          title: Text('商品出库'),
          subtitle: Text('处理中...'),
          content: SizedBox.shrink(),
          isActive: true,
          state: StepState.indexed,
        ),
        Step(
          title: Text('配送中'),
          subtitle: Text('等待处理'),
          content: SizedBox.shrink(),
          isActive: false,
          state: StepState.disabled,
        ),
        Step(
          title: Text('已签收'),
          subtitle: Text('等待处理'),
          content: SizedBox.shrink(),
          isActive: false,
          state: StepState.disabled,
        ),
      ],
    );
  }
}
