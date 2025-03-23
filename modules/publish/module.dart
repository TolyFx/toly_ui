class UpdateInfo {
  final String moduleName;
  final String newVersion;
  final String changLog;

  UpdateInfo({
    required this.moduleName,
    required this.newVersion,
    required this.changLog,
  });
}

class Module {
  final String name;
  final String description;
  String version;
  String changLog = '';
  final List<Module> children;

  Module({
    required this.name,
    required this.version,
    required this.description,
    this.children = const [],
    this.changLog ='',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'version': version,
        'description': description,
        'changLog': changLog,
        if (children.isNotEmpty)
          'children': children.map((e) => e.toJson()).toList(),
      };

  String displayTree({String prefix = '', bool isLast = true}) {
    final buffer = StringBuffer();
    final marker = isLast ? '└──' : '├──';
    buffer.writeln('$prefix$marker $name ($version)');

    if (children.isNotEmpty) {
      final childPrefix = prefix + (isLast ? '    ' : '│   ');
      for (var i = 0; i < children.length; i++) {
        buffer.write(children[i].displayTree(
          prefix: childPrefix,
          isLast: i == children.length - 1,
        ));
      }
    }

    return buffer.toString();
  }



  bool updateVersion(List<UpdateInfo> updates) {
    bool hasUpdates = false;

    // 检查当前模块是否在更新列表中
    final updateInfo = updates.where((u) => u.moduleName == name).firstOrNull;
    if (updateInfo != null) {
      version = updateInfo.newVersion;
      changLog = updateInfo.changLog;
      hasUpdates = true;
    }

    // 检查子模块更新
    for (var child in children) {
      if (child.updateVersion(updates)) {
        if (!hasUpdates) {
          _incrementVersion();
          // 如果是因为子模块更新而更新版本号，将子模块信息添加到父模块的更新记录中
            changLog = '* ${child.name} -> ${child.version}\n';
        }
        hasUpdates = true;
      }
    }

    return hasUpdates;
  }

  void _incrementVersion() {
    final parts = version.split('+');
    if (parts.length > 1) {
      // 处理带有 build number 的版本号
      final buildNumber = int.parse(parts[1]);
      version = '${parts[0]}+${buildNumber + 1}';
    } else {
      // 处理普通版本号
      version += "+1";
    }
  }
}