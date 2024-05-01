import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonOverview extends StatelessWidget {
  const ButtonOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6)
          ]),
      child: Text(
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
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6)
              ]),
          child: Icon(
            Icons.pages_outlined,
            color: Colors.white,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6)
              ]),
          child: Icon(
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
    return Wrap(
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
    return
        Text(
          'Link Widget',
          style: TextStyle(
              fontSize: 24,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decorationColor: Colors.blue,
              // color: Colors.grey,
              decoration: TextDecoration.underline),

    );
  }
}

class LayoutOverview extends StatelessWidget {
  const LayoutOverview({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Color(0xffd4d7de);
    Color bg = Colors.white;
    Color tiledColor = Color(0xffe4e7ed);

    Widget box2 = Container(
      width: 40,
      height: 14,

      decoration: BoxDecoration(
        color: tiledColor,
        borderRadius: BorderRadius.circular(2)
      ),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ),
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                padding: EdgeInsets.all(6),
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
                        const SizedBox(height: 4,),
                        Expanded(
                          child: Container(
                            width: 20,
                            color: tiledColor,
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Expanded(
                          child: Container(
                            width: 20,
                            color: tiledColor,
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Expanded(
                          child: Container(
                            width: 20,
                            color: tiledColor,
                          ),
                        ),
                      ],
                    ),
                    VerticalDivider(width: 12,),

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