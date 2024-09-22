// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-08-03
// Contact Me:  1981462002@qq.com

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'slot/slot_decoration.dart';

import 'attributes/attributes.dart';
import 'attributes/input_style.dart';
import 'num_change_handler.dart';
import 'slot/slot.dart';

class TolyInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final UndoHistoryController? undoController;

  final GestureTapCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TapRegionCallback? onTapOutside;

  final TolyInputStyle? style;
  final String? hintText;
  final InputType? type;
  final String? unit;
  final String? prefix;

  final Slot? leadingBuilder;
  final Slot? tailingBuilder;

  final bool enable;

  final WidgetBuilder? clearBuilder;
  final bool clearable;

  const TolyInput({
    super.key,
    this.controller,
    this.focusNode,
    this.undoController,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTapOutside,
    this.style,
    this.leadingBuilder,
    this.hintText,
    this.tailingBuilder,
    this.type,
    this.unit,
    this.prefix,
    this.enable = true,
    this.clearBuilder,
    this.clearable = false,
  });

  @override
  State<TolyInput> createState() => _TolyInputState();
}

class _TolyInputState extends State<TolyInput> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _hovered = false;
  late TolyInputStyle _effectStyle;
  late TextEditingController _effectCtrl;

  @override
  void dispose() {
    super.dispose();
    if (_effectStyle.enableHoverBorder) {
      _focusNode.removeListener(_onFocusChange);
    }
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _effectCtrl = widget.controller ?? TextEditingController();
    _initEffectStyle();
    if (_effectStyle.enableHoverBorder) {
      _focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void didUpdateWidget(TolyInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style) {
      _initEffectStyle();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = _effectStyle.inputSize.constraints.maxHeight;

    Color unFocusedColor = const Color(0xffd9d9d9);
    Widget child = _buildTextFile(_effectStyle.inputSize.constraints);

    if (!widget.enable) {
      child = MouseRegion(
        cursor: SystemMouseCursors.forbidden,
        child: IgnorePointer(child: child),
      );
    } else if (_effectStyle.enableHoverBorder) {
      child = MouseRegion(
        onEnter: (_) {
          setState(() {
            _hovered = true;
          });
        },
        onExit: (_) {
          if (_focusNode.hasFocus) {
            return;
          }
          setState(() {
            _hovered = false;
          });
        },
        child: child,
      );
    }

    if (widget.clearable || widget.clearBuilder != null) {
      child = Stack(
        alignment: Alignment.centerRight,
        children: [
          child,
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _effectCtrl,
            builder: (BuildContext context, TextEditingValue value, Widget? child) {
              if (value.text.isEmpty) return const SizedBox();
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _effectCtrl.clear,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.clearBuilder?.call(context) ?? _defaultClearIcon(),
            ),
          ),
        ],
      );
    }

    if (widget.type is NumberInput) {
      child = Row(
        children: [
          Expanded(child: child),
          NumChangeHandler(
            numberInput: widget.type as NumberInput,
            controller: _effectCtrl,
            height: height,
          )
        ],
      );
    }

    if (widget.leadingBuilder == null && widget.tailingBuilder == null) return child;

    List<Widget> children = [Expanded(child: child)];
    if (widget.leadingBuilder != null) {
      children.insert(
          0,
          SizedBox(
            height: height,
            child:  widget.leadingBuilder!.build(
              context,
              SlotMeta(
                  height: height,
                  unFocusedColor: unFocusedColor,
                  slotType: SlotType.leading,
                  radius: _effectStyle.radius),
            ),
          ));
    }
    if (widget.tailingBuilder != null) {
      children.add(SizedBox(
        height: height,
        child: widget.tailingBuilder!.build(
          context,
          SlotMeta(
              height: height,
              unFocusedColor: unFocusedColor,
              slotType: SlotType.tailing,
              radius: _effectStyle.radius),
        ),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  OutlineInputBorder? focusedBorder(bool hasLeading, bool hasTailing, bool focused) {
    Color unFocusedColor = const Color(0xffd9d9d9);
    Color focusedColor;
    if (_hovered) {
      focusedColor = _effectStyle.hoverColor ?? unFocusedColor;
    } else {
      focusedColor = (focused || _hovered) ? Colors.blue : unFocusedColor;
    }

    double borderWidth = 1;

    if (hasTailing && hasLeading) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: focusedColor, width: borderWidth),
      );
    }
    Radius radius = _effectStyle.radius;

    if (hasLeading) {
      return OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topRight: radius,
            bottomRight: radius,
          ),
          borderSide: BorderSide(color: focusedColor, width: borderWidth));
    }
    if (hasTailing) {
      return OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: radius,
            bottomLeft: radius,
          ),
          borderSide: BorderSide(color: focusedColor, width: borderWidth));
    }
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(radius),
        borderSide: BorderSide(color: focusedColor, width: borderWidth));
  }

  Widget _buildTextFile(BoxConstraints constraints) {
    TextStyle style = const TextStyle(fontSize: 14);
    Color focusedColor = Colors.blue;
    double borderWidth = 1;
    bool hasLeading = widget.leadingBuilder != null;
    bool hasTailing = widget.tailingBuilder != null || widget.type is NumberInput;
    Color unFocusedColor = const Color(0xffd9d9d9);
    // TextPainter _paint = TextPainter(textDirection: TextDirection.ltr);
    // _paint.text = TextSpan(text: 'A',style: style);
    // _paint.layout();
    // print( _paint.size );

    double pv = (constraints.maxHeight - (style.fontSize ?? 14).toDouble()) / 2;

    double paddingRight = (widget.clearable || widget.clearBuilder != null) ? 12 : 12 + 20;
    return TextField(
      focusNode: _focusNode,
      // cursorHeight: style.fontSize,
      cursorWidth: 1,
      controller: _effectCtrl,
      style: style,
      enabled: widget.enable,
      onTap: widget.onTap,
      onSubmitted: widget.onSubmitted,
      onTapOutside: widget.onTapOutside,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,

      decoration: InputDecoration(
        // isDense: true,
        hintText: widget.hintText,
        suffixIconConstraints: BoxConstraints(maxWidth: 32,minWidth: 32),
        prefixIconConstraints: BoxConstraints(maxWidth: 32,minWidth: 32),
        suffixIcon: widget.unit != null ? Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(widget.unit!,style: TextStyle(color: Colors.grey),),
        ) : null,
        prefixIcon: widget.prefix != null
            ? Padding(
                padding: const EdgeInsets.only(left:4.0,right: 4.0),
                child: Center(child: Text(widget.prefix!,style: TextStyle(color: Colors.grey),)),
              )
            : null,
        // prefixText: prefix,
        hintStyle: style.copyWith(color: unFocusedColor),
        constraints: constraints,
        isCollapsed: true,
        // contentPadding: EdgeInsets.only(top: 8),
        contentPadding: EdgeInsets.only(top: pv + 1, right: paddingRight+12, left: 12, bottom: pv + 1),
        focusedBorder: focusedBorder(hasLeading, hasTailing, true),
        enabledBorder: focusedBorder(hasLeading, hasTailing, false),
        hoverColor: focusedColor,
        border: focusedBorder(hasLeading, hasTailing, false),
      ),
    );
  }

  void _onFocusChange() {
    setState(() {
      _hovered = false;
    });
  }

  void _initEffectStyle() {
    _effectStyle = widget.style ?? TolyInputStyle(hoverColor: Colors.blue);
  }

  Widget _defaultClearIcon() {
    return const Icon(
      CupertinoIcons.clear_circled,
      size: 18,
      color: Color(0xff909399),
    );
  }
}
