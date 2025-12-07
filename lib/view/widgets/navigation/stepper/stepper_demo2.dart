import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '可交互步骤条',
  desc: '展示带有完整交互的步骤条。用户可以通过上一步、下一步按钮控制流程进度，每个步骤都有对应的内容展示。支持步骤验证和状态管理，适用于多步骤表单、注册流程、配置向导等需要用户逐步完成的场景。',
)
class StepsDemo2 extends StatefulWidget {
  const StepsDemo2({super.key});

  @override
  State<StepsDemo2> createState() => _StepsDemo2State();
}

class _StepsDemo2State extends State<StepsDemo2> {
  int _currentStep = 0;

  void _onStepContinue() {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
      $message.success(message: '进入下一步');
    } else {
      $message.success(message: '流程完成！');
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
      $message.info(message: '返回上一步');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: _onStepContinue,
      onStepCancel: _onStepCancel,
      onStepTapped: (step) => setState(() => _currentStep = step),
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(_currentStep == 2 ? '完成' : '下一步'),
              ),
              const SizedBox(width: 8),
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('上一步'),
                ),
            ],
          ),
        );
      },
      steps: [
        Step(
          title: const Text('账号信息'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('个人资料'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: '姓名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: '邮箱',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('确认提交'),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('请确认您的信息：'),
              SizedBox(height: 8),
              Text('用户名：example_user'),
              Text('姓名：张三'),
              Text('邮箱：example@email.com'),
            ],
          ),
          isActive: _currentStep >= 2,
          state: StepState.indexed,
        ),
      ],
    );
  }
}
