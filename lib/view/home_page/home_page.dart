
import 'package:flutter/material.dart';

import 'package:toly_ui/view/home_page/cooperation_panel.dart';
import 'dart:ui' as ui;

import 'home_footer.dart';
import 'link_panel.dart';
import 'toly_ui_desc.dart';
import 'toly_ui_function.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SliverGridDelegate gridDelegate =
        const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 320,
      mainAxisSpacing: 10,
      mainAxisExtent: 240,
      crossAxisSpacing: 10,
    );
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
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



