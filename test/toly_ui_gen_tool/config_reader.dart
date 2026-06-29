import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// 代码生成工具配置
class TolyUIGenConfig {
  /// 扫描源码的目录
  final String parserDir;

  /// 生成 .g.dart 文件的输出目录
  final String genDistDir;

  /// 源码导出到 assets 的目录
  final String codeResDir;

  const TolyUIGenConfig({
    required this.parserDir,
    required this.genDistDir,
    required this.codeResDir,
  });

  /// 默认配置（无 pubspec.yaml 时使用）
  factory TolyUIGenConfig.defaults() {
    return TolyUIGenConfig(
      parserDir: 'lib/view/widgets',
      genDistDir: 'lib/view/widgets/display_nodes/gen',
      codeResDir: 'assets/code_res',
    );
  }
}

/// 从 pubspec.yaml 的 `toly.code_gen` 段读取配置
class TolyUIConfigReader {
  final String projectRoot;

  TolyUIConfigReader({String? projectRoot})
      : projectRoot = projectRoot ?? Directory.current.path;

  /// 读取 pubspec.yaml 并解析配置，失败时回退到默认值
  TolyUIGenConfig read() {
    final pubspecFile = File(path.join(projectRoot, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      print('⚠ 未找到 pubspec.yaml，使用默认配置');
      return TolyUIGenConfig.defaults();
    }

    try {
      final yaml = loadYaml(pubspecFile.readAsStringSync());
      final toly = yaml['toly'];
      if (toly == null || toly is! YamlMap) {
        print('⚠ pubspec.yaml 中未找到 toly 配置段，使用默认配置');
        return TolyUIGenConfig.defaults();
      }

      final codeGen = toly['code_gen'];
      if (codeGen == null || codeGen is! YamlMap) {
        print('⚠ 未找到 toly.code_gen 配置，使用默认配置');
        return TolyUIGenConfig.defaults();
      }

      final parserDir = _resolvePath(codeGen['parser_dir'], 'lib/view/widgets');
      final genDistDir = _resolvePath(codeGen['gen_dist_dir'], 'lib/view/widgets/display_nodes/gen');
      final codeResDir = _resolvePath(codeGen['code_res_dir'], 'assets/code_res');

      print('✅ 从 pubspec.yaml 读取配置:');
      print('   扫描目录   : $parserDir');
      print('   生成目录   : $genDistDir');
      print('   源码导出   : $codeResDir');

      return TolyUIGenConfig(
        parserDir: parserDir,
        genDistDir: genDistDir,
        codeResDir: codeResDir,
      );
    } catch (e) {
      print('⚠ 解析 pubspec.yaml 失败: $e，使用默认配置');
      return TolyUIGenConfig.defaults();
    }
  }

  String _resolvePath(dynamic value, String fallback) {
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return fallback;
  }
}
