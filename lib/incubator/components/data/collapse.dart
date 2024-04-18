import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The duration over which theme changes animate by default.
const Duration kCollapseAnimationDuration = Duration(milliseconds: 200);

typedef ActionBuilder = Widget Function(VoidCallback action);

class TolyCollapse extends StatefulWidget {
  final Widget content;
  final ActionBuilder actionBuilder;
  final Duration animationDuration;

  const TolyCollapse({
    super.key,
    required this.content,
    this.animationDuration = kCollapseAnimationDuration,
    required this.actionBuilder,
  });

  @override
  State<TolyCollapse> createState() => _TolyCollapseState();
}

class _TolyCollapseState extends State<TolyCollapse> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  bool get isFirst => _crossFadeState == CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.actionBuilder(_toggleCodePanel),
        // GestureDetector(
        //     onTap: (){
        //       _toggleCodePanel();
        //     },
        //     child: widget.head),
        _buildCode(context),
      ],
    );
  }

  // 折叠代码面板
  _toggleCodePanel() {
    setState(() {
      _crossFadeState =
          !isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond;
    });
  }

  Widget _buildCode(BuildContext context) => AnimatedCrossFade(
    // layoutBuilder: layoutBuilder,
        firstCurve: Curves.easeInCirc,
        secondCurve: Curves.easeInToLinear,

        firstChild: Container(height: 0,),
        secondChild: widget.content,
        duration: widget.animationDuration,
        reverseDuration: widget.animationDuration,
        crossFadeState: _crossFadeState,
      );

  static Widget layoutBuilder(Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          key: bottomChildKey,
          left: 0.0,
          top: 0.0,
          right: 0.0,
          child: bottomChild,
        ),
        Positioned(
          key: topChildKey,
          child: topChild,
        ),
      ],
    );
  }
}
