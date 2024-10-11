import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tolyui/tolyui.dart';

import 'basic_display.dart';
import 'form_display.dart';
import 'navigation_display.dart';

Widget overviewDisplayMap(String key){
  return switch(key){
    'Action' => ActionOverview(),
    'Button' => ButtonOverview(),
    'Icon' => IconOverview(),
    'Text' => TextOverview(),
    'Layout' => LayoutOverview(),
    'Link' => LinkOverview(),
    'Autocomplete' => AutocompleteDisplay(),
    'ColorPicker' => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12.0),
      child: TolyHuePanel(initColor: Colors.red, onChanged: (Color value) {  },),
    ),
    'DatePicker' => DatePickerDisplay(),
    'Input' => InputDisplay(),
    'Select' => SelectDisplay(),
    'Anchor' => AnchorDisplay(),
    'Breadcrumb' => BreadcrumbDisplay(),
    'DropMenu' => DropMenuDisplay(),
    'RailMenuTree' => RailMenuTreeDisplay(),
    'RailMenuBar' => RailMenuBarDisplay(),
    'Tabs' => TabsDisplay(),
    'Steps' => StepsDisplay(),

    _ => ToDoDisplay()
  };

  return SizedBox();
}

class ToDoDisplay extends StatelessWidget {
  const ToDoDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/programming.svg',height: 100,),
          Text("正在设计研发中",style: TextStyle(fontSize: 14,color: Colors.grey),),
        ],
      ),
    );
  }
}
