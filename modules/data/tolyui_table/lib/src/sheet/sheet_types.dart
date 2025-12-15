import 'package:flutter/material.dart';

// ========== 数据快照 ==========
class SheetDataSnapshot<T> {
  final List<T> items;
  final int totalCount;
  final bool hasMore;
  final SheetDataState state;

  const SheetDataSnapshot({
    required this.items,
    required this.totalCount,
    this.hasMore = false,
    this.state = SheetDataState.loaded,
  });
}

enum SheetDataState { loading, loaded, error, empty }

// ========== 单元格上下文 ==========
class CellContext<T> {
  final T data;
  final int rowIndex;
  final String fieldKey;
  final bool isEditing;
  final VoidCallback? requestEdit;

  const CellContext({
    required this.data,
    required this.rowIndex,
    required this.fieldKey,
    this.isEditing = false,
    this.requestEdit,
  });
}

// ========== 字段表头 ==========
class FieldHeader {
  final String title;
  final Widget? icon;
  final String? tooltip;

  const FieldHeader({
    required this.title,
    this.icon,
    this.tooltip,
  });
}

// ========== 字段约束 ==========
class FieldConstraint {
  final double? width;
  final double? minWidth;
  final double? maxWidth;
  final Alignment alignment;

  const FieldConstraint({
    this.width,
    this.minWidth,
    this.maxWidth,
    this.alignment = Alignment.centerLeft,
  });
}

// ========== 字段能力 ==========
class FieldCapability {
  final SortConfig? sortable;
  final FilterConfig? filterable;
  final EditConfig? editable;
  final PinConfig? pinnable;

  const FieldCapability({
    this.sortable,
    this.filterable,
    this.editable,
    this.pinnable,
  });
}

class SortConfig {
  final Comparator<dynamic>? comparator;
  final bool multiSort;

  const SortConfig({this.comparator, this.multiSort = false});
}

class FilterConfig {
  final FilterOperator operator;

  const FilterConfig({this.operator = FilterOperator.contains});
}

enum FilterOperator { contains, equals, greaterThan, lessThan }

class EditConfig {
  final bool immediate;

  const EditConfig({this.immediate = true});
}

class PinConfig {
  final PinPosition position;

  const PinConfig({required this.position});
}

enum PinPosition { left, right }

// ========== 行为配置 ==========
class SheetBehavior {
  final PickStrategy? pickStrategy;
  final ScrollStrategy? scrollStrategy;
  final ExpandStrategy? expandStrategy;

  const SheetBehavior({
    this.pickStrategy,
    this.scrollStrategy,
    this.expandStrategy,
  });
}

class PickStrategy {
  final PickMode mode;
  final void Function(Set<int> indices)? onChanged;

  const PickStrategy({
    this.mode = PickMode.multiple,
    this.onChanged,
  });
}

enum PickMode { single, multiple, range }

class ScrollStrategy {
  final bool enableVirtual;
  final int viewportBuffer;

  const ScrollStrategy({
    this.enableVirtual = true,
    this.viewportBuffer = 5,
  });
}

class ExpandStrategy<T> {
  final Widget Function(T data, int index) builder;
  final ExpandTrigger trigger;

  const ExpandStrategy({
    required this.builder,
    this.trigger = ExpandTrigger.icon,
  });
}

enum ExpandTrigger { icon, row, manual }

// ========== 外观配置 ==========
class SheetAppearance {
  final LayoutMode layoutMode;
  final Color? headerColor;
  final Color? borderColor;
  final bool showBorder;
  final double rowHeight;

  const SheetAppearance({
    this.layoutMode = LayoutMode.fluid,
    this.headerColor,
    this.borderColor,
    this.showBorder = true,
    this.rowHeight = 48,
  });
}

enum LayoutMode { fluid, fixed, hybrid }
