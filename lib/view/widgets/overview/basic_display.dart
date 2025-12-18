import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tolyui/basic/basic.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_text/tolyui_text.dart';

class ActionOverview extends StatelessWidget {
  const ActionOverview({super.key});

  @override
  Widget build(BuildContext context) {
    ActionStyle style = ActionStyle(
      borderRadius: BorderRadius.circular(4),
      padding: const EdgeInsets.all(4),
      backgroundColor: Colors.blue.withOpacity(0.1),
      border:
          Border.all(color: context.isDark ? Colors.blueAccent : Colors.blue),
      selectColor: Colors.blue.withOpacity(0.2),
    );
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Wrap(
          spacing: 4,
          children: [
            TolyAction(
              onTap: () {},
              child: Icon(CupertinoIcons.wand_rays),
            ),
            TolyAction(
              selected: true,
              style: style,
              onTap: () {},
              child: Icon(CupertinoIcons.move),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonOverview extends StatelessWidget {
  const ButtonOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6)
          ]),
      child: const Text(
        'Event',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class IconOverview extends StatelessWidget {
  const IconOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6)
              ]),
          child: const Icon(
            Icons.pages_outlined,
            color: Colors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6)
              ]),
          child: const Icon(
            Icons.insights,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class TextOverview extends StatelessWidget {
  const TextOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        Text(
          'Toly',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          'UI',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              height: 1),
        ),
        Text(
          'Design',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}

class LinkOverview extends StatelessWidget {
  const LinkOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'TOLY LINK',
          style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decorationColor: Colors.blue,
              // color: Colors.grey,
              decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}

class LayoutOverview extends StatelessWidget {
  const LayoutOverview({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xffd4d7de);
    Color bg = Colors.white;
    Color tiledColor = const Color(0xffe4e7ed);

    Widget box2 = Container(
      width: 40,
      height: 14,
      decoration: BoxDecoration(
          color: tiledColor, borderRadius: BorderRadius.circular(2)),
    );
    return Wrap(
      spacing: 12,
      children: [
        Container(
          width: 130,
          // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6)
              ]),
          child: Column(
            children: [
              Container(
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ),
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: 20,
                            color: tiledColor,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          child: Container(
                            width: 20,
                            color: tiledColor,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          child: Container(
                            width: 20,
                            color: tiledColor,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          child: Container(
                            width: 20,
                            color: tiledColor,
                          ),
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      width: 12,
                    ),
                    Expanded(
                      child: Center(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: List.generate(6, (index) => box2),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Icon(
              //   Icons.insights,
              //   color: Colors.black,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class TolyuiTextOverview extends StatelessWidget {
  const TolyuiTextOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
          ),
          HighlightText.withArg(
            'TolyUI',
            arg: 'To',
            highlightStyle: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            style: TextStyle(
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}
