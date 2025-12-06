import 'package:flutter/material.dart';
import 'types.dart';

class Tag extends StatefulWidget {
  final String? className;
  final Color? color;
  final TagVariant variant;
  final bool closable;
  final Widget? closeIcon;
  final VoidCallback? onClose;
  final Widget? icon;
  final bool disabled;
  final String? href;
  final VoidCallback? onTap;
  final Widget? child;
  final TagTheme? theme;

  const Tag({
    Key? key,
    this.className,
    this.color,
    this.variant = TagVariant.filled,
    this.closable = false,
    this.closeIcon,
    this.onClose,
    this.icon,
    this.disabled = false,
    this.href,
    this.onTap,
    this.child,
    this.theme,
  }) : super(key: key);

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> with TickerProviderStateMixin {
  bool _visible = true;
  bool _isCloseHovered = false;
  bool _isHovered = false;
  late AnimationController _controller;
  late AnimationController _hoverController;
  late Animation<double> _animation;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.theme?.animationDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _hoverAnimation = CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut);
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (widget.disabled) return;
    
    widget.onClose?.call();
    _controller.reverse().then((_) {
      if (mounted) {
        setState(() => _visible = false);
      }
    });
  }

  Color get textColor {
    final theme = widget.theme ?? Theme.of(context).extension<TagTheme>() ?? TagTheme.defaultTheme();
    
    if (widget.disabled) {
      return theme.colorTextDisabled;
    }
    
    if (widget.color != null) {
      if (widget.variant == TagVariant.solid) {
        return theme.solidTextColor;
      } else {
        return widget.color!;
      }
    }
    
    if (widget.variant == TagVariant.solid) {
      return theme.colorTextLightSolid;
    }
    
    return theme.defaultColor;
  }

  BoxDecoration _buildDecoration() {
    final theme = widget.theme ?? Theme.of(context).extension<TagTheme>() ?? TagTheme.defaultTheme();
    
    Color bgColor = theme.defaultBg;
    Color borderColor = theme.colorBorder;
    Color? textColor = theme.defaultColor;

    if (widget.disabled) {
      bgColor = theme.colorBgContainerDisabled;
      textColor = theme.colorTextDisabled;
      borderColor = theme.colorBorderDisabled;
    } else if (widget.color != null) {
      if (widget.variant == TagVariant.solid) {
        bgColor = widget.color!;
        textColor = theme.solidTextColor;
        borderColor = widget.color!;
      } else if (widget.variant == TagVariant.outlined) {
        bgColor = widget.color!.withOpacity(0.05);
        textColor = widget.color;
        borderColor = widget.color!;
      } else {
        bgColor = widget.color!.withOpacity(0.1);
        textColor = widget.color;
        borderColor = Colors.transparent;
      }
    } else {
      if (widget.variant == TagVariant.solid) {
        bgColor = theme.colorBgSolid;
        textColor = theme.colorTextLightSolid;
        borderColor = Colors.transparent;
      } else if (widget.variant == TagVariant.filled) {
        borderColor = Colors.transparent;
      }
    }

    // 悬浮时的背景颜色渐变
    if (widget.onTap != null && !widget.disabled && _hoverAnimation.value > 0) {
      Color hoverBgColor;
      if (widget.color != null) {
        hoverBgColor = widget.color!.withOpacity(0.2);
      } else {
        hoverBgColor = theme.defaultBg.withOpacity(0.3);
      }
      bgColor = Color.lerp(bgColor, hoverBgColor, _hoverAnimation.value) ?? bgColor;
    }

    return BoxDecoration(
      color: bgColor,
      border: Border.all(color: borderColor, width: theme.borderWidth),
      borderRadius: BorderRadius.circular(theme.borderRadius),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    final theme = widget.theme ?? Theme.of(context).extension<TagTheme>() ?? TagTheme.defaultTheme();
    
    return FadeTransition(
      opacity: _animation,
      child: MouseRegion(
        onEnter: widget.onTap != null && !widget.disabled ? (_) {
          setState(() => _isHovered = true);
          _hoverController.forward();
        } : null,
        onExit: widget.onTap != null && !widget.disabled ? (_) {
          setState(() => _isHovered = false);
          _hoverController.reverse();
        } : null,
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) => GestureDetector(
            onTap: widget.disabled ? null : widget.onTap,
            child: Container(
              decoration: _buildDecoration(),
              padding: EdgeInsets.symmetric(
                horizontal: theme.paddingHorizontal,
                vertical: 4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 4),
                  ],
                  if (widget.child != null)
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: theme.fontSize,
                        height: 1.0,
                        color: textColor,
                      ),
                      child: widget.child!,
                    ),
                  if (widget.closable) ...[
                    const SizedBox(width: 4),
                    MouseRegion(
                      onEnter: (_) => setState(() => _isCloseHovered = true),
                      onExit: (_) => setState(() => _isCloseHovered = false),
                      child: GestureDetector(
                        onTap: _handleClose,
                        child: widget.closeIcon ??
                            Icon(
                              Icons.close,
                              size: theme.iconSize,
                              color: widget.disabled 
                                ? theme.colorTextDisabled 
                                : _isCloseHovered
                                  ? Colors.red
                                  : theme.colorIcon,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
