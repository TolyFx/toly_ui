part of '../toly_popover.dart';

class _PopOverlay extends StatefulWidget {
  const _PopOverlay({
    required this.maxHeight,
    required this.boxSize,
    required this.placement,
    this.maxWidth,
    this.config,
    this.margin,
    required this.overlay,
    required this.tapRegionGroup,
    required this.offsetCalculator,
    required this.clickPosition,
    required this.animation,
    required this.target,
    required this.verticalOffset,
    required this.overlayBuilder,
    required this.overlayDecorationBuilder,
    required this.isDark,
  });

  final OverlayContentBuilder? overlayBuilder;
  final OffsetCalculator? offsetCalculator;
  final DecorationConfig? config;
  final Widget? overlay;
  final OverlayDecorationBuilder overlayDecorationBuilder;
  final Placement placement;
  final double maxHeight;
  final double? maxWidth;

  final Animation<double> animation;
  final Offset target;
  final EdgeInsets? margin;
  final Offset? clickPosition;
  final PopoverController tapRegionGroup;
  final Size boxSize;
  final bool isDark;
  final double verticalOffset;

  @override
  State<_PopOverlay> createState() => _PopOverlayState();
}

class _PopOverlayState extends State<_PopOverlay> {
  late Placement effectPlacement = widget.placement;
  double shiftX = 0;

  Widget? get child {
    Widget? child =
        widget.overlayBuilder?.call(context, widget.tapRegionGroup) ??
            widget.overlay;
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final PopoverDecoration decoration = PopoverDecoration(
      placement: effectPlacement,
      shift: Offset(shiftX, 0),
      boxSize: widget.boxSize,
      darkTheme: widget.isDark,
      config: widget.config,
    );

    Widget result = TapRegion(
      groupId: widget.tapRegionGroup,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: widget.maxHeight, maxWidth: widget.maxWidth ?? 320),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: Semantics(
            container: true,
            child: Container(
              decoration: widget.overlayDecorationBuilder(decoration),
              child: child,
            ),
          ),
        ),
      ),
    );
    if(true){
       result = FadeTransition(
          opacity: widget.animation,
          child: result);
    }

    return Positioned.fill(
      bottom: 0.0,
      child: CustomSingleChildLayout(
        delegate: PopoverPositionDelegate(
          clickPosition: widget.clickPosition,
          offsetCalculator: widget.offsetCalculator,
          onPlacementShift: _onPlacementShift,
          // onSizeFind: (Size size){
          //   if(_size!=null) return;
          //   _size = size;
          //   setState(() {
          //
          //   });
          // },
          position: widget.target,
          placement: widget.placement,
          gap: widget.verticalOffset,
          boxSize: widget.boxSize, margin: widget.margin,
        ),
        child: result,
      ),
    );
  }

  void _onPlacementShift(PlacementShift shift) {
    effectPlacement = shift.placement;
    shiftX = shift.x;
    setState(() {});
  }
}
