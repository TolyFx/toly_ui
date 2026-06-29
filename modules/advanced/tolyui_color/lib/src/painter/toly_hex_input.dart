// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-02
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

class TolyHexInput extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onChanged;

  const TolyHexInput({super.key, required this.color, required this.onChanged});

  @override
  State<TolyHexInput> createState() => _TolyHexInputState();
}

class _TolyHexInputState extends State<TolyHexInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _colorToHex(widget.color));
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant TolyHexInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color && !_focusNode.hasFocus) {
      _controller.text = _colorToHex(widget.color);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(width: 8),
            const Text('#', style: TextStyle(fontSize: 14, fontFamily: 'monospace')),
            SizedBox(
              width: 72,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onChanged,
              ),
            ),
            const SizedBox(width: 8),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            if (_error == null && _controller.text.length == 6)
              const Icon(Icons.check_circle, color: Colors.green, size: 16),
          ],
        ),
      ],
    );
  }

  void _onChanged(String value) {
    value = value.replaceAll('#', '').toUpperCase();
    if (value.length == 6) {
      final int? parsed = int.tryParse(value, radix: 16);
      if (parsed != null) {
        setState(() => _error = null);
        widget.onChanged(Color(parsed | 0xFF000000));
        return;
      }
    }
    if (value.isEmpty) {
      setState(() => _error = null);
    } else if (value.length != 6) {
      setState(() => _error = '需要 6 位');
    } else {
      setState(() => _error = '无效格式');
    }
  }

  String _colorToHex(Color c) =>
      '${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
}
