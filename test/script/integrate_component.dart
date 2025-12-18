import 'dart:io';

/// TolyUI 组件集成脚本
/// 
/// 使用方式:
/// dart test/script/integrate_component.dart <component_name> <module> <label> <subtitle>
/// 
/// 示例:
/// dart test/script/integrate_component.dart phone_frame advanced PhoneFrame 手机外观
void main(List<String> args) {
  if (args.length < 4) {
    print('❌ 参数不足');
    print('使用方式: dart test/script/integrate_component.dart <component_name> <module> <label> <subtitle>');
    print('示例: dart test/script/integrate_component.dart phone_frame advanced PhoneFrame 手机外观');
    exit(1);
  }

  final componentName = args[0];
  final module = args[1];
  final label = args[2];
  final subtitle = args[3];

  print('🚀 开始集成组件: $componentName');
  print('📁 模块: $module');
  print('🏷️  标签: $label - $subtitle');

  try {
    // 1. 检查组件目录是否存在
    final componentDir = Directory('lib/view/widgets/$module/$componentName');
    if (!componentDir.existsSync()) {
      print('❌ 组件目录不存在: ${componentDir.path}');
      print('请先创建组件目录和 demo 文件');
      exit(1);
    }

    // 2. 更新模块导出文件
    print('\n📝 更新模块导出文件...');
    updateModuleExport(module, componentName);

    // 3. 更新菜单配置
    print('\n📋 更新菜单配置...');
    updateMenuConfig(module, componentName, label, subtitle);

    // 4. 更新路由配置
    print('\n🛣️  更新路由配置...');
    updateRouteConfig(module, componentName);

    print('\n✨ 组件集成完成!');
    print('\n📝 下一步:');
    print('  1. 运行 flutter pub get');
    print('  2. 运行 toly ui 生成资源');
    print('  3. 启动应用验证');

  } catch (e) {
    print('❌ 集成失败: $e');
    exit(1);
  }
}

void updateModuleExport(String module, String componentName) {
  final file = File('lib/view/widgets/$module/$module.dart');
  
  if (!file.existsSync()) {
    // 创建模块导出文件
    file.createSync(recursive: true);
    file.writeAsStringSync("export '$componentName/$componentName.dart';\n");
    print('✅ 创建模块导出文件');
  } else {
    var content = file.readAsStringSync();
    final exportLine = "export '$componentName/$componentName.dart';";
    
    if (content.contains(exportLine)) {
      print('⚠️  模块导出已存在，跳过');
    } else {
      content += '\n$exportLine\n';
      file.writeAsStringSync(content);
      print('✅ 已添加到模块导出');
    }
  }
}

void updateMenuConfig(String module, String componentName, String label, String subtitle) {
  final file = File('lib/navigation/menu/$module.dart');
  
  if (!file.existsSync()) {
    print('❌ 菜单配置文件不存在: ${file.path}');
    exit(1);
  }

  var content = file.readAsStringSync();
  
  // 检查是否已存在
  if (content.contains("'path': '/$componentName'")) {
    print('⚠️  菜单项已存在，跳过');
    return;
  }

  // 找到 children 数组的最后一个元素
  final childrenMatch = RegExp(r"'children':\s*\[(.*?)\]", dotAll: true).firstMatch(content);
  if (childrenMatch == null) {
    print('❌ 无法找到 children 数组');
    exit(1);
  }

  final menuItem = """
        {
          'path': '/$componentName',
          'label': '$label',
          'subtitle': '$subtitle',
          'tag': '新'
        },""";

  // 在最后一个 ] 之前插入
  final insertPos = childrenMatch.end - 1;
  content = content.substring(0, insertPos) + menuItem + '\n      ' + content.substring(insertPos);
  
  file.writeAsStringSync(content);
  print('✅ 已添加菜单项');
}

void updateRouteConfig(String module, String componentName) {
  final file = File('lib/navigation/router/widgets_route.dart');
  
  if (!file.existsSync()) {
    print('❌ 路由配置文件不存在: ${file.path}');
    exit(1);
  }

  var content = file.readAsStringSync();
  
  // 检查是否已存在
  if (content.contains("_customRoute('$componentName')")) {
    print('⚠️  路由已存在，跳过');
    return;
  }

  // 找到对应模块的 GoRoute
  final modulePattern = RegExp(
    r"GoRoute\(\s*path:\s*'$module'.*?routes:\s*\[(.*?)\]",
    dotAll: true,
  );
  
  final match = modulePattern.firstMatch(content);
  if (match == null) {
    print('❌ 无法找到模块路由: $module');
    exit(1);
  }

  final routeItem = "\n                  _customRoute('$componentName'),";
  
  // 在 routes 数组的最后一个元素后插入
  final insertPos = match.end - 1;
  content = content.substring(0, insertPos) + routeItem + '\n                ' + content.substring(insertPos);
  
  file.writeAsStringSync(content);
  print('✅ 已添加路由');
}
