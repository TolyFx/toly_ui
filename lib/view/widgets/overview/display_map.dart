import 'package:flutter/material.dart';

import 'basic_display.dart';

Widget overviewDisplayMap(String key){
  return switch(key){
    'Action' => ActionOverview(),
    'Button' => ButtonOverview(),
    'Icon' => IconOverview(),
    'Text' => TextOverview(),
    'Layout' => LayoutOverview(),
    'Link' => LinkOverview(),
    _ => SizedBox()
  };

  return SizedBox();
}
