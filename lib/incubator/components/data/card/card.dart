import 'package:flutter/material.dart';

class TolyCard extends StatefulWidget {
  final Widget content;
  final Widget? header;
  final Widget? footer;
  final ShadowType shadow;
  final Color cardColor;
  final double radius;

  const TolyCard({
    super.key,
    required this.content,
    this.header,
    this.footer,
    this.shadow = ShadowType.none,
    this.cardColor = Colors.white,
    this.radius = 10,
  });

  @override
  State<TolyCard> createState() => _TolyCardState();
}

class _TolyCardState extends State<TolyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
    );
  }
}

/// 阴影类型
/// shadow
///
enum ShadowType {
  top,
  topLeft,
  topRight,
  all,
  bottom,
  bottomLeft,
  bottomRight,
  none,
}
