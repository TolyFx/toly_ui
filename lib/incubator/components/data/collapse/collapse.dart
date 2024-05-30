import 'package:flutter/material.dart';

import 'switch_panel.dart';

/// The duration over which theme changes animate by default.
const Duration kCollapseAnimationDuration = Duration(milliseconds: 400);

typedef ActionBuilder = Widget Function(VoidCallback action);

class TolyCollapse1 extends StatefulWidget {
  final Widget content;
  final Widget? title;
  final bool opened;
  final ActionBuilder actionBuilder;
  final Duration duration;
  final Duration reverseDuration;
  final AlignmentGeometry alignment;

  final Curve firstCurve;
  final Curve sizeCurve;

  /// Defaults to [Curves.linear].
  final Curve secondCurve;

  const TolyCollapse1({
    super.key,
    required this.content,
     this.title,
    this.alignment = Alignment.topCenter,
    this.duration = kCollapseAnimationDuration,
    this.reverseDuration = kCollapseAnimationDuration,
    this.firstCurve = Curves.linear,
    this.secondCurve = Curves.linear,
    this.sizeCurve = Curves.linear,
    this.opened = false,
    required this.actionBuilder,
  });

  @override
  State<TolyCollapse1> createState() => _TolyCollapse1State();
}

class _TolyCollapse1State extends State<TolyCollapse1>  with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _firstAnimation;
  late Animation<double> _secondAnimation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    );
    if (widget.opened) {
      _controller.value = 1.0;
    }
    _firstAnimation = _initAnimation(widget.firstCurve, true);
    _secondAnimation = _initAnimation(widget.secondCurve, false);
    _controller.addStatusListener((AnimationStatus status) {
      print("======status:${_controller.value}===${status}=======");

      if(status==AnimationStatus.completed||status==AnimationStatus.dismissed){
        _isOpen =_controller.value==1;
      }

      setState(() {
        // Trigger a rebuild because it depends on _isTransitioning, which
        // changes its value together with animation status.
      });
    });
  }

  Animation<double> _initAnimation(Curve curve, bool inverted) {
    Animation<double> result = _controller.drive(CurveTween(curve: curve));
    if (inverted) {
      result = result.drive(Tween<double>(begin: 1.0, end: 0.0));
    }
    return result;
  }


  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  bool get isFirst => _crossFadeState == CrossFadeState.showFirst;


  @override
  void didUpdateWidget(TolyCollapse1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.reverseDuration != oldWidget.reverseDuration) {
      _controller.reverseDuration = widget.reverseDuration;
    }
    if (widget.firstCurve != oldWidget.firstCurve) {
      _firstAnimation = _initAnimation(widget.firstCurve, true);
    }
    if (widget.secondCurve != oldWidget.secondCurve) {
      _secondAnimation = _initAnimation(widget.secondCurve, false);
    }
    if (widget.opened != oldWidget.opened) {
      if(widget.opened){
        _controller.reverse();
      }else{
        _controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.title!=null)
          GestureDetector(
            onTap: _toggleCodePanel,
            child: widget.title,
          ),
        if(widget.title==null)
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
  void _toggleCodePanel() {
    print("======_isOpen:${_isOpen}==========");
    // if(_isOpen){
    //   _controller.reverse();
    // }else{
    //   _controller.forward();
    // }
    setState(() {
      _crossFadeState =
          !isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond;
    });
  }

  Widget _buildCode(BuildContext context) {

    // return ClipRect(
    //   child: AnimatedSize(
    //     alignment: widget.alignment,
    //     duration: widget.duration,
    //     reverseDuration: widget.reverseDuration,
    //     curve: widget.sizeCurve,
    //     child: !_isOpen?Container():widget.content,
    //   ),
    // );

    return AnimatedCrossFade(
    // layoutBuilder: layoutBuilder,
        firstCurve: Curves.easeInCirc,
        secondCurve: Curves.easeInToLinear,
        secondChild: widget.content,
        duration: widget.duration,
        reverseDuration: widget.duration,
        crossFadeState: _crossFadeState, firstChild: Container(height: 0,),
      );
  }

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

  void _close() {}

  void _open() {}
}
// CollapseCtr

// class CollapseController {
//   _TolyCollapse1State? _state;
//
//   bool get isOpen {
//     assert(_state != null);
//     return _state!._isOpen;
//   }
//
//   void close() {
//     assert(_state != null);
//     _state!._close();
//   }
//
//   void open() {
//     assert(_state != null);
//     _state!._open();
//   }
//
//   void _attach(_TolyCollapse1State state) {
//     _state = state;
//   }
//
//   void _detach(_TolyCollapse1State state) {
//     if (_state == state) {
//       _state = null;
//     }
//   }
// }