import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '水平步骤条',
  desc: '展示水平方向的步骤条布局。步骤从左到右依次排列，通过连接线串联各个步骤节点，视觉上更加紧凑。适用于表单向导、注册流程、配置引导等需要横向展示流程步骤的场景，特别适合在宽屏设备上使用。',
)
class StepsDemo5 extends StatefulWidget {
  const StepsDemo5({super.key});

  @override
  State<StepsDemo5> createState() => _StepsDemo5State();
}

class _StepsDemo5State extends State<StepsDemo5> {
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        controlsBuilder: (context, details) => const SizedBox.shrink(),
        steps: const [
          Step(
            title: Text('账号信息'),
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('请填写账号和密码'),
            ),
            isActive: true,
          ),
          Step(
            title: Text('个人资料'),
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('请完善个人信息'),
            ),
            isActive: true,
          ),
          Step(
            title: Text('完成注册'),
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('确认信息并提交'),
            ),
            isActive: true,
          ),
        ],
      ),
    );
  }
}
