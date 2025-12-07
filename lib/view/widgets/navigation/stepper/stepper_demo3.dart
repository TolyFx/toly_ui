import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '垂直步骤条',
  desc: '展示垂直布局的步骤条，适合内容较多或需要详细说明的场景。垂直布局能够为每个步骤提供更多的展示空间，便于呈现复杂的表单或详细的操作说明。常用于安装向导、配置流程、审批流程等需要详细步骤说明的场景。',
)
class StepsDemo3 extends StatefulWidget {
  const StepsDemo3({super.key});

  @override
  State<StepsDemo3> createState() => _StepsDemo3State();
}

class _StepsDemo3State extends State<StepsDemo3> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.vertical,
      currentStep: _currentStep,
      onStepTapped: (step) => setState(() => _currentStep = step),
      controlsBuilder: (context, details) => const SizedBox.shrink(),
      steps: [
        Step(
          title: const Text('项目初始化'),
          subtitle: const Text('创建项目结构'),
          content: const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• 创建项目目录'),
                Text('• 初始化 Git 仓库'),
                Text('• 配置项目依赖'),
                Text('• 设置开发环境'),
              ],
            ),
          ),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('开发阶段'),
          subtitle: const Text('编写核心功能'),
          content: const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• 实现业务逻辑'),
                Text('• 编写单元测试'),
                Text('• 代码审查'),
                Text('• 性能优化'),
              ],
            ),
          ),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('测试阶段'),
          subtitle: const Text('质量保证'),
          content: const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• 功能测试'),
                Text('• 集成测试'),
                Text('• 用户验收测试'),
                Text('• Bug 修复'),
              ],
            ),
          ),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('部署上线'),
          subtitle: const Text('发布到生产环境'),
          content: const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• 构建生产版本'),
                Text('• 部署到服务器'),
                Text('• 监控运行状态'),
                Text('• 用户反馈收集'),
              ],
            ),
          ),
          isActive: _currentStep >= 3,
          state: StepState.indexed,
        ),
      ],
    );
  }
}
