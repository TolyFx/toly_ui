import 'package:flutter/material.dart';

enum ShadowMode { always, hover, never }

class TolyCard extends StatefulWidget {
  final Widget child;
  final ShadowMode shadowMode;
  final DecorationImage? image;
  final BorderRadius radius;
  final List<BoxShadow>? shadows;

  const TolyCard({
    super.key,
    required this.child,
    this.image,
    this.shadows,
    this.radius = const BorderRadius.all(Radius.circular(8)),
    this.shadowMode = ShadowMode.always,
  });

  @override
  State<TolyCard> createState() => _TolyCardState();
}

class _TolyCardState extends State<TolyCard> {
  bool _isHover = false;

  List<BoxShadow>? get shadows =>
      widget.shadows ??
      [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 4,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 2,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  List<BoxShadow>? get effectShadows {
    return switch (widget.shadowMode) {
      ShadowMode.always => shadows,
      ShadowMode.hover => _isHover ? shadows : null,
      ShadowMode.never => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color? color = theme.listTileTheme.tileColor;
    Color? borderColor = theme.dividerTheme.color ?? Colors.grey;
    double borderSpace = theme.dividerTheme.space ?? 1;
    Widget child = DecoratedBox(
      decoration: BoxDecoration(
        image: widget.image,
        color: color,
        borderRadius: widget.radius,
        border: Border.all(color: borderColor, width: borderSpace),
        boxShadow: effectShadows,
      ),
      child: widget.child,
    );
    if (widget.shadowMode == ShadowMode.hover) {
      child = wrapMouseRegion(child);
    }
    return child;
  }

  Widget wrapMouseRegion(Widget child) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onExit: (_) {
        setState(() {
          _isHover = false;
        });
      },
      onEnter: (_) {
        setState(() {
          _isHover = true;
        });
      },
      child: child,
    );
  }
}
