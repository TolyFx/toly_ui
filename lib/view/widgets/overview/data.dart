import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/example/tolyui_rx_layout/tolyui_rx_layout.dart';
import 'package:tolyui/tolyui.dart';

import 'navigation_display.dart';

class AvatarDisplay extends StatelessWidget {
  const AvatarDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
         CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Icon(Icons.account_box_rounded,color: Colors.white,),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
            boxShadow: [
              BoxShadow(color: Colors.blue.withOpacity(0.25), blurRadius: 4, spreadRadius: 2),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(1.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/me.webp"),
            ),
          ),
        )
      ],
    );
  }
}

class BadgeDisplay extends StatelessWidget {
  const BadgeDisplay({super.key});

  @override
  Widget build(BuildContext context) {

    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Badge(
          largeSize: 14,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          offset: Offset(5, -5),
          label: DecoratedBox(
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                width: 8,
                height: 8,
              ),
            ),
          ),
          // alignment: Alignment.center,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: Colors.cyanAccent.withOpacity(0.3)),
          ),
        ),
        Badge(
          largeSize: 14,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          offset: Offset(2, -5),
          label: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('49',style: TextStyle(fontSize: 10),),
          ),
          // alignment: Alignment.center,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: Colors.orange.withOpacity(0.3)),
          ),
        ),
      ],
    );
  }
}

class CardDisplay extends StatelessWidget {
  const CardDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Color(0xffd9d9d9), width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                child: Text(
                  'Card',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Spacer(),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 6,
                    width: 24,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              )),
            ],
          ),
          Divider(),
          const SizedBox(
            height: 8,
          ),
          DisplayTiled(depth: 1),
          DisplayTiled(
            grow: 2,
          ),
          DisplayTiled(
            depth: 1,
            grow: 1.5,
          ),
        ],
      ),
    );
  }
}

class CollapseDisplay extends StatelessWidget {
  const CollapseDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Color(0xffd9d9d9), width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                child: Container(
                  height: 6,
                  width: 32,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: hitColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Spacer(),
              Icon(Icons.keyboard_arrow_down_sharp,size: 20,color: hitColor,),
              SizedBox(height: 8,)
            ],
          ),
          Divider(),
          const SizedBox(height: 4),
          DisplayTiled(depth: 1.2),
          DisplayTiled(grow: 1.6),
          DisplayTiled(depth: 1, grow: 2),
        ],
      ),
    );
  }
}

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.image,size: 64,color: hitColor,);
  }
}

class PaginationDisplay extends StatelessWidget {
  const PaginationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: [
        Icon(Icons.keyboard_arrow_left,color: activeColor,),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(6)
          ),
          child: Text('1',style: TextStyle(color: Colors.white),),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // color: activeColor,
            border: Border.all(
              color: hitColor
            ),
              borderRadius: BorderRadius.circular(6)
          ),
          child: Text('2',style: TextStyle(color: hitColor)),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // color: activeColor,
              border: Border.all(
                  color: hitColor
              ),
              borderRadius: BorderRadius.circular(6)
          ),
          child: Text('3',style: TextStyle(color: hitColor)),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // color: activeColor,
              border: Border.all(
                  color: hitColor
              ),
              borderRadius: BorderRadius.circular(6)
          ),
          child: Text('4',style: TextStyle(color: hitColor)),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // color: activeColor,
              border: Border.all(
                  color: hitColor
              ),
              borderRadius: BorderRadius.circular(6)
          ),
          child: Text('5',style: TextStyle(color: hitColor)),
        ),
        Icon(Icons.keyboard_arrow_right,color: activeColor)
      ],
    );
  }
}

class ProgressDisplay extends StatelessWidget {
  const ProgressDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              color: activeColor,
              borderRadius: BorderRadius.circular(2),
              value: 0.8,
            ),
          ),
          const SizedBox(width: 8,),
          Text('80%',style: TextStyle(color: activeColor))
        ],
      ),
    );
  }
}

