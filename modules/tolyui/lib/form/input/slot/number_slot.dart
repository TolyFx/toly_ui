import 'package:flutter/material.dart';
import 'slot.dart';

enum NumberEventType { add, minus }

typedef NumberAction = void Function(NumberEventType type, num step);

class NumberCtrlSlot extends Slot {
  final Widget child;
  final num step;
  final bool hoverHighLight;
  final NumberAction onCtrlTap;


  NumberCtrlSlot({
    required this.child,
    required this.onCtrlTap,
    this.hoverHighLight = true,
    this.step = 1,
    super.onTap,
    super.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context, SlotMeta meta) {
    return NumberSlotCell(
      slot: this,
      meta: meta,
    );
  }
}

class NumberSlotCell extends StatefulWidget {
  final NumberCtrlSlot slot;
  final SlotMeta meta;

  const NumberSlotCell({super.key, required this.slot, required this.meta});

  @override
  State<NumberSlotCell> createState() => _NumberSlotCellState();
}

class _NumberSlotCellState extends State<NumberSlotCell> {
  bool _hoverAdd = false;
  bool _hoverMinus = false;

  BoxDecoration get addDecoration {
    SlotMeta meta = widget.meta;
    if (_hoverAdd) {
      return BoxDecoration(
          color: const Color(0xfffafafa),
          borderRadius: BorderRadius.only(topRight: meta.radius),
          border: Border(
            right: BorderSide(color: Colors.blue),
            top: BorderSide(color: Colors.blue),
            bottom: BorderSide(color: Colors.blue),
            left: BorderSide(color: Colors.blue),
          ));
    }
    return BoxDecoration(
        color: const Color(0xfffafafa),
        borderRadius: BorderRadius.only(topRight: meta.radius),
        border: Border(
          right: BorderSide(color: meta.unFocusedColor),
          top: BorderSide(color: meta.unFocusedColor),
        ));
  }

  BoxDecoration get minusDecoration {
    SlotMeta meta = widget.meta;
    if (_hoverMinus) {
      return BoxDecoration(
          color: const Color(0xfffafafa),
          borderRadius: BorderRadius.only(bottomRight: meta.radius),
          border: Border(
            right: BorderSide(color: Colors.blue),
            top: BorderSide(color: Colors.blue),
            bottom: BorderSide(color: Colors.blue),
            left: BorderSide(color: Colors.blue),
          ));
    }
    return BoxDecoration(
        color: const Color(0xfffafafa),
        borderRadius: BorderRadius.only(bottomRight: meta.radius),
        border: Border(
          right: BorderSide(color: meta.unFocusedColor),
          top: BorderSide(color: meta.unFocusedColor),
          bottom: BorderSide(color: meta.unFocusedColor),
        ));
  }

  @override
  Widget build(BuildContext context) {
    SlotMeta meta = widget.meta;

    return Column(
      children: [
        GestureDetector(
          onTap: ()=>widget.slot.onCtrlTap(NumberEventType.add,widget.slot.step),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onExit: (_) {
              setState(() {
                _hoverAdd = false;
              });
            },
            onEnter: (_) {
              setState(() {
                _hoverAdd = true;
              });
            },
            child: Container(
              padding: widget.slot.padding,
              alignment: Alignment.center,
              decoration: addDecoration,
              height: meta.height / 2,
              child: Text(
                '+',
                style: TextStyle(
                  height: 1,
                  color: widget.slot.hoverHighLight && _hoverAdd ? Colors.blue : null,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: ()=>widget.slot.onCtrlTap(NumberEventType.minus,widget.slot.step),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onExit: (_) {
              setState(() {
                _hoverMinus = false;
              });
            },
            onEnter: (_) {
              setState(() {
                _hoverMinus = true;
              });
            },
            child: Container(
              padding: widget.slot.padding,
              alignment: Alignment.center,
              height: meta.height / 2,
              decoration: minusDecoration,
              child: Text('-',
                  style: TextStyle(
                    height: 1,
                    color: widget.slot.hoverHighLight && _hoverMinus ? Colors.blue : null,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
