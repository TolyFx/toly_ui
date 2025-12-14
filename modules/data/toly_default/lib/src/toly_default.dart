import 'package:flutter/material.dart';
import 'default_type.dart';
import 'default_theme.dart';

/// 缺省页组件
class TolyDefault extends StatelessWidget {
  final DefaultType? type;
  final Widget? image;
  final String? title;
  final String? description;
  final Widget? action;
  final double? spacing;
  final double? imageSize;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  const TolyDefault({
    super.key,
    this.type,
    this.image,
    this.title,
    this.description,
    this.action,
    this.spacing,
    this.imageSize,
    this.iconColor,
    this.titleStyle,
    this.descriptionStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DefaultThemeScope.of(context);
    final effectiveSpacing = spacing ?? theme.spacing;
    final effectiveImageSize = imageSize ?? theme.iconSize;

    Widget? effectiveImage = image;
    String? effectiveTitle = title;
    String? effectiveDescription = description;

    if (type != null) {
      if (effectiveImage == null) {
        if (type!.imagePath != null) {
          effectiveImage = Image.asset(
            type!.imagePath!,
            width: effectiveImageSize,
            height: effectiveImageSize,
            fit: BoxFit.contain,
          );
        } else if (type!.icon != null) {
          effectiveImage = Icon(
            type!.icon,
            size: effectiveImageSize * 0.5,
            color: iconColor ?? theme.iconColor ?? Colors.grey,
          );
        }
      }
      effectiveTitle ??= type!.title;
      effectiveDescription ??= type!.description;
    }

    final defaultTitleStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xff303133),
    );

    final defaultDescStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xff909399),
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (effectiveImage != null)
            SizedBox(
              width: effectiveImageSize,
              height: effectiveImageSize,
              child: effectiveImage,
            ),
          if (effectiveImage != null &&
              (effectiveTitle != null || effectiveDescription != null || action != null))
            SizedBox(height: effectiveSpacing),
          if (effectiveTitle != null)
            Text(
              effectiveTitle,
              style: titleStyle ?? theme.titleStyle ?? defaultTitleStyle,
            ),
          if (effectiveTitle != null && (effectiveDescription != null || action != null))
            SizedBox(height: effectiveSpacing * 0.5),
          if (effectiveDescription != null)
            Text(
              effectiveDescription,
              textAlign: TextAlign.center,
              style: descriptionStyle ?? theme.descriptionStyle ?? defaultDescStyle,
            ),
          if (effectiveDescription != null && action != null)
            SizedBox(height: effectiveSpacing),
          if (action != null) action!,
        ],
      ),
    );
  }
}
