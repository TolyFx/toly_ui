
import 'package:toly_menu/toly_menu.dart';
import 'package:toly_menu_manager/toly_menu_manager.dart';

import 'data.dart';
import 'form.dart';
import 'dashboard.dart';
import 'basic.dart';
import 'navigation.dart';

class WidgetMenuRepositoryImpl implements MenuRepository{
  @override
  MenuNode loadMenuTree() {
    return MenuNode.fromMap({
      'children': [
        dashboard,
        basicMenus,
        formMenus,
        navigationMenus,
        dataMenus,
      ]
    });
  }

  @override
  ActiveState loadActiveState() {
    // return ActiveState(['/calc'],'/calc/date');
    // return ActiveState(['/widgets/basic'],'/widgets/basic/link');
    return ActiveState(['/widgets/basic'],'/widgets/basic/layout');
  }
}

