import 'dart:io';

/// TolyUI 模块创建脚本
///
/// 使用方式:
/// dart test/script/create_module.dart <module_name> [category]
///
/// 示例:
/// dart test/script/create_module.dart toly_button form
/// dart test/script/create_module.dart collapse data
/// dart test/script/create_module.dart advanced  # 创建父模块
void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ 参数不足');
    print('使用方式: dart test/script/create_module.dart <module_name> [category]');
    print('示例: dart test/script/create_module.dart toly_button form');
    print('创建父模块: dart test/script/create_module.dart advanced');
    print('可用分类: data, form, feedback, media, navigation, advanced');
    exit(1);
  }

  final moduleName = args[0];
  final category = args.length > 1 ? args[1] : null;

  final validCategories = [
    'data',
    'form',
    'feedback',
    'media',
    'navigation',
    'advanced'
  ];

  // 如果没有提供 category，创建父模块
  if (category == null) {
    createParentModule(moduleName);
    return;
  }

  if (!validCategories.contains(category)) {
    print('❌ 无效的分类: $category');
    print('可用分类: ${validCategories.join(", ")}');
    exit(1);
  }

  print('🚀 开始创建模块: $moduleName');
  print('📁 分类: $category');

  final moduleDir = Directory('modules/$category/$moduleName');

  if (moduleDir.existsSync()) {
    print('❌ 模块已存在: ${moduleDir.path}');
    exit(1);
  }

  try {
    // 1. 创建 Flutter package
    print('\n📦 创建 Flutter package...');
    final flutterCmd = Platform.isWindows ? 'flutter.bat' : 'flutter';
    final result = Process.runSync(
      flutterCmd,
      ['create', '--template=package', moduleName],
      workingDirectory: 'modules/$category',
      runInShell: true,
    );

    if (result.exitCode != 0) {
      print('❌ 创建失败: ${result.stderr}');
      exit(1);
    }

    print('✅ Package 创建成功');

    // 2. 创建 src 目录
    print('\n📂 创建 src 目录...');
    final srcDir = Directory('modules/$category/$moduleName/lib/src');
    srcDir.createSync(recursive: true);

    // 3. 更新 pubspec.yaml
    print('\n📝 更新 pubspec.yaml...');
    updatePubspec(moduleName, category);

    // 4. 创建 LICENSE
    print('\n📄 创建 LICENSE...');
    createLicense(moduleName, category);

    // 5. 创建 README
    print('\n📖 创建 README...');
    createReadme(moduleName, category);

    // 6. 创建 CHANGELOG
    print('\n📋 创建 CHANGELOG...');
    createChangelog(moduleName, category);

    // 7. 创建 doc 目录和 ref 子目录
    print('\n📚 创建 doc 目录...');
    final docDir = Directory('modules/$category/$moduleName/doc');
    docDir.createSync(recursive: true);

    final refDir = Directory('modules/$category/$moduleName/doc/ref');
    refDir.createSync(recursive: true);

    // 8. 更新 .gitignore 忽略 ref 目录
    print('\n🔒 配置 .gitignore...');
    updateGitignore(moduleName, category);

    // 9. 清理默认生成的文件
    print('\n🧹 清理默认文件...');
    final defaultFile =
        File('modules/$category/$moduleName/lib/$moduleName.dart');
    if (defaultFile.existsSync()) {
      defaultFile.writeAsStringSync('''library $moduleName;

// TODO: Export your library's public API
''');
    }

    // 删除测试目录
    final testDir = Directory('modules/$category/$moduleName/test');
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
      print('✅ 已删除测试目录');
    }

    print('\n✨ 模块创建完成!');
    print('\n📍 模块位置: modules/$category/$moduleName');
    print('\n📝 下一步:');
    print('  1. 在 lib/src/ 目录下创建组件文件');
    print('  2. 在 lib/$moduleName.dart 中导出组件');
    print('  3. 更新 README.md 和 CHANGELOG.md');
    print('  4. 在主项目 pubspec.yaml 中添加依赖');
  } catch (e) {
    print('❌ 创建失败: $e');
    exit(1);
  }
}

void updatePubspec(String moduleName, String category) {
  final file = File('modules/$category/$moduleName/pubspec.yaml');
  final componentName = moduleName.replaceAll('toly_', '').replaceAll('_', ' ');

  final content = '''name: $moduleName
description: "$componentName for tolyui"
version: 0.0.1
homepage: https://github.com/TolyFx/toly_ui
repository: https://github.com/TolyFx/toly_ui/tree/main/modules/$category/$moduleName

environment:
  sdk: ^3.6.0
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
''';

  file.writeAsStringSync(content);
  print('✅ pubspec.yaml 已更新');
}

void createLicense(String moduleName, String category) {
  final File file = File('modules/$category/$moduleName/LICENSE');
  final File rootLicense = File('LICENSE');
  if (!rootLicense.existsSync()) {
    throw StateError('仓库根目录缺少 LICENSE，无法创建模块许可证。');
  }
  file.writeAsStringSync(rootLicense.readAsStringSync());
  print('✅ LICENSE 已创建');
}

void createReadme(String moduleName, String category) {
  final file = File('modules/$category/$moduleName/README.md');
  final componentName =
      _toTitleCase(moduleName.replaceAll('toly_', '').replaceAll('_', ' '));
  final className = _toPascalCase(moduleName);

  final content = '''# $className

$className 是 TolyUI 框架中的组件，提供 TODO 功能描述。

## 特性

TODO: 列出组件的核心特性

## 安装

在 `pubspec.yaml` 中添加依赖：

\`\`\`yaml
dependencies:
  $moduleName: ^0.0.1
\`\`\`

## 使用

### 基础用法

TODO: 添加基础使用示例

\`\`\`dart
$className(
  // TODO: 添加属性
)
\`\`\`

## API

### $className 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| TODO | TODO | TODO | TODO |

## 设计理念

TODO: 描述组件的设计理念

## 许可证

本项目采用 MIT 许可证。

## 关于 TolyUI

TolyUI 是一个为 Flutter 开发者打造的 UI 组件库，致力于提供简洁、优雅、实用的组件解决方案。

展示网站: http://toly1994.com/ui
''';

  file.writeAsStringSync(content);
  print('✅ README.md 已创建');
}

void createChangelog(String moduleName, String category) {
  final file = File('modules/$category/$moduleName/CHANGELOG.md');
  final className = _toPascalCase(moduleName);

  final content = '''# 更新日志

## 0.0.1

首次发布 $className 组件。

- TODO: 列出首版功能
''';

  file.writeAsStringSync(content);
  print('✅ CHANGELOG.md 已创建');
}

String _toTitleCase(String text) {
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');
}

String _toPascalCase(String text) {
  return text.split('_').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join('');
}

void createParentModule(String moduleName) {
  print('🚀 创建父模块: $moduleName');

  final moduleDir = Directory('modules/$moduleName');

  if (moduleDir.existsSync()) {
    print('❌ 父模块已存在: ${moduleDir.path}');
    exit(1);
  }

  try {
    moduleDir.createSync(recursive: true);

    // 创建 README
    final readmeFile = File('modules/$moduleName/README.md');
    final content = '''# ${_toTitleCase(moduleName)} 模块

${_toTitleCase(moduleName)} 是 TolyUI 的高级组件模块集合。

## 子模块

TODO: 列出子模块

## 关于 TolyUI

TolyUI 是一个为 Flutter 开发者打造的 UI 组件库。

展示网站: http://toly1994.com/ui
''';
    readmeFile.writeAsStringSync(content);

    print('✅ 父模块创建成功!');
    print('\n📍 模块位置: modules/$moduleName');
    print('\n📝 下一步:');
    print('  1. 在 modules/$moduleName/ 下创建子模块');
    print(
        '  2. 使用: dart test/script/create_module.dart <module_name> $moduleName');
  } catch (e) {
    print('❌ 创建失败: $e');
    exit(1);
  }
}

void updateGitignore(String moduleName, String category) {
  final file = File('modules/$category/$moduleName/.gitignore');

  if (file.existsSync()) {
    var content = file.readAsStringSync();
    if (!content.contains('doc/ref/')) {
      content += '\n# Ignore reference files\ndoc/ref/\n';
      file.writeAsStringSync(content);
    }
  }

  print('✅ .gitignore 已配置，忽略 doc/ref/ 目录');
}
