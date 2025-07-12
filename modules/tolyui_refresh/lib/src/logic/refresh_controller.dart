
part of '../ui/core/toly_refresh.dart';

/// A controller controll header and footer state,
/// it  can trigger  driving request Refresh ,set the initalRefresh,status if needed
///
/// See also:
///
/// * [TolyRefresh],a widget help you attach refresh and load more function easily
class RefreshController {
  TolyRefreshState? _refresherState;

  /// header status mode controll
  RefreshNotifier<RefreshStatus>? headerMode;

  /// footer status mode controll
  RefreshNotifier<LoadStatus>? footerMode;

  /// the scrollable inner's position
  ///
  /// notice that: position is null before build,
  /// the value is get when the header or footer callback onPositionUpdated
  ScrollPosition? position;

  RefreshStatus? get headerStatus => headerMode?.value;

  LoadStatus? get footerStatus => footerMode?.value;

  bool get isRefresh => headerMode?.value == RefreshStatus.refreshing;

  bool get isTwoLevel =>
      headerMode?.value == RefreshStatus.twoLeveling ||
          headerMode?.value == RefreshStatus.twoLevelOpening ||
          headerMode?.value == RefreshStatus.twoLevelClosing;

  bool get isLoading => footerMode?.value == LoadStatus.loading;

  final bool initialRefresh;

  /// initialRefresh:When SmartRefresher is init,it will call requestRefresh at once
  ///
  /// initialRefreshStatus: headerMode default value
  ///
  /// initialLoadStatus: footerMode default value
  RefreshController(
      {this.initialRefresh = false,
        RefreshStatus? initialRefreshStatus,
        LoadStatus? initialLoadStatus}) {
    this.headerMode =
        RefreshNotifier(initialRefreshStatus ?? RefreshStatus.idle);
    this.footerMode = RefreshNotifier(initialLoadStatus ?? LoadStatus.idle);
  }

  void _bindState(TolyRefreshState state) {
    assert(_refresherState == null,
    "Don't use one refreshController to multiple SmartRefresher,It will cause some unexpected bugs mostly in TabBarView");
    _refresherState = state;
  }

  /// callback when the indicator is builded,and catch the scrollable's inner position
  void onPositionUpdated(ScrollPosition newPosition) {
    position?.isScrollingNotifier.removeListener(_listenScrollEnd);
    position = newPosition;
    position!.isScrollingNotifier.addListener(_listenScrollEnd);
  }

  void _detachPosition() {
    _refresherState = null;
    position?.isScrollingNotifier.removeListener(_listenScrollEnd);
  }

  StatefulElement? _findIndicator(BuildContext context, Type elementType) {
    StatefulElement? result;
    context.visitChildElements((Element e) {
      if (elementType == RefreshIndicator) {
        if (e.widget is RefreshIndicator) {
          result = e as StatefulElement?;
        }
      } else {
        if (e.widget is LoadIndicator) {
          result = e as StatefulElement?;
        }
      }

      result ??= _findIndicator(e, elementType);
    });
    return result;
  }

  /// when bounce out of edge and stopped by overScroll or underScroll, it should be SpringBack to 0.0
  /// but ScrollPhysics didn't provide one way to spring back when outOfEdge(stopped by applyBouncingCondition return != 0.0)
  /// so for making it spring back, it should be trigger goBallistic make it spring back
  void _listenScrollEnd() {
    if (position != null && position!.outOfRange) {
      position?.activity?.applyNewDimensions();
    }
  }

  /// make the header enter refreshing state,and callback onRefresh
  Future<void>? requestRefresh(
      {bool needMove = true,
        bool needCallback = true,
        Duration duration = const Duration(milliseconds: 500),
        Curve curve = Curves.linear}) async {
    assert(position != null,
    'Try not to call requestRefresh() before build,please call after the ui was rendered');
    if (isRefresh) return Future.value();
    StatefulElement? indicatorElement =
    _findIndicator(position!.context.storageContext, RefreshIndicator);

    if (indicatorElement == null || _refresherState == null) return null;
    (indicatorElement.state as RefreshIndicatorState).floating = true;

    if (needMove && _refresherState!.mounted)
      _refresherState!.setCanDrag(false);
    if (needMove) {
      return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
        // - 0.0001 is for NestedScrollView.
        await position
            ?.animateTo(position!.minScrollExtent - 0.0001,
            duration: duration, curve: curve)
            .then((_) {
          if (_refresherState != null && _refresherState!.mounted) {
            _refresherState!.setCanDrag(true);
            if (needCallback) {
              headerMode!.value = RefreshStatus.refreshing;
            } else {
              headerMode!.setValueWithNoNotify(RefreshStatus.refreshing);
              if (indicatorElement.state.mounted)
                (indicatorElement.state as RefreshIndicatorState)
                    .setState(() {});
            }
          }
        });
      });
    } else {
      Future.value().then((_) {
        headerMode!.value = RefreshStatus.refreshing;
      });
    }
  }

  /// make the header enter refreshing state,and callback onRefresh
  Future<void> requestTwoLevel(
      {Duration duration = const Duration(milliseconds: 300),
        Curve curve = Curves.linear}) {
    assert(position != null,
    'Try not to call requestRefresh() before build,please call after the ui was rendered');
    headerMode!.value = RefreshStatus.twoLevelOpening;
    return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
      await position?.animateTo(position!.minScrollExtent,
          duration: duration, curve: curve);
    });
  }

  /// make the footer enter loading state,and callback onLoading
  Future<void>? requestLoading(
      {bool needMove = true,
        bool needCallback = true,
        Duration duration = const Duration(milliseconds: 300),
        Curve curve = Curves.linear}) {
    assert(position != null,
    'Try not to call requestLoading() before build,please call after the ui was rendered');
    if (isLoading) return Future.value();
    StatefulElement? indicatorElement =
    _findIndicator(position!.context.storageContext, LoadIndicator);

    if (indicatorElement == null || _refresherState == null) return null;
    (indicatorElement.state as LoadIndicatorState).floating = true;
    if (needMove && _refresherState!.mounted)
      _refresherState!.setCanDrag(false);
    if (needMove) {
      return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
        await position
            ?.animateTo(position!.maxScrollExtent,
            duration: duration, curve: curve)
            .then((_) {
          if (_refresherState != null && _refresherState!.mounted) {
            _refresherState!.setCanDrag(true);
            if (needCallback) {
              footerMode!.value = LoadStatus.loading;
            } else {
              footerMode!.setValueWithNoNotify(LoadStatus.loading);
              if (indicatorElement.state.mounted)
                (indicatorElement.state as LoadIndicatorState).setState(() {});
            }
          }
        });
      });
    } else {
      return Future.value().then((_) {
        footerMode!.value = LoadStatus.loading;
      });
    }
  }

  /// request complete,the header will enter complete state,
  ///
  /// resetFooterState : it will set the footer state from noData to idle
  void refreshCompleted({bool resetFooterState = false}) {
    headerMode?.value = RefreshStatus.completed;
    if (resetFooterState) {
      resetNoData();
    }
  }

  /// end twoLeveling,will return back first floor
  Future<void>? twoLevelComplete(
      {Duration duration = const Duration(milliseconds: 500),
        Curve curve = Curves.linear}) {
    headerMode?.value = RefreshStatus.twoLevelClosing;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      position!
          .animateTo(0.0, duration: duration, curve: curve)
          .whenComplete(() {
        headerMode!.value = RefreshStatus.idle;
      });
    });
    return null;
  }

  /// request failed,the header display failed state
  void refreshFailed() {
    headerMode?.value = RefreshStatus.failed;
  }

  /// not show success or failed, it will set header state to idle and spring back at once
  void refreshToIdle() {
    headerMode?.value = RefreshStatus.idle;
  }

  /// after data returned,set the footer state to idle
  void loadComplete() {
    // change state after ui update,else it will have a bug:twice loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.idle;
    });
  }

  /// If catchError happen,you may call loadFailed indicate fetch data from network failed
  void loadFailed() {
    // change state after ui update,else it will have a bug:twice loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.failed;
    });
  }

  /// load more success without error,but no data returned
  void loadNoData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.noMore;
    });
  }

  /// reset footer noData state  to idle
  void resetNoData() {
    if (footerMode?.value == LoadStatus.noMore) {
      footerMode!.value = LoadStatus.idle;
    }
  }

  /// for some special situation, you should call dispose() for safe,it may throw errors after parent widget dispose
  void dispose() {
    headerMode!.dispose();
    footerMode!.dispose();
    headerMode = null;
    footerMode = null;
  }
}


class RefreshNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  RefreshNotifier(this._value);

  T _value;

  @override
  T get value => _value;

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  void setValueWithNoNotify(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
