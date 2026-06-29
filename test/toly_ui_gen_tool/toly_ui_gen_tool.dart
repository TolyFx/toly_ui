// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'dart:io';

import 'package:path/path.dart' as path;

import 'display_file_parser.dart';
import 'display_meta.dart';
import 'file_gen.dart';
import 'config_reader.dart';

void main(List<String> args) async {
  await TolyUIGenTool(args).gen();
}

/// TolyUI 代码生成工具
///
/// 用法:
///   dart run test/toly_ui_gen_tool/toly_ui_gen_tool.dart          # 使用默认配置
///   dart run test/toly_ui_gen_tool/toly_ui_gen_tool.dart --dry-run # 仅预览
///   dart run test/toly_ui_gen_tool/toly_ui_gen_tool.dart --source lib/view/custom --output lib/view/gen
class TolyUIGenTool {
  final List<String> _args;

  TolyUIGenTool(this._args);

  bool get _dryRun => _args.contains('--dry-run');

  Future<void> gen() async {
    final stopwatch = Stopwatch()..start();

    // 1. 读取配置
    final config = TolyUIConfigReader().read();

    // 2. 校验源目录
    final dataDir = Directory(path.join(Directory.current.path, config.parserDir));
    if (!dataDir.existsSync()) {
      print('❌ 源目录不存在: ${dataDir.path}');
      return;
    }

    // 3. 扫描并解析
    print('\n🔍 开始扫描 ${config.parserDir} ...');
    final displayMap = <String, List<NodeMeta>>{};
    await _scanDir(dataDir, displayMap);

    final totalNodes = displayMap.values.fold<int>(0, (sum, list) => sum + list.length);
    print('✅ 扫描完成: ${displayMap.length} 个分类, $totalNodes 个 @DisplayNode');

    if (totalNodes == 0) {
      print('⚠ 未找到任何 @DisplayNode 注解，退出');
      return;
    }

    if (_dryRun) {
      print('\n📋 预览 (--dry-run):');
      displayMap.forEach((category, nodes) {
        print('  [$category] (${nodes.length} 个组件)');
        for (final node in nodes) {
          print('    • ${node.name} — ${node.display.title}');
        }
      });
      print('\n⏱ 耗时: ${stopwatch.elapsedMilliseconds}ms (预览未写入文件)');
      return;
    }

    // 4. 创建输出目录并确保 assets 目录存在
    final genPath = path.join(Directory.current.path, config.genDistDir);
    await Directory(genPath).create(recursive: true);
    await Directory(path.join(Directory.current.path, config.codeResDir)).create(recursive: true);

    // 5. 导出源码到 assets
    print('\n📦 导出源码到 ${config.codeResDir} ...');
    for (final nodes in displayMap.values) {
      for (final node in nodes) {
        node.saveCode(codeResDir: config.codeResDir);
      }
    }

    // 6. 生成 .g.dart 文件
    print('📝 生成代码到 ${config.genDistDir} ...');
    final out = path.join(genPath, 'node.g.dart');
    await FileGen(displayMap).genNode(out);
    print('  ✅ node.g.dart');
    print('  ✅ widget_display_map.g.dart');
    for (final category in displayMap.keys) {
      print('  ✅ $category.g.dart');
    }

    stopwatch.stop();
    print('\n🎉 生成完毕！耗时 ${stopwatch.elapsedMilliseconds} ms');
  }

  Future<void> _scanDir(Directory dir, Map<String, List<NodeMeta>> displayMap) async {
    final nodes = <NodeMeta>[];
    final entities = dir.listSync();

    // 并行文件解析
    final futures = <Future<NodeMeta?>>[];
    for (final entity in entities) {
      if (entity is File && path.basenameWithoutExtension(entity.path).contains('_demo')) {
        futures.add(DisplayFileParser(entity.path).parse());
      }
    }

    final results = await Future.wait(futures);
    for (final result in results) {
      if (result != null) nodes.add(result);
    }

    if (nodes.isNotEmpty) {
      displayMap[path.basename(dir.path)] = nodes;
      print('  📂 ${path.basename(dir.path)}: ${nodes.length} 个组件');
    }

    // 递归子目录
    for (final entity in entities) {
      if (entity is Directory) {
        await _scanDir(entity, displayMap);
      }
    }
  }
}
