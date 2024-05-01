enum Rx {
  xs, // (超小屏): < 576px
  sm, // (小屏幕): 576px(含) - 768px
  md, // (中屏幕): 768px(含) - 992px
  lg, // lg(大屏幕): 992px(含) - 1200px
  xl, // xl(超大屏幕): > 1200px(含)
}

typedef Op<T> = T Function(Rx re);
