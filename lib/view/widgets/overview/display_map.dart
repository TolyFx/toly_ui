import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tolyui/tolyui.dart';

import 'advance.dart';
import 'basic_display.dart';
import 'data.dart';
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
    'ColorPicker' => ColorDisplay(),
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

    'Avatar' => AvatarDisplay(),
    'Badge' => BadgeDisplay(),
    'Card' => CardDisplay(),
    'Collapse' =>  CollapseDisplay(),
    'Image' =>  ImageDisplay(),
    'Pagination' =>  PaginationDisplay(),
    'Progress' =>  ProgressDisplay(),

    'Color' => ColorDisplay(),

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
