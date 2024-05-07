import 'package:flutter/material.dart';
import 'package:tolyui/basic/basic.dart';

import 'contact_me.dart';
import 'sponsor_panel.dart';
import 'sponsor_wall.dart';

class SponsorPage extends StatelessWidget {
  const SponsorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: WindowRespondBuilder(
        builder: (BuildContext context, Rx type) {
          bool small = type.index > 1;
          return Row(
            children: [
              if (small) const ContactMe(),
              if (small) const VerticalDivider(),
              Expanded(child: SponsorPanel(small: !small)),
              if (small) const VerticalDivider(),
              if (small) const SponsorWall()
            ],
          );
        },
      ),
    );
  }
}

