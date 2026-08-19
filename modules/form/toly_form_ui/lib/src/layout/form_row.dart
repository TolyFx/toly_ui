import 'package:flutter/material.dart';

/// Figma 属性面板式标签与控件横向布局。
class TolyFormRow extends StatelessWidget {
  /// 字段标签。
  final Widget label;

  /// 字段控件。
  final Widget child;

  /// 标签列宽度。
  final double labelWidth;

  /// 标签与控件间距。
  final double spacing;

  /// 行底部间距。
  final double bottomSpacing;

  const TolyFormRow({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth = 72,
    this.spacing = 8,
    this.bottomSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: labelWidth, child: label),
          SizedBox(width: spacing),
          Expanded(child: child),
        ],
      ),
    );
  }
}
