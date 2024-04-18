import 'package:flutter/material.dart';

import 'sponsor_panel.dart';
import 'sponsor_wall.dart';

class SponsorPage extends StatelessWidget {
  const SponsorPage({super.key});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (ctx, cts) =>  Row(
        children: [
          Expanded(
            child: SponsorPanel(
              showWall: cts.maxWidth<500,
            ),
          ),
          VerticalDivider(),
          if(cts.maxWidth>500)
          SponsorWall()
        ],
      ),
    );
  }
}
//          Text('TolyUI 为开源的免费项目:\n'
//               'https://github.com/TolyFx/toly_ui\n'
//               '。'),
