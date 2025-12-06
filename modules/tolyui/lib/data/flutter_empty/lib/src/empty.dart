import 'package:flutter/material.dart';
import 'empty_images.dart';
import 'types.dart';

/// Ant Design Empty 组件的 Flutter 实现
class AntEmpty extends StatelessWidget {
  const AntEmpty({
    super.key,
    this.image,
    this.description,
    this.children,
    this.imageStyle,
    this.style,
    this.classNames,
    this.styles,
  });

  /// 自定义图片，可以是 Widget、String(图片URL) 或 EmptyImageType
  final dynamic image;
  
  /// 描述文本
  final Widget? description;
  
  /// 底部内容（通常是按钮）
  final Widget? children;
  
  /// 图片样式（已废弃，请使用 styles.image）
  @Deprecated('Please use styles.image instead')
  final BoxDecoration? imageStyle;
  
  /// 根容器样式
  final BoxDecoration? style;
  
  /// 类名配置
  final EmptyClassNames? classNames;
  
  /// 样式配置
  final EmptyStyles? styles;

  /// 预设的默认图片
  static const Widget presentedImageDefault = DefaultEmptyImage();
  
  /// 预设的简单图片
  static const Widget presentedImageSimple = SimpleEmptyImage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // 处理描述文本
    final Widget? descriptionWidget = description ?? 
        Text(
          '暂无数据',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.45),
            fontSize: 14,
          ),
        );
    
    // 处理图片
    Widget imageWidget = _buildImageWidget(context);
    
    return Container(
      decoration: style ?? styles?.root,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 图片区域
          Container(
            decoration: imageStyle ?? styles?.image,
            child: imageWidget,
          ),
          
          // 描述区域
          if (descriptionWidget != null) ...[
            const SizedBox(height: 8),
            DefaultTextStyle(
              style: styles?.description ?? 
                  TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.45),
                    fontSize: 14,
                  ),
              child: descriptionWidget,
            ),
          ],
          
          // 底部内容区域
          if (children != null) ...[
            const SizedBox(height: 16),
            Container(
              decoration: styles?.footer,
              child: children,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageWidget(BuildContext context) {
    if (image == null) {
      return presentedImageDefault;
    }
    
    if (image is Widget) {
      return image as Widget;
    }
    
    if (image is String) {
      return Image.network(
        image as String,
        errorBuilder: (context, error, stackTrace) => presentedImageDefault,
      );
    }
    
    if (image is EmptyImageType) {
      switch (image as EmptyImageType) {
        case EmptyImageType.defaultImage:
          return presentedImageDefault;
        case EmptyImageType.simple:
          return presentedImageSimple;
      }
    }
    
    return presentedImageDefault;
  }
}