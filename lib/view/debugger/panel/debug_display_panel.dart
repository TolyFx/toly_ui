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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(image: AssetImage(image))),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          info1,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          info2,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (onClose != null) buildCloseButton()
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
