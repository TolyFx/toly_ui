/// The type of size responsive
/// Default strategy is [_defaultParserStrategy] ,
/// You can change strategy by [ReParserStrategyTheme]
enum Rx {
  xs, // (超小屏):
  sm, // (小屏幕):
  md, // (中屏幕):
  lg, // (大屏幕):
  xl, // (超大屏幕):
}

/// The default strategy of responsive layout
/// xs: [0,576)
/// sm: [576,768)
/// xs: [768,992)
/// xs: [992,1200)
/// xs: [1200,)
Rx defaultParserStrategy(double width) {
  if (width < 576) return Rx.xs;
  if (width >= 576 && width < 768) return Rx.sm;
  if (width >= 768 && width < 992) return Rx.md;
  if (width >= 992 && width < 1200) return Rx.lg;
  return Rx.xl;
}

typedef Op<T> = T Function(Rx re);

extension RxT<T> on T {
  Op<T> get rx => (Rx re) => this;
}
