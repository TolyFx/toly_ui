import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:platform_adapter/platform_adapter.dart';

class DeskTopLogo extends StatelessWidget {
  const DeskTopLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return DragToMoveWrapper(
      child: ColoredBox(
        color: Colors.white,
        child: SizedBox(
          height: 78,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildLogo(),
                    _buildText(),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        semanticsLabel: 'Acme Logo',
        width: 42,
        height: 42,
      ),
    );
  }

  Widget _buildText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Fx',
          style:
              TextStyle(height: 1, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '全平台架构',
          style: TextStyle(
              color: Colors.grey, height: 1, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
