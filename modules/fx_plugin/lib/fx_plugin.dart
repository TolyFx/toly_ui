library;

abstract class FxPlugin<T> {
  Future<void> mount({T? res});

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class Fx {
  static Map<FxPlugin, dynamic> pluginsMap = {};

  // static use(FxPlugin plugin){
  //   pluginsMap[plugin] = .add(plugin);
  // }
  //
  // Future<void> mount({void res}) async{
  //   for(FxPlugin plugin in FxPlugin){
  //
  //   }
  // }
}
