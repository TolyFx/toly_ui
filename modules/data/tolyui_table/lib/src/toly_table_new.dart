import 'package:flutter/material.dart';

class TolyTableNew<T> extends StatefulWidget {
  final List<TableColumnNew<T>> columns;
  final List<T> dataSource;
  final bool bordered;
  final TableSizeNew size;
  final Widget? title;
  final Widget? footer;
  final TableRowSelectionNew<T>? rowSelection;
  final void Function(T record, int index)? onRow;
  final TablePaginationNew? pagination;
  final bool showHeader;
  final ScrollController? scrollController;
  final double? height;

  const TolyTableNew({
    super.key,
    required this.columns,
    required this.dataSource,
    this.bordered = false,
    this.size = TableSizeNew.middle,
    this.title,
    this.footer,
    this.rowSelection,
    this.onRow,
    this.pagination,
    this.showHeader = true,
    this.scrollController,
    this.height,
  });

  @override
  State<TolyTableNew<T>> createState() => _TolyTableNewState<T>();
}

class _TolyTableNewState<T> extends State<TolyTableNew<T>> {
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
    
    return Container(
      decoration: widget.bordered
          ? BoxDecoration(
              border: Border.all(color: const Color(0xFFF0F0F0)),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: widget.height != null 
          ? SizedBox(height: widget.height, child: SingleChildScrollView(child: table))
          : table,
    );
  }

  Widget _buildTable() {
    final effectiveColumns = _getEffectiveColumns();
    final flatColumns = _getFlatColumns(effectiveColumns);
    final hasGroupedHeaders = effectiveColumns.any((col) => col.children != null);
    
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showHeader && hasGroupedHeaders) 
                _buildGroupedHeaders(effectiveColumns, flatColumns),
              if (widget.showHeader && !hasGroupedHeaders)
                _buildSimpleHeader(flatColumns),
              ..._buildAllDataRows(flatColumns),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleHeader(List<TableColumnNew<T>> columns) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0)),
        ),
      ),
      child: Row(
        children: columns.map((column) => _buildHeaderCell(column)).toList(),
      ),
    );
  }

  Widget _buildHeaderCell(TableColumnNew<T> column) {
    Widget content;
    
    if (column.title.isEmpty && widget.rowSelection != null && 
        widget.rowSelection?.type != RowSelectionTypeNew.radio) {
      final allSelected = _selectedRowKeys.length == widget.dataSource.length;
      content = Checkbox(
        value: allSelected,
        tristate: true,
        onChanged: (value) => _handleSelectAll(value ?? false),
      );
    } else {
      content = Text(
        column.title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      );
    }
    
    return Expanded(
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Color(0xFFF0F0F0)),
          ),
        ),
        child: content,
      ),
    );
  }

  List<Widget> _buildAllDataRows(List<TableColumnNew<T>> columns) {
    return _paginatedData.asMap().entries.map((e) => 
      _buildCustomDataRow(e.value, e.key, columns)
    ).toList();
  }

  Widget _buildCustomDataRow(T data, int index, List<TableColumnNew<T>> columns) {
    final isSelected = _selectedRowKeys.contains(index);
    final rowHeight = _getRowHeight();
    
    return GestureDetector(
      onTap: () => widget.onRow?.call(data, index),
      child: Container(
        height: rowHeight,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F7FF) : null,
          border: const Border(
            bottom: BorderSide(color: Color(0xFFF0F0F0)),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: columns.map((column) => _buildDataCell(data, index, column)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(T data, int index, TableColumnNew<T> column) {
    Widget content;
    
    if (column.render != null) {
      content = column.render!(data, index);
    } else if (column.dataIndex != null) {
      content = Text(
        column.dataIndex!(data)?.toString() ?? '',
        style: TextStyle(fontSize: _getFontSize()),
      );
    } else if (column.title.isEmpty && widget.rowSelection != null) {
      content = _buildSelectionCell(data, index);
    } else {
      content = const Text('');
    }
    
    return Expanded(
      child: Container(
        height: _getRowHeight(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Color(0xFFF0F0F0)),
          ),
        ),
        child: content,
      ),
    );
  }

  Widget _buildGroupedHeaders(List<TableColumnNew<T>> columns, List<TableColumnNew<T>> flatColumns) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0)),
        ),
      ),
      child: Column(
        children: [
          _buildGroupHeaderRow(columns),
          _buildSubHeaderRow(flatColumns),
        ],
      ),
    );
  }

  Widget _buildGroupHeaderRow(List<TableColumnNew<T>> columns) {
    final children = <Widget>[];
    
    for (final column in columns) {
      if (column.children != null) {
        final colSpan = _getColumnSpan(column);
        children.add(
          Expanded(
            flex: colSpan,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: Color(0xFFF0F0F0)),
                ),
              ),
              child: Text(
                column.title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        );
      } else {
        children.add(
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: Color(0xFFF0F0F0)),
                ),
              ),
              child: Text(
                column.title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        );
      }
    }
    
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0)),
        ),
      ),
      child: Row(children: children),
    );
  }

  Widget _buildSubHeaderRow(List<TableColumnNew<T>> flatColumns) {
    final children = <Widget>[];
    
    for (int i = 0; i < flatColumns.length; i++) {
      final column = flatColumns[i];
      Widget cell = Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Color(0xFFF0F0F0)),
          ),
        ),
        child: Text(
          column.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      );
      
      // 添加全选功能
      if (i == 0 && widget.rowSelection != null && 
          widget.rowSelection?.type != RowSelectionTypeNew.radio &&
          column.title.isEmpty) {
        final allSelected = _selectedRowKeys.length == widget.dataSource.length;
        
        cell = Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: Color(0xFFF0F0F0)),
            ),
          ),
          child: Checkbox(
            value: allSelected,
            tristate: true,
            onChanged: (value) => _handleSelectAll(value ?? false),
          ),
        );
      }
      
      children.add(Expanded(child: cell));
    }
    
    return Row(children: children);
  }



  Widget _buildSelectionCell(T data, int index) {
    final isSelected = _selectedRowKeys.contains(index);
    final isDisabled = widget.rowSelection?.getCheckboxProps?.call(data)?.disabled ?? false;
    
    if (widget.rowSelection?.type == RowSelectionTypeNew.radio) {
      return Radio<int>(
        value: index,
        groupValue: _selectedRowKeys.isEmpty ? null : _selectedRowKeys.first,
        onChanged: isDisabled ? null : (value) => _handleRowSelect(data, index, true),
      );
    }
    
    return Checkbox(
      value: isSelected,
      onChanged: isDisabled ? null : (value) => _handleRowSelect(data, index, value ?? false),
    );
  }

  List<TableColumnNew<T>> _getEffectiveColumns() {
    final columns = <TableColumnNew<T>>[];
    
    // 添加选择列
    if (widget.rowSelection != null) {
      columns.add(TableColumnNew<T>(
        title: '',
        dataIndex: null,
        width: 48,
      ));
    }
    
    columns.addAll(widget.columns);
    return columns;
  }

  List<TableColumnNew<T>> _getFlatColumns(List<TableColumnNew<T>> columns) {
    final flatColumns = <TableColumnNew<T>>[];
    
    for (final column in columns) {
      if (column.children != null) {
        flatColumns.addAll(_getFlatColumns(column.children!));
      } else {
        flatColumns.add(column);
      }
    }
    
    return flatColumns;
  }

  int _getColumnSpan(TableColumnNew<T> column) {
    if (column.children == null) return 1;
    
    int span = 0;
    for (final child in column.children!) {
      span += _getColumnSpan(child);
    }
    
    return span;
  }

  void _handleRowSelect(T data, int index, bool selected) {
    setState(() {
      if (widget.rowSelection?.type == RowSelectionTypeNew.radio) {
        _selectedRowKeys = selected ? {index} : {};
      } else {
        if (selected) {
          _selectedRowKeys.add(index);
        } else {
          _selectedRowKeys.remove(index);
        }
      }
    });
    
    final selectedRows = _selectedRowKeys.map((i) => widget.dataSource[i]).toList();
    widget.rowSelection?.onChange?.call(_selectedRowKeys.toList(), selectedRows);
    widget.rowSelection?.onSelect?.call(data, selected, selectedRows);
  }

  void _handleSelectAll(bool selected) {
    setState(() {
      if (selected) {
        _selectedRowKeys = Set.from(List.generate(widget.dataSource.length, (i) => i));
      } else {
        _selectedRowKeys.clear();
      }
    });
    
    final selectedRows = _selectedRowKeys.map((i) => widget.dataSource[i]).toList();
    widget.rowSelection?.onChange?.call(_selectedRowKeys.toList(), selectedRows);
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
        border: widget.bordered ? null : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
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
            onPressed: _currentPage > 1 ? () => _changePage(_currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text('$_currentPage / $totalPages'),
          IconButton(
            onPressed: _currentPage < totalPages ? () => _changePage(_currentPage + 1) : null,
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

  double _getRowHeight() {
    return switch (widget.size) {
      TableSizeNew.small => 40,
      TableSizeNew.middle => 48,
      TableSizeNew.large => 56,
    };
  }

  double _getFontSize() {
    return switch (widget.size) {
      TableSizeNew.small => 12,
      TableSizeNew.middle => 14,
      TableSizeNew.large => 14,
    };
  }
}

class TableColumnNew<T> {
  final String title;
  final dynamic Function(T data)? dataIndex;
  final Widget Function(T data, int index)? render;
  final double? width;
  final TextAlign align;
  final List<TableColumnNew<T>>? children;

  const TableColumnNew({
    required this.title,
    this.dataIndex,
    this.render,
    this.width,
    this.align = TextAlign.left,
    this.children,
  });
}

class TableRowSelectionNew<T> {
  final RowSelectionTypeNew type;
  final List<int>? selectedRowKeys;
  final void Function(List<int> selectedRowKeys, List<T> selectedRows)? onChange;
  final void Function(T record, bool selected, List<T> selectedRows)? onSelect;
  final CheckboxPropsNew Function(T record)? getCheckboxProps;

  const TableRowSelectionNew({
    this.type = RowSelectionTypeNew.checkbox,
    this.selectedRowKeys,
    this.onChange,
    this.onSelect,
    this.getCheckboxProps,
  });
}

class CheckboxPropsNew {
  final bool disabled;
  final String? name;

  const CheckboxPropsNew({
    this.disabled = false,
    this.name,
  });
}

class TablePaginationNew {
  final int pageSize;
  final int? current;
  final int? total;
  final void Function(int page, int pageSize)? onChange;

  const TablePaginationNew({
    this.pageSize = 10,
    this.current,
    this.total,
    this.onChange,
  });
}

enum TableSizeNew { small, middle, large }
enum RowSelectionTypeNew { checkbox, radio }