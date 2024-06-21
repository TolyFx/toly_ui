import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:toly_ui/app/theme/code_theme.dart';
import 'package:toly_ui/incubator/components/data/collapse/collapse.dart';
import 'package:tolyui/tolyui.dart';

class CodeDisplay extends StatefulWidget {
  final Widget display;
  final String code;

  const CodeDisplay({super.key, required this.display, required this.code});

  @override
  State<CodeDisplay> createState() => _CodeDisplayState();
}

class _CodeDisplayState extends State<CodeDisplay> {
  String? codeRes;

  void _loadAssets() async {
    codeRes = await codeData();
    setState(() {});
  }

  Future<String> codeData() async {
    if (widget.code.startsWith('assets')) {
      return await rootBundle.loadString(widget.code);
    } else {
      return widget.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerTheme.color ?? Colors.grey,
            width: Theme.of(context).dividerTheme.space ?? 1,
          ),
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
            child: widget.display,
          ),
          const Divider(),
          TolyCollapse(
            titleBuilder: _buildTitle,
            sizeCurve: Curves.ease,
            content: _buildCodeView(),
            duration: const Duration(milliseconds: 500),
          )
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, Animation<double> anima, CollapseController ctrl) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: Row(
          children: [
            const Spacer(),
            TolyAction(
              tooltip: "复制代码",
              onTap: _copyCode,
              child: Icon(Icons.copy_rounded, size: 20, color: Color(0xff828282)),
            ),
            const SizedBox(width: 6),
            TolyAction(
                tooltip: "查看代码",
                onTap: () => _toggleCode(ctrl),
                child: AnimatedBuilder(
                  animation: anima,
                  builder: (_, child) {
                    Color? color = Color.lerp(
                        const Color(0xff828282), Colors.blue, Curves.ease.transform(anima.value));
                    return Transform.rotate(
                      angle: pi / 2 * Curves.ease.transform(anima.value),
                      child: Icon(
                        Icons.code,
                        color: color,
                        size: 20,
                      ),
                    );
                  },
                )),
          ],
        ));
  }

  Widget _buildCodeView() {
    if (codeRes == null) return const CupertinoActivityIndicator();
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: const Color(0xfff5f7fa),
      child: HighlightView(
        codeRes!,
        language: 'dart',
        theme: githubTheme,
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(
          fontFamily: 'Inconsolata',
          fontSize: 14,
        ),
      ),
    );
  }

  void _toggleCode(CollapseController ctrl) {
    if (!ctrl.isOpen) {
      _loadAssets();
    } else {
      codeRes = null;
    }
    ctrl.toggle();
  }

  void _copyCode() async {
    String code = await codeData();
    await Clipboard.setData(ClipboardData(text: code));
    $message.success(message: '代码复制成功!');
  }
}
