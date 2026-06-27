import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

void main() {
  test('TolyAnchorController initial state', () {
    final controller = TolyAnchorController();
    expect(controller.activeTag, null);
  });
}
