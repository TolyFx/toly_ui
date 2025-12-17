import 'package:flutter/material.dart';
import 'data_provider.dart';
import 'field_spec.dart';
import 'sheet_types.dart';
import 'sheet_controller.dart';

class TolyTable<T> extends StatefulWidget {
  final SheetDataProvider<T> provider;
  final List<FieldSpec<T>> fields;
  final SheetBehavior? behavior;
  final SheetAppearance? appearance;
  final SheetController<T>? controller;

  const TolyTable({
    super.key,
    required this.provider,
    required this.fields,
    this.behavior,
    this.appearance,
    this.controller,
  });

  TolyTable.source({
    super.key,
    required List<Map<String, dynamic>> data,
    required T Function(Map<String, dynamic>) converter,
    required this.fields,
    this.behavior,
    this.appearance,
    this.controller,
  }) : provider = _LocalSheetProviderWrapper<T>(data.map(converter).toList());

  @override
  State<TolyTable<T>> createState() => _TolyTableState<T>();
}

class _LocalSheetProviderWrapper<T> extends SheetDataProvider<T> {
  final List<T> data;
  late final LocalSheetProvider<T> _provider;

  _LocalSheetProviderWrapper(this.data) {
    _provider = LocalSheetProvider<T>(data: data);
  }

  @override
  Stream<SheetDataSnapshot<T>> get dataStream => _provider.dataStream;

  @override
  Future<void> refresh() => _provider.refresh();

  @override
  Future<void> loadMore() => _provider.loadMore();
}

class _TolyTableState<T> extends State<TolyTable<T>> {
  late SheetController<T> _controller;
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  int? _hoveredRowIndex;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SheetController<T>();
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SheetDataSnapshot<T>>(
      stream: widget.provider.dataStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;

        if (data.state == SheetDataState.empty) {
          return const Center(child: Text('暂无数据'));
        }

        if (data.state == SheetDataState.error) {
          return const Center(child: Text('加载失败'));
        }

        return _buildSheet(data);
      },
    );
  }

  Widget _buildSheet(SheetDataSnapshot<T> data) {
    final appearance = widget.appearance ?? const SheetAppearance();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: appearance.showBorder
              ? (appearance.borderColor ?? const Color(0xFFF0F0F0))
              : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (appearance.headerActions != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: appearance.showBorder
                        ? (appearance.borderColor ?? const Color(0xFFF0F0F0))
                        : Colors.transparent,
                  ),
                ),
              ),
              child: appearance.headerActions,
            ),
          _buildHeader(appearance),
          _buildBody(data, appearance),
          if (appearance.footerActions != null)
            Container(
              padding: const EdgeInsets.all(12),
              child: appearance.footerActions,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(SheetAppearance appearance) {
    final hasPickStrategy = widget.behavior?.pickStrategy != null;
    final hasExpandStrategy = widget.behavior?.expandStrategy != null;
    final hasGroupedHeaders = widget.fields.any((f) => f.hasChildren);

    if (hasGroupedHeaders) {
      return _buildGroupedHeader(
          appearance, hasPickStrategy, hasExpandStrategy);
    }

    return Container(
      height: appearance.rowHeight,
      decoration: BoxDecoration(
        color: appearance.headerColor ?? const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(
            color: appearance.borderColor ?? const Color(0xFFF0F0F0),
          ),
        ),
      ),
      child: Row(
        children: [
          if (hasPickStrategy) _buildPickAllCell(appearance),
          if (hasExpandStrategy) _buildExpandHeaderCell(appearance),
          ...widget.fields.map((field) => _buildHeaderCell(field, appearance)),
        ],
      ),
    );
  }

  Widget _buildGroupedHeader(SheetAppearance appearance, bool hasPickStrategy,
      bool hasExpandStrategy) {
    final maxDepth = _getMaxDepth(widget.fields);

    return Container(
      decoration: BoxDecoration(
        color: appearance.headerColor ?? const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(
            color: appearance.borderColor ?? const Color(0xFFF0F0F0),
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasPickStrategy) SizedBox(width: 48),
            if (hasExpandStrategy) SizedBox(width: 48),
            ...widget.fields.map((field) =>
                _buildMultiLevelHeaderColumn(field, appearance, maxDepth, 1)),
          ],
        ),
      ),
    );
  }

  int _getMaxDepth(List<FieldSpec<T>> fields) {
    int maxDepth = 1;
    for (final field in fields) {
      if (field.hasChildren) {
        maxDepth = maxDepth > (1 + _getMaxDepth(field.children!))
            ? maxDepth
            : (1 + _getMaxDepth(field.children!));
      }
    }
    return maxDepth;
  }

  Widget _buildMultiLevelHeaderColumn(FieldSpec<T> field,
      SheetAppearance appearance, int maxDepth, int currentDepth) {
    if (field.hasChildren) {
      return Expanded(
        flex: _getFieldSpan(field),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: appearance.rowHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                  ),
                  right: BorderSide(
                    color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                  ),
                ),
              ),
              child: Text(
                field.header.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: field.children!
                    .map((child) => _buildMultiLevelHeaderColumn(
                        child, appearance, maxDepth, currentDepth + 1))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    } else {
      final remainingDepth = maxDepth - currentDepth + 1;
      return Expanded(
        child: Container(
          height: appearance.rowHeight * remainingDepth,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: appearance.borderColor ?? const Color(0xFFF0F0F0),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (field.header.icon != null) ...[
                field.header.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                field.header.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              if (field.isSortable) _buildSortIcon(field),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildHeaderColumn(FieldSpec<T> field, SheetAppearance appearance) {
    if (field.hasChildren) {
      return Expanded(
        flex: _getFieldSpan(field),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: appearance.rowHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                  ),
                  right: BorderSide(
                    color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                  ),
                ),
              ),
              child: Text(
                field.header.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Container(
              height: appearance.rowHeight,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                  ),
                ),
              ),
              child: Row(
                children: field.children!.asMap().entries.map((entry) {
                  final isLast = entry.key == field.children!.length - 1;
                  return Expanded(
                    child: Container(
                      height: appearance.rowHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: entry.value.constraint?.alignment ??
                          Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border(
                          right: isLast
                              ? BorderSide.none
                              : BorderSide(
                                  color: appearance.borderColor ??
                                      const Color(0xFFF0F0F0),
                                ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (entry.value.header.icon != null) ...[
                            entry.value.header.icon!,
                            const SizedBox(width: 8),
                          ],
                          Text(
                            entry.value.header.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          if (entry.value.isSortable)
                            _buildSortIcon(entry.value),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Container(
          height: appearance.rowHeight * 2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: appearance.borderColor ?? const Color(0xFFF0F0F0),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (field.header.icon != null) ...[
                field.header.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                field.header.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              if (field.isSortable) _buildSortIcon(field),
            ],
          ),
        ),
      );
    }
  }

  List<FieldSpec<T>> _getFlatFields(List<FieldSpec<T>> fields) {
    final result = <FieldSpec<T>>[];
    for (final field in fields) {
      if (field.hasChildren) {
        result.addAll(_getFlatFields(field.children!));
      } else {
        result.add(field);
      }
    }
    return result;
  }

  int _getFieldSpan(FieldSpec<T> field) {
    if (!field.hasChildren) return 1;
    return field.children!.fold(0, (sum, child) => sum + _getFieldSpan(child));
  }

  Widget _buildPickAllCell(SheetAppearance appearance) {
    final pickMode = widget.behavior?.pickStrategy?.mode ?? PickMode.multiple;
    
    return SizedBox(
      width: 48,
      child: pickMode == PickMode.single
          ? const SizedBox.shrink()
          : StreamBuilder<SheetDataSnapshot<T>>(
              stream: widget.provider.dataStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final totalCount = snapshot.data!.items.length;
                
                return ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    final selectedCount = _controller.pickedIndices.length;
                    final allSelected = selectedCount == totalCount && totalCount > 0;
                    final someSelected = selectedCount > 0 && selectedCount < totalCount;
                    
                    return Checkbox(
                      value: allSelected ? true : (someSelected ? null : false),
                      tristate: true,
                      onChanged: (value) {
                        if (allSelected || someSelected) {
                          _controller.clearPicks();
                        } else {
                          _controller.clearPicks();
                          for (int i = 0; i < totalCount; i++) {
                            _controller.pickRow(i);
                          }
                        }
                        widget.behavior?.pickStrategy?.onChanged
                            ?.call(_controller.pickedIndices);
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildExpandHeaderCell(SheetAppearance appearance) {
    return SizedBox(
      width: 48,
      child: Container(),
    );
  }

  Widget _buildHeaderCell(FieldSpec<T> field, SheetAppearance appearance) {
    final inset = appearance.dividerInset ?? EdgeInsets.zero;
    final isFixed = appearance.layoutMode == LayoutMode.fixed;
    final constraint = field.constraint;
    
    Widget cell = Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: field.header.alignment ?? constraint?.alignment ?? Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (field.header.icon != null) ...[
                field.header.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                field.header.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              if (field.isSortable) _buildSortIcon(field),
            ],
          ),
        ),
        if (appearance.showHeaderColumnDivider)
          Positioned(
            right: 0,
            top: inset.top,
            bottom: inset.bottom,
            child: Container(
              width: 1,
              color: appearance.borderColor ?? const Color(0xFFF0F0F0),
            ),
          ),
      ],
    );
    
    if (isFixed && constraint?.width != null) {
      return SizedBox(width: constraint!.width, child: cell);
    }
    if (isFixed && constraint?.minWidth != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: constraint!.minWidth!,
          maxWidth: constraint.maxWidth ?? double.infinity,
        ),
        child: cell,
      );
    }
    return Expanded(child: cell);
  }

  Widget _buildSortIcon(FieldSpec<T> field) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final isSorted = _controller.sortField == field.key;
        return IconButton(
          icon: Icon(
            isSorted
                ? (_controller.sortAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward)
                : Icons.unfold_more,
            size: 16,
          ),
          onPressed: () {
            if (isSorted) {
              _controller.sortBy(field.key,
                  ascending: !_controller.sortAscending);
            } else {
              _controller.sortBy(field.key);
            }
          },
        );
      },
    );
  }

  Widget _buildBody(SheetDataSnapshot<T> data, SheetAppearance appearance) {
    final hasPickStrategy = widget.behavior?.pickStrategy != null;
    final hasExpandStrategy = widget.behavior?.expandStrategy != null;
    final flatFields = _getFlatFields(widget.fields);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: data.items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow(item, index, appearance, hasPickStrategy,
                hasExpandStrategy, flatFields),
            if (hasExpandStrategy && _controller.isExpanded(index))
              _buildExpandedContent(item, index),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRow(
      T item,
      int index,
      SheetAppearance appearance,
      bool hasPickStrategy,
      bool hasExpandStrategy,
      List<FieldSpec<T>> flatFields) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final isPicked = _controller.isPicked(index);
        final isOddRow = index % 2 == 1;
        final isHovered = _hoveredRowIndex == index;

        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredRowIndex = index),
          onExit: (_) => setState(() => _hoveredRowIndex = null),
          child: Container(
            height: appearance.rowHeight,
            decoration: BoxDecoration(
              color: isPicked 
                  ? const Color(0xFFE6F7FF)
                  : isHovered
                      ? const Color(0xFFF5F5F5)
                      : (appearance.striped && isOddRow
                          ? (appearance.stripedColor ?? const Color(0xFFFAFAFA))
                          : null),
              border: appearance.showRowDivider
                  ? Border(
                      bottom: BorderSide(
                        color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                      ),
                    )
                  : null,
            ),
            child: Row(
            children: [
              if (hasPickStrategy) _buildPickCell(index),
              if (hasExpandStrategy) _buildExpandCell(index),
              ...flatFields.asMap().entries.map((entry) {
                final field = entry.value;
                final isLast = entry.key == flatFields.length - 1;
                final isFixed = appearance.layoutMode == LayoutMode.fixed;
                final constraint = field.constraint;
                
                Widget cell = Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment:
                          constraint?.alignment ?? Alignment.centerLeft,
                      child: field.builder?.call(CellContext<T>(
                            data: item,
                            rowIndex: index,
                            fieldKey: field.key,
                          )) ??
                          const SizedBox.shrink(),
                    ),
                    if (appearance.showBodyColumnDivider && !isLast)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 1,
                          color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                        ),
                      ),
                  ],
                );
                
                if (isFixed && constraint?.width != null) {
                  return SizedBox(width: constraint!.width, child: cell);
                }
                if (isFixed && constraint?.minWidth != null) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraint!.minWidth!,
                      maxWidth: constraint.maxWidth ?? double.infinity,
                    ),
                    child: cell,
                  );
                }
                return Expanded(child: cell);
              }),
            ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickCell(int index) {
    final pickMode = widget.behavior?.pickStrategy?.mode ?? PickMode.multiple;
    final isPicked = _controller.isPicked(index);

    return SizedBox(
      width: 48,
      child: pickMode == PickMode.single
          ? Radio<int>(
              value: index,
              groupValue: isPicked ? index : null,
              onChanged: (value) {
                _controller.clearPicks();
                if (value != null) {
                  _controller.pickRow(value);
                }
                widget.behavior?.pickStrategy?.onChanged
                    ?.call(_controller.pickedIndices);
              },
            )
          : Checkbox(
              value: isPicked,
              onChanged: (value) {
                _controller.togglePick(index);
                widget.behavior?.pickStrategy?.onChanged
                    ?.call(_controller.pickedIndices);
              },
            ),
    );
  }

  Widget _buildExpandCell(int index) {
    return SizedBox(
      width: 48,
      child: IconButton(
        icon: Icon(
          _controller.isExpanded(index) ? Icons.expand_less : Icons.expand_more,
          size: 20,
        ),
        onPressed: () => _controller.toggleExpand(index),
      ),
    );
  }

  Widget _buildDataCell(
      T item, int index, FieldSpec<T> field, SheetAppearance appearance) {
    final context = CellContext<T>(
      data: item,
      rowIndex: index,
      fieldKey: field.key,
    );

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: field.constraint?.alignment ?? Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: appearance.borderColor ?? const Color(0xFFF0F0F0),
            ),
          ),
        ),
        child: field.builder?.call(context) ?? const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildExpandedContent(T item, int index) {
    final expandStrategy = widget.behavior?.expandStrategy;
    if (expandStrategy == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0)),
        ),
      ),
      child: expandStrategy.builder(item, index),
    );
  }
}
