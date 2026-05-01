import 'package:flutter_test/flutter_test.dart';

import 'placement_test.dart' as placement;
import 'algorithm_test.dart' as algorithm;
import 'bubble_decoration_test.dart' as bubble;
import 'tooltip_test.dart' as tooltip;
import 'popover_test.dart' as popover;
import 'pop_picker_test.dart' as pop_picker;
import 'pop_picker_theme_test.dart' as pop_picker_theme;
import 'decoration_config_test.dart' as decoration_config;

void main() {
  placement.main();
  algorithm.main();
  bubble.main();
  tooltip.main();
  popover.main();
  pop_picker.main();
  pop_picker_theme.main();
  decoration_config.main();
}
