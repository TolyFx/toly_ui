import 'package:flutter/material.dart';
import 'dart:math' as math;

class TolyTableV1<T> extends StatefulWidget {
  final List<TableColumn<T>> columns;
  final List<T> dataSource;
  final bool bordered;
  final TableSize size;
  final Widget? title;
  final Widget? footer;
  final TableRowSelection<T>? rowSelection;
  final void Function(T record, int index)? onRow;
  final TablePagination? pagination;
  final bool showHeader;
  final ScrollController? scrollController;
  final double? height;
  final bool sticky;

  const TolyTableV1({
    super.key,
    required this.columns,
    required this.dataSource,
    this.bordered = false,
    this.size = TableSize.middle,
    this.title,
    this.footer,
    this.rowSelection,
    this.onRow,
    this.pagination,
    this.showHeader = true,
    this.scrollController,
    this.height,
    this.sticky = false,
  });

  @override
  State<TolyTableV1<T>> createState() => _TolyTableV1State<T>();
}

class _TolyTableV1State<T> extends State<TolyTableV1<T>> {
  late ScrollController _scrollController;
  Set<int> _selectedRowKeys = {};
  int _currentPage = 1;
  int _pageSize = 10;
  int? _hoveredRowIndex;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    if (widget.pagination != null) {
      _pageSize = widget.pagination!.pageSize;
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  List<T> get _paginatedData {
    if (widget.pagination == null) return widget.dataSource;
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return widget.dataSource.sublist(
      startIndex,
      endIndex > widget.dataSource.length ? widget.dataSource.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null) _buildTitle(),
        _buildTableContainer(),
        if (widget.footer != null) _buildFooter(),
        if (widget.pagination != null) _buildPagination(),
      ],
    );
  }

  Widget _buildTableContainer() {
    Widget table = _buildTable();

    if (widget.height != null) {
      table = SizedBox(height: widget.height, child: table);
    }

    return Container(
      decoration: widget.bordered
          ? BoxDecoration(
              border: Border.all(color: const Color(0xFFF0F0F0)),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: table,
    );
  }

  Widget _buildTable() {
    final effectiveColumns = _getEffectiveColumns();
    final flatColumns = _getFlatColumns(effectiveColumns);

    // 检查是否有多级表头
    final hasGroupedHeaders = effectiveColumns.any((col) => col.isGroup);

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: hasGroupedHeaders
            ? _buildGroupedHeaderTable(effectiveColumns, flatColumns)
            : _buildSimpleTable(flatColumns),
      ),
    );
  }

  Widget _buildSimpleTable(List<TableColumn<T>> flatColumns) {
    return Table(
      border: _buildTableBorder(),
      columnWidths: _buildColumnWidths(flatColumns),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        if (widget.showHeader) _buildSimpleHeaderRow(flatColumns),
        ..._paginatedData
            .asMap()
            .entries
            .map((e) => _buildDataRow(e.value, e.key, flatColumns)),
      ],
    );
  }

  Widget _buildGroupedHeaderTable(
      List<TableColumn<T>> effectiveColumns, List<TableColumn<T>> flatColumns) {
    return Table(
      border: _buildTableBorder(),
      columnWidths: _buildColumnWidths(flatColumns),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        if (widget.showHeader)
          ..._buildGroupedHeaderRows(effectiveColumns, flatColumns),
        ..._paginatedData
            .asMap()
            .entries
            .map((e) => _buildDataRow(e.value, e.key, flatColumns)),
      ],
    );
  }

  List<TableRow> _buildGroupedHeaderRows(
      List<TableColumn<T>> effectiveColumns, List<TableColumn<T>> flatColumns) {
    final rows = <TableRow>[];
    final padding = _getPadding();

    // 第一行：分组标题
    final groupCells = <Widget>[];
    int colIndex = 0;

    for (final column in effectiveColumns) {
      if (column.isGroup) {
        final colSpan = _getColumnSpan(column);
        groupCells.add(
          Container(
            padding: padding,
            alignment: _getAlignment(column.align),
            child: Text(
              column.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        );
        // 为合并的列添加空单元格
        for (int i = 1; i < colSpan; i++) {
          groupCells.add(Container());
        }
        colIndex += colSpan;
      } else {
        groupCells.add(
          Container(
            padding: padding,
            alignment: _getAlignment(column.align),
            child: Text(
              column.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        );
        colIndex++;
      }
    }

    rows.add(TableRow(
      decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
      children: groupCells,
    ));

    // 第二行：子列标题
    final subCells = <Widget>[];

    for (int i = 0; i < flatColumns.length; i++) {
      final column = flatColumns[i];
      Widget cell = Container(
        padding: padding,
        alignment: _getAlignment(column.align),
        child: Text(
          column.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      );

      // 添加全选功能
      if (i == 0 &&
          widget.rowSelection != null &&
          widget.rowSelection?.type != RowSelectionType.radio &&
          column.title.isEmpty) {
        final allSelected = _selectedRowKeys.length == widget.dataSource.length;

        cell = Container(
          padding: padding,
          alignment: Alignment.center,
          child: Checkbox(
            value: allSelected,
            tristate: true,
            onChanged: (value) => _handleSelectAll(value ?? false),
          ),
        );
      }

      subCells.add(cell);
    }

    rows.add(TableRow(
      decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
      children: subCells,
    ));

    return rows;
  }

  TableRow _buildSimpleHeaderRow(List<TableColumn<T>> columns) {
    final padding = _getPadding();
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
      children: columns.asMap().entries.map((entry) {
        final index = entry.key;
        final col = entry.value;

        Widget headerCell = Padding(
          padding: padding,
          child: Align(
            alignment: _getAlignment(col.align),
            child: Text(
              col.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        );

        // 添加全选功能
        if (index == 0 &&
            widget.rowSelection != null &&
            widget.rowSelection?.type != RowSelectionType.radio &&
            col.title.isEmpty) {
          final allSelected =
              _selectedRowKeys.length == widget.dataSource.length;

          headerCell = Padding(
            padding: padding,
            child: Checkbox(
              value: allSelected,
              tristate: true,
              onChanged: (value) => _handleSelectAll(value ?? false),
            ),
          );
        }

        return headerCell;
      }).toList(),
    );
  }

  List<TableColumn<T>> _getEffectiveColumns() {
    final columns = <TableColumn<T>>[];

    // 添加选择列
    if (widget.rowSelection != null) {
      columns.add(TableColumn<T>(
        title: '',
        dataIndex: (_) => '',
        width: 48,
        align: TextAlign.center,
        render: (data, index) => _buildSelectionCell(data, index),
      ));
    }

    columns.addAll(widget.columns);
    return columns;
  }

  List<TableColumn<T>> _getFlatColumns(List<TableColumn<T>> columns) {
    final flatColumns = <TableColumn<T>>[];

    for (final column in columns) {
      if (column.isGroup) {
        flatColumns.addAll(_getFlatColumns(column.children!));
      } else {
        flatColumns.add(column);
      }
    }

    return flatColumns;
  }

  int _getColumnSpan(TableColumn<T> column) {
    if (!column.isGroup) return 1;

    int span = 0;
    for (final child in column.children!) {
      span += _getColumnSpan(child);
    }

    return span;
  }

  Widget _buildSelectionCell(T data, int index) {
    final isSelected = _selectedRowKeys.contains(index);
    final isDisabled =
        widget.rowSelection?.getCheckboxProps?.call(data)?.disabled ?? false;

    if (widget.rowSelection?.type == RowSelectionType.radio) {
      return Radio<int>(
        value: index,
        groupValue: _selectedRowKeys.isEmpty ? null : _selectedRowKeys.first,
        onChanged:
            isDisabled ? null : (value) => _handleRowSelect(data, index, true),
      );
    }

    return Checkbox(
      value: isSelected,
      onChanged: isDisabled
          ? null
          : (value) => _handleRowSelect(data, index, value ?? false),
    );
  }

  void _handleRowSelect(T data, int index, bool selected) {
    setState(() {
      if (widget.rowSelection?.type == RowSelectionType.radio) {
        _selectedRowKeys = selected ? {index} : {};
      } else {
        if (selected) {
          _selectedRowKeys.add(index);
        } else {
          _selectedRowKeys.remove(index);
        }
      }
    });

    final selectedRows =
        _selectedRowKeys.map((i) => widget.dataSource[i]).toList();
    widget.rowSelection?.onChange
        ?.call(_selectedRowKeys.toList(), selectedRows);
    widget.rowSelection?.onSelect?.call(data, selected, selectedRows);
  }

  TableBorder _buildTableBorder() {
    if (widget.bordered) {
      return TableBorder.all(color: const Color(0xFFF0F0F0));
    }
    return const TableBorder(
      horizontalInside: BorderSide(color: Color(0xFFF0F0F0)),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: widget.bordered
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        child: widget.title!,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        child: widget.footer!,
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (widget.dataSource.length / _pageSize).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('共 ${widget.dataSource.length} 条'),
          const SizedBox(width: 16),
          IconButton(
            onPressed:
                _currentPage > 1 ? () => _changePage(_currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text('$_currentPage / $totalPages'),
          IconButton(
            onPressed: _currentPage < totalPages
                ? () => _changePage(_currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
    widget.pagination?.onChange?.call(page, _pageSize);
  }

  Map<int, TableColumnWidth> _buildColumnWidths(List<TableColumn<T>> columns) {
    final widths = <int, TableColumnWidth>{};
    for (var i = 0; i < columns.length; i++) {
      final col = columns[i];
      if (col.width != null) {
        widths[i] = FixedColumnWidth(col.width!);
      }
    }
    return widths;
  }

  void _handleSelectAll(bool selected) {
    setState(() {
      if (selected) {
        _selectedRowKeys =
            Set.from(List.generate(widget.dataSource.length, (i) => i));
      } else {
        _selectedRowKeys.clear();
      }
    });

    final selectedRows =
        _selectedRowKeys.map((i) => widget.dataSource[i]).toList();
    widget.rowSelection?.onChange
        ?.call(_selectedRowKeys.toList(), selectedRows);
  }

  TableRow _buildDataRow(T data, int index, List<TableColumn<T>> columns) {
    final padding = _getPadding();
    final isSelected = _selectedRowKeys.contains(index);
    final isHovered = _hoveredRowIndex == index;

    return TableRow(
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFE6F7FF)
            : isHovered
                ? const Color(0xFFFAFAFA)
                : null,
      ),
      children: columns.map((col) {
        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredRowIndex = index),
          onExit: (_) => setState(() => _hoveredRowIndex = null),
          child: GestureDetector(
            onTap: () => widget.onRow?.call(data, index),
            child: Padding(
              padding: padding,
              child: Align(
                alignment: _getAlignment(col.align),
                child: col.render?.call(data, index) ??
                    Text(
                      col.dataIndex?.call(data)?.toString() ?? '',
                      style: TextStyle(
                        fontSize: _getFontSize(),
                        color: Colors.black87,
                      ),
                    ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  EdgeInsets _getPadding() {
    return switch (widget.size) {
      TableSize.small => const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      TableSize.middle =>
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      TableSize.large =>
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    };
  }

  double _getFontSize() {
    return switch (widget.size) {
      TableSize.small => 12,
      TableSize.middle => 14,
      TableSize.large => 14,
    };
  }

  Alignment _getAlignment(TextAlign align) {
    return switch (align) {
      TextAlign.left => Alignment.centerLeft,
      TextAlign.center => Alignment.center,
      TextAlign.right => Alignment.centerRight,
      _ => Alignment.centerLeft,
    };
  }
}

class TableColumn<T> {
  final String title;
  final dynamic Function(T data)? dataIndex;
  final Widget Function(T data, int index)? render;
  final double? width;
  final TextAlign align;
  final bool sortable;
  final int Function(T a, T b)? sorter;
  final List<TableColumn<T>>? children;
  final int? colSpan;
  final int? rowSpan;

  const TableColumn({
    required this.title,
    this.dataIndex,
    this.render,
    this.width,
    this.align = TextAlign.left,
    this.sortable = false,
    this.sorter,
    this.children,
    this.colSpan,
    this.rowSpan,
  });

  bool get isGroup => children != null && children!.isNotEmpty;
}

class TableRowSelection<T> {
  final RowSelectionType type;
  final List<int>? selectedRowKeys;
  final void Function(List<int> selectedRowKeys, List<T> selectedRows)?
      onChange;
  final void Function(T record, bool selected, List<T> selectedRows)? onSelect;
  final CheckboxProps Function(T record)? getCheckboxProps;

  const TableRowSelection({
    this.type = RowSelectionType.checkbox,
    this.selectedRowKeys,
    this.onChange,
    this.onSelect,
    this.getCheckboxProps,
  });
}

class CheckboxProps {
  final bool disabled;
  final String? name;

  const CheckboxProps({
    this.disabled = false,
    this.name,
  });
}

class TablePagination {
  final int pageSize;
  final int? current;
  final int? total;
  final void Function(int page, int pageSize)? onChange;
  final bool showSizeChanger;
  final List<int> pageSizeOptions;

  const TablePagination({
    this.pageSize = 10,
    this.current,
    this.total,
    this.onChange,
    this.showSizeChanger = false,
    this.pageSizeOptions = const [10, 20, 50, 100],
  });
}

enum TableSize { small, middle, large }

enum RowSelectionType { checkbox, radio }

class _HeaderCell<T> {
  final TableColumn<T> column;
  final int colSpan;
  final int rowSpan;

  const _HeaderCell({
    required this.column,
    required this.colSpan,
    required this.rowSpan,
  });
}
