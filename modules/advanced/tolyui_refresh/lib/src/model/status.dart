
/// header state
enum RefreshStatus {
  /// Initial state, when not being overscrolled into, or after the overscroll
  /// is canceled or after done and the sliver retracted away.
  idle,

  /// Dragged far enough that the onRefresh callback will callback
  canRefresh,

  /// the indicator is refreshing,waiting for the finish callback
  refreshing,

  /// the indicator refresh completed
  completed,

  /// the indicator refresh failed
  failed,

  ///  Dragged far enough that the onTwoLevel callback will callback
  canTwoLevel,

  ///  indicator is opening twoLevel
  twoLevelOpening,

  /// indicator is in twoLevel
  twoLeveling,

  ///  indicator is closing twoLevel
  twoLevelClosing
}

///  footer state
enum LoadStatus {
  /// Initial state, which can be triggered loading more by gesture pull up
  idle,
  canLoading,

  /// indicator is loading more data
  loading,

  /// indicator is no more data to loading,this state doesn't allow to load more whatever
  noMore,

  /// indicator load failed,Initial state, which can be click retry,If you need to pull up trigger load more,you should set enableLoadingWhenFailed = true in RefreshConfiguration
  failed
}

/// header indicator display style
enum RefreshStyle {
  // indicator box always follow content
  Follow,
  // indicator box follow content,When the box reaches the top and is fully visible, it does not follow content.
  UnFollow,

  /// Let the indicator size zoom in with the boundary distance,look like showing behind the content
  Behind,

  /// this style just like flutter RefreshIndicator,showing above the content
  Front
}

/// footer indicator display style
enum LoadStyle {
  /// indicator always own layoutExtent whatever the state
  ShowAlways,

  /// indicator always own 0.0 layoutExtent whatever the state
  HideAlways,

  /// indicator always own layoutExtent when loading state, the other state is 0.0 layoutExtent
  ShowWhenLoading
}