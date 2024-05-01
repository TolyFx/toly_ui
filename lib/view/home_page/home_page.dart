
import 'package:flutter/material.dart';

import 'package:toly_ui/view/home_page/cooperation_panel.dart';

import 'home_footer.dart';
import 'link_panel.dart';
import 'toly_ui_desc.dart';
import 'toly_ui_function.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  TolyUIDesc(),
                  TolyUIFunction(),
                  CooperationPanel(),
                  Divider(),
                  LinkPanel(),
                  HomeFooter(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

///CustomScrollView(
//                 slivers: [
//                   const SliverToBoxAdapter(
//                       child: TolyUIDesc(),
//                     ),
//                   const SliverToBoxAdapter(
//                     child: TolyUIFunction(),
//                   ),
//                    SliverToBoxAdapter(
//                     child: CooperationPanel(),
//                   ),
//
//                    SliverToBoxAdapter(
//                     child: HomeFooter(),
//                   ),
//                 ],
//               )



