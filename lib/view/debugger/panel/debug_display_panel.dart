import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DebugDisplayPanel extends StatelessWidget {
  final VoidCallback? onClose;
  final String title;
  final String image;
  final String info1;
  final String info2;

  const DebugDisplayPanel({
    super.key,
    this.onClose,
    required this.title,
    required this.image,
    required this.info1,
    required this.info2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 0,
              )
            ],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(image),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          info1,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          info2,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
        if(onClose!=null)
        buildCloseButton()
      ],
    );
  }

  Widget buildCloseButton() {
    return Positioned(
        right: 8,
        top: 8,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
              onTap: onClose,
              child: const Icon(
                CupertinoIcons.clear,
                size: 16,
                color: Color(0xffa8abb2),
              )),
        ));
  }
}
