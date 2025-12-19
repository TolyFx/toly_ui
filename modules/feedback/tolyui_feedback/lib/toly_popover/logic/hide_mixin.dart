part of '../toly_popover.dart';

/// 辅助功能
/// 分离滑动和尺寸变化监听逻辑
mixin PopHideMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  ScrollPosition? _scrollPosition;

  double offset = 0;

  void recordScrollPosition() {
    bool hasPixels = _scrollPosition?.hasPixels ?? false;
    if (!hasPixels) return;
    offset = _scrollPosition?.pixels ?? 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition?.isScrollingNotifier.removeListener(_handleScroll);
    _scrollPosition = Scrollable.maybeOf(context)?.position;
    _scrollPosition?.isScrollingNotifier.addListener(_handleScroll);
    recordScrollPosition();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollPosition?.isScrollingNotifier.removeListener(_handleScroll);
    super.dispose();
  }

  // 监听窗口尺寸变化
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    onHide();
  }

  void _handleScroll() {
    if (mounted) {
      /// 过滤不必要的滑动变化监听
      if (offset != _scrollPosition?.pixels) {
        onHide();
      }
    }
  }

  void onHide();
}
