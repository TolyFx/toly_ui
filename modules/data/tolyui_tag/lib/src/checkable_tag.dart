import 'package:flutter/material.dart';
import 'types.dart';

class CheckableTag extends StatefulWidget {
  final bool checked;
  final Widget? icon;
  final Widget? child;
  final ValueChanged<bool>? onChange;
  final VoidCallback? onTap;
  final bool disabled;
  final TagTheme? theme;
  final Color? hoverColor;
  final Color? hoverTextColor;

  const CheckableTag({
    Key? key,
    required this.checked,
    this.icon,
    this.child,
    this.onChange,
    this.onTap,
    this.disabled = false,
    this.theme,
    this.hoverColor,
    this.hoverTextColor,
  }) : super(key: key);

  @override
  State<CheckableTag> createState() => _CheckableTagState();
}

class _CheckableTagState extends State<CheckableTag> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _hoverAnimation = CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.disabled) return;
    widget.onChange?.call(!widget.checked);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context).extension<TagTheme>() ?? TagTheme.defaultTheme();

    return GestureDetector(
      onTap: widget.disabled ? null : _handleTap,
      child: MouseRegion(
        cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: !widget.disabled ? (_) {
          setState(() => _isHovered = true);
          _hoverController.forward();
        } : null,
        onExit: !widget.disabled ? (_) {
          setState(() => _isHovered = false);
          _hoverController.reverse();
        } : null,
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            Color bgColor = Colors.transparent;
            Color borderColor = Colors.transparent;
            Color textColor = theme.defaultColor;

            if (widget.disabled) {
              if (widget.checked) {
                bgColor = theme.colorBgContainerDisabled;
                textColor = theme.colorTextDisabled;
              } else {
                textColor = theme.colorTextDisabled;
              }
            } else if (widget.checked) {
              bgColor = theme.colorPrimary;
              textColor = theme.colorTextLightSolid;
            }

            // 悬浮时的背景颜色渐变（仅在未激活状态下）
            if (!widget.disabled && !widget.checked && _hoverAnimation.value > 0) {
              Color targetHoverColor = widget.hoverColor ?? Colors.grey.withOpacity(0.1);
              Color targetTextColor = widget.hoverTextColor ?? theme.colorPrimary;
              
              bgColor = Color.lerp(Colors.transparent, targetHoverColor, _hoverAnimation.value) ?? bgColor;
              textColor = Color.lerp(textColor, targetTextColor, _hoverAnimation.value) ?? textColor;
            }

            return Container(
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: borderColor, width: theme.borderWidth),
                borderRadius: BorderRadius.circular(theme.borderRadius),
              ),
              padding: theme.padding,
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
                        leadingDistribution: TextLeadingDistribution.even,
                        color: textColor,
                      ),
                      child: widget.child!,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
