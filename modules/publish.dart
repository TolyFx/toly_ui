import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  // String module  = 'fx_env';
  // String module  = 'fx_platform_adapter';
  String module  = 'fx_string';
  publishModule(module);
}

Future<void> publishModule(String name) async{
  Directory dir = Directory.current;
  String path = p.join(dir.path, 'modules', name);
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
