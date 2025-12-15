import 'package:flutter/material.dart';
import 'data_provider.dart';
import 'field_spec.dart';
import 'sheet_types.dart';
import 'sheet_controller.dart';

class TolySheet<T> extends StatefulWidget {
  final SheetDataProvider<T> provider;
  final List<FieldSpec<T>> fields;
  final SheetBehavior? behavior;
  final SheetAppearance? appearance;
  final SheetController<T>? controller;

  const TolySheet({
    super.key,
    required this.provider,
    required this.fields,
    this.behavior,
    this.appearance,
    this.controller,
  });

  @override
  State<TolySheet<T>> createState() => _TolySheetState<T>();
}

class _TolySheetState<T> extends State<TolySheet<T>> {
  late SheetController<T> _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SheetController<T>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      decoration: appearance.showBorder
          ? BoxDecoration(
              border: Border.all(color: appearance.borderColor ?? const Color(0xFFF0F0F0)),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(appearance),
          _buildBody(data, appearance),
        ],
      ),
    );
  }

  Widget _buildHeader(SheetAppearance appearance) {
    final hasPickStrategy = widget.behavior?.pickStrategy != null;
    final hasExpandStrategy = widget.behavior?.expandStrategy != null;
    final hasGroupedHeaders = widget.fields.any((f) => f.hasChildren);
    
    if (hasGroupedHeaders) {
      return _buildGroupedHeader(appearance, hasPickStrategy, hasExpandStrategy);
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

  Widget _buildGroupedHeader(SheetAppearance appearance, bool hasPickStrategy, bool hasExpandStrategy) {
    final flatFields = _getFlatFields(widget.fields);
    
    return Container(
      decoration: BoxDecoration(
        color: appearance.headerColor ?? const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(
            color: appearance.borderColor ?? const Color(0xFFF0F0F0),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildGroupHeaderRow(appearance, hasPickStrategy, hasExpandStrategy),
          _buildSubHeaderRow(appearance, flatFields, hasPickStrategy, hasExpandStrategy),
        ],
      ),
    );
  }

  Widget _buildGroupHeaderRow(SheetAppearance appearance, bool hasPickStrategy, bool hasExpandStrategy) {
    return Container(
      height: appearance.rowHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appearance.borderColor ?? const Color(0xFFF0F0F0),
          ),
        ),
      ),
      child: Row(
        children: [
          if (hasPickStrategy) SizedBox(width: 48, height: appearance.rowHeight),
          if (hasExpandStrategy) SizedBox(width: 48, height: appearance.rowHeight),
          ...widget.fields.map((field) {
            if (field.hasChildren) {
              final span = _getFieldSpan(field);
              return Expanded(
                flex: span,
                child: Container(
                  height: appearance.rowHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                      ),
                    ),
                  ),
                  child: Text(
                    field.header.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              );
            } else {
              return Expanded(
                child: Container(
                  height: appearance.rowHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: appearance.borderColor ?? const Color(0xFFF0F0F0),
                      ),
                    ),
                  ),
                  child: Text(
                    field.header.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSubHeaderRow(SheetAppearance appearance, List<FieldSpec<T>> flatFields, bool hasPickStrategy, bool hasExpandStrategy) {
    return Container(
      height: appearance.rowHeight,
      child: Row(
        children: [
          if (hasPickStrategy) _buildPickAllCell(appearance),
          if (hasExpandStrategy) _buildExpandHeaderCell(appearance),
          ...flatFields.map((field) => _buildHeaderCell(field, appearance)),
        ],
      ),
    );
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
    return SizedBox(
      width: 48,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Checkbox(
            value: _controller.pickedIndices.isNotEmpty,
            tristate: true,
            onChanged: (value) {
              if (value == true) {
                // Pick all logic would go here
              } else {
                _controller.clearPicks();
              }
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: field.constraint?.alignment ?? Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (field.header.icon != null) ...[
              field.header.icon!,
              const SizedBox(width: 8),
            ],
            Text(
              field.header.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            if (field.isSortable) _buildSortIcon(field),
          ],
        ),
      ),
    );
  }

  Widget _buildSortIcon(FieldSpec<T> field) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final isSorted = _controller.sortField == field.key;
        return IconButton(
          icon: Icon(
            isSorted
                ? (_controller.sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.unfold_more,
            size: 16,
          ),
          onPressed: () {
            if (isSorted) {
              _controller.sortBy(field.key, ascending: !_controller.sortAscending);
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
            _buildRow(item, index, appearance, hasPickStrategy, hasExpandStrategy, flatFields),
            if (hasExpandStrategy && _controller.isExpanded(index))
              _buildExpandedContent(item, index),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRow(T item, int index, SheetAppearance appearance, bool hasPickStrategy, bool hasExpandStrategy, List<FieldSpec<T>> flatFields) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final isPicked = _controller.isPicked(index);
        
        return Container(
          height: appearance.rowHeight,
          decoration: BoxDecoration(
            color: isPicked ? const Color(0xFFE6F7FF) : null,
            border: Border(
              bottom: BorderSide(
                color: appearance.borderColor ?? const Color(0xFFF0F0F0),
              ),
            ),
          ),
          child: Row(
            children: [
              if (hasPickStrategy) _buildPickCell(index),
              if (hasExpandStrategy) _buildExpandCell(index),
              ...flatFields.map((field) => _buildDataCell(item, index, field)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickCell(int index) {
    return SizedBox(
      width: 48,
      child: Checkbox(
        value: _controller.isPicked(index),
        onChanged: (value) {
          _controller.togglePick(index);
          widget.behavior?.pickStrategy?.onChanged?.call(_controller.pickedIndices);
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

  Widget _buildDataCell(T item, int index, FieldSpec<T> field) {
    final context = CellContext<T>(
      data: item,
      rowIndex: index,
      fieldKey: field.key,
    );

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: field.constraint?.alignment ?? Alignment.centerLeft,
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
