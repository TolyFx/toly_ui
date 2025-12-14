import 'package:flutter/material.dart';

class TolyTable<T> extends StatelessWidget {
  final List<TableColumn<T>> columns;
  final List<T> dataSource;
  final bool bordered;
  final TableSize size;
  final Widget? title;
  final Widget? footer;

  const TolyTable({
    super.key,
    required this.columns,
    required this.dataSource,
    this.bordered = false,
    this.size = TableSize.middle,
    this.title,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: bordered
          ? BoxDecoration(
              border: Border.all(color: const Color(0xFFF0F0F0)),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) _buildTitle(),
          Table(
            border: bordered
                ? TableBorder.all(color: const Color(0xFFF0F0F0))
                : TableBorder(
                    horizontalInside: BorderSide(color: const Color(0xFFF0F0F0)),
                  ),
            columnWidths: _buildColumnWidths(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildHeaderRow(),
              ...dataSource.asMap().entries.map((e) => _buildDataRow(e.value, e.key)),
            ],
          ),
          if (footer != null) _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: bordered ? null : Border(bottom: BorderSide(color: const Color(0xFFF0F0F0))),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        child: title!,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: bordered ? null : Border(top: BorderSide(color: const Color(0xFFF0F0F0))),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        child: footer!,
      ),
    );
  }

  Map<int, TableColumnWidth> _buildColumnWidths() {
    final widths = <int, TableColumnWidth>{};
    for (var i = 0; i < columns.length; i++) {
      final col = columns[i];
      if (col.width != null) {
        widths[i] = FixedColumnWidth(col.width!);
      }
    }
    return widths;
  }

  TableRow _buildHeaderRow() {
    final padding = _getPadding();
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
      children: columns.map((col) {
        return Padding(
          padding: padding,
          child: Align(
            alignment: _getAlignment(col.align),
            child: Text(
              col.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildDataRow(T data, int index) {
    final padding = _getPadding();
    return TableRow(
      children: columns.map((col) {
        return Padding(
          padding: padding,
          child: Align(
            alignment: _getAlignment(col.align),
            child: col.render?.call(data, index) ??
                Text(
                  col.dataIndex(data).toString(),
                  style: const TextStyle(fontSize: 14),
                ),
          ),
        );
      }).toList(),
    );
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      TableSize.small => const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      TableSize.middle => const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      TableSize.large => const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
  final dynamic Function(T data) dataIndex;
  final Widget Function(T data, int index)? render;
  final double? width;
  final TextAlign align;

  const TableColumn({
    required this.title,
    required this.dataIndex,
    this.render,
    this.width,
    this.align = TextAlign.left,
  });
}

enum TableSize { small, middle, large }
