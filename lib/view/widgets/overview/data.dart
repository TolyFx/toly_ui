import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          child: Icon(
            Icons.account_box_rounded,
            color: Colors.white,
          ),
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
            child: Text(
              '49',
              style: TextStyle(fontSize: 10),
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
            grow: 1.5,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 20,
                color: hitColor,
              ),
              SizedBox(
                height: 8,
              )
            ],
          ),
          Divider(),
          const SizedBox(height: 4),
          DisplayTiled(depth: 1.2),
          DisplayTiled(grow: 1.6),
          DisplayTiled(depth: 1, grow: 1.5),
        ],
      ),
    );
  }
}

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image,
      size: 64,
      color: hitColor,
    );
  }
}

class PaginationDisplay extends StatelessWidget {
  const PaginationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: [
        Icon(
          Icons.keyboard_arrow_left,
          color: activeColor,
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(6)),
          child: Text(
            '1',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // color: activeColor,
              border: Border.all(color: hitColor),
              borderRadius: BorderRadius.circular(6)),
          child: Text('2', style: TextStyle(color: hitColor)),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // color: activeColor,
              border: Border.all(color: hitColor),
              borderRadius: BorderRadius.circular(6)),
          child: Text('3', style: TextStyle(color: hitColor)),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // color: activeColor,
              border: Border.all(color: hitColor),
              borderRadius: BorderRadius.circular(6)),
          child: Text('4', style: TextStyle(color: hitColor)),
        ),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // color: activeColor,
              border: Border.all(color: hitColor),
              borderRadius: BorderRadius.circular(6)),
          child: Text('5', style: TextStyle(color: hitColor)),
        ),
        Icon(Icons.keyboard_arrow_right, color: activeColor)
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
          const SizedBox(
            width: 8,
          ),
          Text('80%', style: TextStyle(color: activeColor))
        ],
      ),
    );
  }
}

class TagOverview extends StatelessWidget {
  const TagOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.blue.withOpacity(0.2), spreadRadius: 1, blurRadius: 6)
          ]),
      child: Row(
        children: [
          const Text(
            'Tag',
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
          Icon(
            Icons.close,
            size: 14,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class SkeletonOverview extends StatelessWidget {
  const SkeletonOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 136,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DisplayTiled(
            grow: 6,
            backgroundColor: Colors.transparent,
            height: 16,
            min: true,
          ),
          DisplayTiled(
            grow: 6,
            backgroundColor: Colors.transparent,
            height: 16,
            min: true,
          ),
          DisplayTiled(
            grow: 6,
            backgroundColor: Colors.transparent,
            height: 16,
            min: true,
          ),
          DisplayTiled(
            grow: 6,
            backgroundColor: Colors.transparent,
            height: 16,
            min: true,
          ),
          DisplayTiled(
            grow: 3,
            backgroundColor: Colors.transparent,
            height: 16,
            min: true,
          ),
        ],
      ),
    );
  }
}

class TreeDisplay extends StatelessWidget {
  const TreeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(4),
      //     border: Border.all(color: Color(0xffd9d9d9), width: 0.5),
      //     boxShadow: [
      //       BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
      //     ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DisplayTiled(
            backgroundColor: Colors.transparent,
            active: false,
            grow: 1.5,
            height: 16,
            borderRadius: BorderRadius.circular(4),
            leading: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.arrow_right_outlined,
                size: 14,
                color: hitColor,
              ),
            ),
          ),
          DisplayTiled(
            depth: 1,
            grow: 1.5,
            color: activeColor,
            backgroundColor: Colors.transparent,
            height: 16,
            leading: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.arrow_drop_down,
                size: 14,
                color: activeColor,
              ),
            ),
          ),
          DisplayTiled(
            depth: 3, height: 16,
            backgroundColor: Colors.transparent,
            grow: 1.5,
            // active: true,
          ),
          DisplayTiled(
            depth: 3,
            grow: 1.5,
            height: 16,
            backgroundColor: Colors.transparent,
          ),
          DisplayTiled(
            grow: 1.5,
            backgroundColor: Colors.transparent,
            height: 16,
            leading: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.arrow_right_outlined,
                size: 14,
                color: hitColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SegmentedDisplay extends StatelessWidget {
  const SegmentedDisplay({super.key});

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
      child: Row(
        children: [
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 32,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          )),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 32,
                decoration: BoxDecoration(
                  color: hitColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          )),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 32,
                decoration: BoxDecoration(
                  color: hitColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class StatisticsDisplay extends StatelessWidget {
  const StatisticsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Color(0xffd9d9d9), width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            width: 46,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: hitColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(
            "199,432",
            style: TextStyle(color: activeColor, fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: hitColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('12%', style: TextStyle(color: Colors.green, fontSize: 12),),
              ),
              Icon(Icons.keyboard_arrow_up_sharp,size: 12,color: Colors.green,)
            ],
          ),
        ],
      ),
    );
  }
}

class TableDisplay extends StatelessWidget {
  const TableDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color(0xffd9d9d9), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 表头
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: hitColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: hitColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: hitColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 分割线
          Container(
            height: 1,
            color: const Color(0xffd9d9d9),
          ),
          // 数据行
          ...List.generate(3, (index) => Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: index == 1 ? activeColor : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < 2) Container(
                height: 1,
                color: const Color(0xffd9d9d9),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
