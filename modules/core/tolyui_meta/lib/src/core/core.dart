/// 唯一标识接口
abstract interface class Identify<T> {
  T get id;
}


/// 额外数据
abstract class Extra{
  const Extra();

  T? me<T extends Extra>(){
    return call<T>();
  }

  T? call<T extends Extra>(){
    if(this is T){
      return this as T;
    }
    return null;
  }
}