import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toly_ui/components/node_display.dart';
import '../../widget_display_map.dart';
import 'display_nodes.dart';
import 'input_demo1.dart';

class InputDisplayPage extends StatelessWidget {
  const InputDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, index) {
          return NodeDisplay(
            display: widgetDisplayMap(keys[index]),
            node: Node.fromMap(data[index]),
          );
        },
        itemCount: displayNodes.length,
      ),
    );
    double height = 32;
    TextStyle style = TextStyle(fontSize: 14, height: 1);
    double borderWidth = 1;
    Color focusedColor = Colors.blue;
    Color unFocusedColor = Color(0xffd9d9d9);
    OutlineInputBorder focusedBorder = OutlineInputBorder(borderSide: BorderSide(color: focusedColor, width: borderWidth));
    OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: unFocusedColor, width: borderWidth));

    return Column(
      children: [
        const SizedBox(
          height: 60,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            // color: Colors.blue.withOpacity(0.2)
          ),
          child: SizedBox(
              width: 250,
              child: TextField(
                // maxLines: 4,
                cursorHeight: style.fontSize,
                cursorWidth: 1,
                style: style,
                decoration: InputDecoration(
                  // isDense: true,
                  hintText: 'please input',
                  // hintStyle: style.copyWith(color: unFocusedColor),
                  constraints: BoxConstraints.tight(Size(0, height)),
                  // contentPadding: EdgeInsets.only(top: 8),
                  contentPadding:
                      EdgeInsets.only(top: 0,right: 12,left: 12),
                  focusedBorder: focusedBorder,
                  enabledBorder: border,
                  hoverColor: focusedColor,
                  border: border,
                ),
              )),


        ),
        const SizedBox(
          height: 24,
        ),
         SizedBox(
            width: 250,
            child: TextField(
              // maxLines: 4,
              enabled: false,
              cursorHeight: style.fontSize,
              cursorWidth: 1,
              style: style,
              decoration: InputDecoration(
                // isDense: true,
                hintText: 'disabled input',
                // hintStyle: style.copyWith(color: unFocusedColor),
                constraints: BoxConstraints.tight(Size(0, height)),
                // contentPadding: EdgeInsets.only(top: 8),
                contentPadding:
                EdgeInsets.only(top: 0,right: 12,left: 12),
                focusedBorder: focusedBorder,
                enabledBorder: border,
                hoverColor: focusedColor,
                border: border,
              ),
            )),
        const SizedBox(
          height: 24,
        ),
        InputDemo1()

        // SizedBox(
        //     width: 300,
        //     child: CupertinoTextField(
        //       // cursorHeight: 14,
        //       // decoration: InputDecoration(
        //       //     isDense: true,
        //       //     constraints: BoxConstraints.tight(Size(0,32)),
        //       //     // contentPadding: EdgeInsets.only(top: 8),
        //       //     // contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        //       //
        //       //     border: OutlineInputBorder()
        //       // ),
        //     )),
      ],
    );
  }
}
