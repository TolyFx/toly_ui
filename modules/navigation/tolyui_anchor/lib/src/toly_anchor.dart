import 'package:flutter/material.dart';
import 'positioned_list/item_positions_listener.dart';
import 'positioned_list/scrollable_positioned_list.dart';

typedef TolyAnchorLinkBuilder = Widget Function(
    BuildContext context, TolyAnchorLink link, bool active);

class TolyAnchorLink {
  final String title;
  final String href;
  final List<TolyAnchorLink>? children;

  const TolyAnchorLink({
    required this.title,
    required this.href,
    this.children,
  });
}

/// TolyAnchor 控制器
/// 基于 scrollable_positioned_list 实现，支持精确跳转到指定索引
class TolyAnchorController extends ChangeNotifier {
  /// ItemScrollController 用于控制滚动
  final ItemScrollController itemScrollController = ItemScrollController();
  
  /// ItemPositionsListener 用于监听可见项位置
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  
  /// 当前激活的索引
  int _activeIndex = 0;
  int get activeIndex => _activeIndex;
  
  /// 当前激活的标签（兼容旧API）
  String? get activeTag => 'item_$_activeIndex';
  
  /// 滚动锁定标志
  bool _isScrolling = false;
  
  /// 标签到索引的映射
  final Map<String, int> _tagToIndex = {};
  
  /// 注册标签和索引的映射
  void registerTag(String tag, int index) {
    _tagToIndex[tag] = index;
  }
  
  /// 注销标签
  void unregisterTag(String tag) {
    _tagToIndex.remove(tag);
  }
  
  /// 处理位置变化（内部使用）
  void handlePositionChange(int newIndex) {
    if (!_isScrolling && newIndex != _activeIndex) {
      _activeIndex = newIndex;
      notifyListeners();
    }
  }
  
  /// 通知检查滚动位置（即使 activeIndex 没变化）
  void notifyScrollCheck() {
    notifyListeners();
  }
  
  /// 滚动到指定索引
  Future<void> scrollToIndex(int index, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    _isScrolling = true;
    _activeIndex = index;
    notifyListeners();
    
    await itemScrollController.scrollTo(
      index: index,
      duration: duration,
      curve: curve,
    );
    
    // 延迟解锁
    await Future.delayed(const Duration(milliseconds: 50));
    _isScrolling = false;
  }
  
  /// 滚动到指定标签（兼容旧API）
  Future<void> scrollTo(String tag, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    final index = _tagToIndex[tag];
    if (index != null) {
      await scrollToIndex(index, duration: duration, curve: curve);
    }
  }
  
  /// 跳转到指定索引（无动画）
  void jumpToIndex(int index) {
    _activeIndex = index;
    notifyListeners();
    itemScrollController.jumpTo(index: index);
  }
}

/// TolyAnchor 组件
/// 需要配合 TolyAnchorScrollable 使用
class TolyAnchor extends StatefulWidget {
  final TolyAnchorController controller;
  final List<TolyAnchorLink> links;
  final TolyAnchorLinkBuilder? linkBuilder;
  /// 左侧导航的滚动控制器（可选）
  final ScrollController? scrollController;
  /// 滚动时的偏移量，确保激活项不会紧贴边缘
  final double scrollOffset;
  /// 是否根据内容收缩，默认 false（占满父容器）
  final bool shrinkWrap;
  /// 滚动方向，默认垂直
  final Axis scrollDirection;

  const TolyAnchor({
    super.key,
    required this.controller,
    required this.links,
    this.linkBuilder,
    this.scrollController,
    this.scrollOffset = 20.0,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<TolyAnchor> createState() => _TolyAnchorState();
}

class _TolyAnchorState extends State<TolyAnchor> {
  final ScrollController _defaultScrollController = ScrollController(
    keepScrollOffset: false, // 禁用滚动位置保持，避免类型转换异常
  );
  final Map<int, GlobalKey> _itemKeys = {};
  
  ScrollController get _scrollController => 
      widget.scrollController ?? _defaultScrollController;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    
    // 注册所有标签和创建 GlobalKey
    for (int i = 0; i < widget.links.length; i++) {
      widget.controller.registerTag(widget.links[i].href, i);
      _itemKeys[i] = GlobalKey(debugLabel: 'anchor_item_$i');
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _defaultScrollController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    // 每次收到通知都检查滚动位置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToVisible();
    });
  }
  
  /// 滚动左侧导航，使激活项保持可视
  void _scrollToVisible() {
    if (!_scrollController.hasClients) return;
    if (!mounted) return;
    
    final activeIndex = widget.controller.activeIndex;
    if (activeIndex < 0 || activeIndex >= widget.links.length) return;
    
    // 获取激活项的实际位置
    final itemKey = _itemKeys[activeIndex];
    if (itemKey?.currentContext == null) return;
    
    // 获取 item 的 RenderBox
    final RenderBox? itemBox = itemKey!.currentContext!.findRenderObject() as RenderBox?;
    if (itemBox == null || !itemBox.hasSize) return;
    
    // 获取 item 在屏幕上的位置
    final itemRenderObject = itemKey.currentContext!.findRenderObject();
    if (itemRenderObject == null) return;
    
    // 使用 Scrollable.ensureVisible 的方式计算
    // 获取 viewport 信息
    final viewportDimension = _scrollController.position.viewportDimension;
    final currentOffset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;
    
    // 计算每个 item 的估算高度（通过已渲染的 item）
    // 使用 GlobalKey 获取 item 在列表中的实际位置
    final RenderObject? viewportRenderObject = context.findRenderObject();
    if (viewportRenderObject == null) return;
    
    // 获取 item 相对于 ListView 的位置
    final itemOffset = itemBox.localToGlobal(Offset.zero, ancestor: viewportRenderObject);
    final itemHeight = itemBox.size.height;
    
    // item 在视口中的位置
    final itemTopInViewport = itemOffset.dy;
    final itemBottomInViewport = itemTopInViewport + itemHeight;
    
    // 配置的偏移量
    final offset = widget.scrollOffset;
    
    // 判断激活项是否在可视区域内
    // 如果在视口上方被挡住
    if (itemTopInViewport < offset) {
      final scrollTo = (currentOffset + itemTopInViewport - offset).clamp(0.0, maxScroll);
      _scrollController.animateTo(
        scrollTo,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
    // 如果在视口下方被挡住
    else if (itemBottomInViewport > viewportDimension - offset) {
      final scrollTo = (currentOffset + itemBottomInViewport - viewportDimension + offset).clamp(0.0, maxScroll);
      _scrollController.animateTo(
        scrollTo,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        return ListView.builder(
          controller: _scrollController,
          shrinkWrap: widget.shrinkWrap,
          scrollDirection: widget.scrollDirection,
          itemCount: widget.links.length,
          itemBuilder: (context, index) {
            return _buildLink(index, widget.links[index]);
          },
        );
      },
    );
  }

  Widget _buildLink(int index, TolyAnchorLink link) {
    bool active = widget.controller.activeIndex == index;
    
    // 为每个 item 包裹一个 GlobalKey
    Widget linkWidget;
    
    if (widget.linkBuilder != null) {
      linkWidget = widget.linkBuilder!(context, link, active);
    } else {
      linkWidget = InkWell(
        onTap: () => widget.controller.scrollToIndex(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: active ? Theme.of(context).primaryColor : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
          child: Text(
            link.title,
            style: TextStyle(
              color: active ? Theme.of(context).primaryColor : Colors.black87,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    }
    
    // 使用 Container 包裹并添加 key
    return Container(
      key: _itemKeys[index],
      child: linkWidget,
    );
  }
}

/// TolyAnchorScrollable - 可滚动的锚点内容区域
/// 基于 ScrollablePositionedList 实现
class TolyAnchorScrollable extends StatefulWidget {
  final TolyAnchorController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  /// 滚动方向，默认垂直
  final Axis scrollDirection;

  const TolyAnchorScrollable({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<TolyAnchorScrollable> createState() => _TolyAnchorScrollableState();
}

class _TolyAnchorScrollableState extends State<TolyAnchorScrollable> {
  @override
  void initState() {
    super.initState();
    widget.controller.itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
  }

  void _onPositionsChanged() {
    final positions = widget.controller.itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      // 找到第一个完全可见的项
      final firstVisible = positions
          .where((pos) => pos.itemLeadingEdge >= 0)
          .reduce((min, pos) => pos.itemLeadingEdge < min.itemLeadingEdge ? pos : min);
      
      widget.controller.handlePositionChange(firstVisible.index);
      
      // 通知 TolyAnchor 检查滚动位置（即使 activeIndex 没变化）
      widget.controller.notifyScrollCheck();
    }
  }

  @override
  void dispose() {
    widget.controller.itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: widget.controller.itemScrollController,
      itemPositionsListener: widget.controller.itemPositionsListener,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
      scrollDirection: widget.scrollDirection,
    );
  }
}
