import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import 'slot.dart';
import 'slot_decoration.dart';

typedef OnSelect<T> = void Function(T data);

class OptionSlotBuilder<T> extends Slot {
  final List<T> options;
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final SlotWidgetBuilder builder;
  DropMenuCellStyle? style;

  OptionSlotBuilder({
    required this.options,
    required this.builder,
    required this.onSelect,
    required this.activeIndex,
    super.padding = const EdgeInsets.symmetric(horizontal: 8),
    super.backgroundColor = const Color(0xfffafafa),
  });

  @override
  Widget build(BuildContext context, SlotMeta meta) {
    return OptionSlotDecoration(slot: this, meta: meta);
  }
}

class OptionSlotDecoration<T> extends StatefulWidget {
  final OptionSlotBuilder<T> slot;
  final SlotMeta meta;

  const OptionSlotDecoration({
    super.key,
    required this.slot,
    required this.meta,
  });

  @override
  State<OptionSlotDecoration> createState() => _OptionSlotDecorationState();
}

class _OptionSlotDecorationState<T> extends State<OptionSlotDecoration<T>> {
  bool _hover = false;

  Border get border {
    if (_hover) {
      return Border.all(color: Colors.blue, width: 1);
    }
    BorderSide side = BorderSide(color: widget.meta.unFocusedColor);
    return switch (widget.meta.slotType) {
      SlotType.leading => Border(top: side, left: side, bottom: side),
      SlotType.tailing => Border(top: side, right: side, bottom: side),
    };
  }

  BorderRadius get borderRadius {
    return switch (widget.meta.slotType) {
      SlotType.leading => const BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
      SlotType.tailing => const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      padding: widget.slot.padding,
      decoration: BoxDecoration(
        color: widget.slot.backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Center(
          child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          widget.slot.builder(context, _hover),
          const Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: Color(0xffbbbbbb),
          )
        ],
      )),
    );

    // if (!widget.slot..enableHover) return child;

    return _buildDropOption(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hover = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hover = false;
          });
        },
        child: child,
      ),
    );
  }

  Widget _buildDropOption({required Widget child}) {
    DropMenuCellStyle lightStyle = const DropMenuCellStyle(
      padding: EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      foregroundColor: Color(0xff1f1f1f),
      backgroundColor: Colors.transparent,
      disableColor: Color(0xffbfbfbf),
      hoverBackgroundColor: Color(0xfff5f5f5),
      hoverForegroundColor: Color(0xff1f1f1f),
    );

    List<T> options = widget.slot.options;
    return TolyDropMenu(
        style: lightStyle,
        placement: Placement.bottomStart,
        offsetCalculator: boxOffsetCalculator,
        decorationConfig: const DecorationConfig(isBubble: false, backgroundColor: Colors.white),
        onSelect: onSelect,
        menuItems: options
            .asMap()
            .keys
            .map((int index) => ActionMenu(
                active: index == widget.slot.activeIndex,
                MenuMeta(route: '$index', label: options[index].toString())))
            .toList(),
        childBuilder: (_, ctrl, __) {
          return GestureDetector(onTap: ctrl.open, child: child);
        });
  }

  void onSelect(MenuMeta value) {
    widget.slot.onSelect(int.tryParse(value.route) ?? -1);
  }
}
