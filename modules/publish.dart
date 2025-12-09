import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  // String oldPath =
  //     'd:/Projects/Flutter/Fx/toly_ui/modules/publish/tolyui_0.0.4+6.json';
  // String newPath =
  //     'd:/Projects/Flutter/Fx/toly_ui/modules/publish/tolyui_0.0.4+7.json';
  // List<String> updates = await collect(oldPath, newPath);

  publishModule('tolyui');
  // publishModule('tolyui_feedback');
  // publishModule(folder: 'feedback', 'tolyui_feedback_modal');
  // publishModule(folder: 'data', 'tolyui_statistic');
  // publishModule(folder: 'data', 'tolyui_tag');
  // publishModule('tolyui_image');
  // publishModule('tolyui_text');
  // publishModule('tolyui');

  // for(String module in updates){
  //   await publishModule( module);
  //   await Future.delayed(Duration(minutes: 3));
  // }
}

Future<void> publishModule(String name, {String? folder}) async {
  Directory dir = Directory.current;
  String path = p.join(dir.path, 'modules', name);
  if (folder != null) {
    path = p.join(dir.path, 'modules', folder, name);
  }
  print(path);
  await publish(path, port: 7890);
}

Future<void> publish(String dir, {required int port}) async {
  Process process = await Process.start(
    workingDirectory: dir,
    'dart',
    ['pub', 'publish', '--server', 'https://pub.dartlang.org', '-f'],
    environment: {'https_proxy': 'http://127.0.0.1:$port'},
  );

  process.stdout.listen((e) {
    String value = utf8.decode(e, allowMalformed: true);
    print(value);
  });

  process.stderr.listen((e) {
    String value = utf8.decode(e, allowMalformed: true);
    print(value);
  });
}

Future<List<String>> collect(String oldPath, String newPath) async {
  String oldContent = await File(oldPath).readAsString();
  String newContent = await File(newPath).readAsString();

  Map<String, dynamic> oldJson = jsonDecode(oldContent);
  Map<String, dynamic> newJson = jsonDecode(newContent);

  List<String> updates = [];

  void compareVersions(
      Map<String, dynamic> oldModule, Map<String, dynamic> newModule) {
    // 递归比较子模块
    if (oldModule.containsKey('children') &&
        newModule.containsKey('children')) {
      List<dynamic> oldChildren = oldModule['children'];
      List<dynamic> newChildren = newModule['children'];

      for (int i = 0; i < oldChildren.length; i++) {
        compareVersions(oldChildren[i], newChildren[i]);
      }
    }

    // 比较当前模块版本
    if (oldModule['version'] != newModule['version']) {
      updates.add(newModule['name']);
      // updates.add(
      //     '${newModule['name']}: ${oldModule['version']} -> ${newModule['version']}');
    }
  }

  compareVersions(oldJson, newJson);

  return updates;
}
