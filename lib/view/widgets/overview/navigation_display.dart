import 'package:flutter/material.dart';

class BreadcrumbDisplay extends StatelessWidget {
  const BreadcrumbDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 18,
              decoration: BoxDecoration(
                color: Color(0xffe4e7ed),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              "/",
              style: TextStyle(color: Color(0xffcdcdcd)),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xffe4e7ed),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              "/",
              style: TextStyle(color: Color(0xffcdcdcd)),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xffcbe4f9),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropMenuDisplay extends StatelessWidget {
  const DropMenuDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 26,
          width: 64,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
              ]),
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Color(0xffcbe4f9),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          margin: const EdgeInsets.only(left: 48, right: 48),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffd9d9d9)), borderRadius: BorderRadius.circular(4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xffe4e7ed),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Container(
                  height: 8,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xffcbe4f9),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Container(
                  height: 8,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Color(0xff2196f3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xffe4e7ed),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Container(
                  height: 8,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class RailMenuTreeDisplay extends StatelessWidget {
  const RailMenuTreeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Color(0xffd9d9d9), width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
          ]),
      child: Column(
        children: [
          DisplayTiled(
            active: false,
            color: activeColor,
            borderRadius: BorderRadius.circular(4),
            tailing: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 12,
                color: activeColor,
              ),
            ),
          ),
          DisplayTiled(
            depth: 2,
          ),
          DisplayTiled(
            depth: 2,
            active: true,
          ),
          DisplayTiled(depth: 2),
          DisplayTiled(),
          DisplayTiled(),
        ],
      ),
    );
  }
}



class RailMenuBarDisplay extends StatelessWidget {
  const RailMenuBarDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      padding: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Color(0xffd9d9d9), width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
          ]),
      child: Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.indigoAccent.shade100,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: hitColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: hitColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: hitColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}


class AnchorDisplay extends StatelessWidget {
  const AnchorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              width: 2,
              color: hitColor,
            ),
            Positioned(
              top: 48,
              child: Container(
                height: 18,
                width: 2,
                color: activeColor,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16,),
        Container(
          width: 96,
          margin: const EdgeInsets.only(top: 12, bottom: 12),
          child: Column(
            children: [
              DisplayTiled(
                active: false,
                borderRadius: BorderRadius.circular(4),
              ),
              DisplayTiled(
                depth: 2,
              ),
              DisplayTiled(
                depth: 2,
                active: true,
              ),
              DisplayTiled(depth: 2),
              DisplayTiled(),
              DisplayTiled(),
            ],
          ),
        ),
      ],
    );
  }
}


class DisplayTiled extends StatelessWidget {
  final double height;
  final bool active;
  final double depth;
  final double grow;
  final double width;
  final Widget? tailing;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const DisplayTiled(
      {super.key,
      this.active = false,
      this.height = 18,
      this.width = 32,
      this.depth = 1,
      this.grow = 1,
      this.color,
      this.borderRadius,
      this.tailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration:
          BoxDecoration(color: active ? activeColor : Colors.white, borderRadius: borderRadius),
      child: Row(
        children: [
          SizedBox(
            width: 12 * depth,
          ),
          Container(
            height: 6,
            width: 32*grow,
            decoration: BoxDecoration(
              color: color??(active ? Colors.white : hitColor),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Spacer(),
          if (tailing != null) tailing!
        ],
      ),
    );
  }
}

class TabsDisplay extends StatelessWidget {
  const TabsDisplay({super.key});

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
              Expanded(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 6,
                    width: 32,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              )),
              Expanded(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 6,
                    width: 32,
                    decoration: BoxDecoration(
                      color: hitColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              )),
              Expanded(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 6,
                    width: 32,
                    decoration: BoxDecoration(
                      color: hitColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              )),
            ],
          ),
          LinearProgressIndicator(value: 1/3,minHeight: 1,color: activeColor,),
          const SizedBox(height: 8,),
          DisplayTiled(depth: 1),
          DisplayTiled(grow: 2,),
          DisplayTiled(depth: 1,grow: 1.5,),
        ],
      ),
    );
  }
}
class StepsDisplay extends StatelessWidget {
  const StepsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 12, bottom: 12),

      child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: activeColor.withOpacity(0.2),
                          shape: BoxShape.circle
                        ),
                        child: Icon(Icons.check,size: 10,color: activeColor,),
                      ),
                      Expanded(child: VerticalDivider(indent: 2,endIndent: 2,))
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Step1",style: TextStyle(fontSize: 12),),
                      Text("description",style: TextStyle(fontSize: 10,color: Colors.grey),),
                    ],
                  )
                ],
              )),
              Expanded(child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 16,
                        alignment: Alignment.center,
                        width: 16,
                        decoration: BoxDecoration(
                            color: activeColor,
                            shape: BoxShape.circle
                        ),
                        child: Text('2',style: TextStyle(height: 1,fontSize: 10,color: Colors.white),),
                      ),
                      Expanded(child: VerticalDivider(indent: 2,endIndent: 2,))
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Step2",style: TextStyle(fontSize: 12),),
                      Text("description",style: TextStyle(fontSize: 10,color: Colors.grey),),
                    ],
                  )
                ],
              )),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 16,
                          alignment: Alignment.center,
                          width: 16,
                          decoration: BoxDecoration(
                              color: hitColor,
                              shape: BoxShape.circle
                          ),
                          child: Text('3',style: TextStyle(height: 1,fontSize: 10,color: Colors.grey),),

                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Step3",style: TextStyle(fontSize: 12),),
                        Text("description",style: TextStyle(fontSize: 10,color: Colors.grey),),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
    );
  }
}


Color get activeColor => Color(0xff2196f3);

Color get hitColor => Color(0xffd4d7de);
