import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
void main() async {
  ProcessResult result = await Process.run(
    'flutter',
    ['build','web'],
    runInShell: true,
    stdoutEncoding: utf8,
  );
  print(result.stdout);
  File file = File(path.join(Directory.current.path,'build','web','index.html'));
  String content = file.readAsStringSync().replaceAll('  <base href="/">', '<!--  <base href="/">-->');
  file.writeAsStringSync(content);
  // String shell = path.join(Directory.current.path,'build','web','push.bat');
  // print(shell);
  // ProcessResult push = await Process.run(
  //   shell,
  //   [],
  //   // workingDirectory: distDir.path,
  //   runInShell: true,
  //   stdoutEncoding: utf8,
  // );
  // print(push.stdout);
}


