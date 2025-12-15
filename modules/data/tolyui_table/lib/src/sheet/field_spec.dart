import 'package:flutter/material.dart';
import 'sheet_types.dart';

typedef CellBuilder<T> = Widget Function(CellContext<T> context);

class FieldSpec<T> {
  final String key;
  final FieldHeader header;
  final CellBuilder<T>? builder;
  final FieldConstraint? constraint;
  final FieldCapability? capability;
  final List<FieldSpec<T>>? children;

  const FieldSpec({
    required this.key,
    required this.header,
    this.builder,
    this.constraint,
    this.capability,
    this.children,
  });

  double get effectiveWidth => constraint?.width ?? 120;
  bool get isPinned => capability?.pinnable != null;
  bool get isSortable => capability?.sortable != null;
  bool get isFilterable => capability?.filterable != null;
  bool get isEditable => capability?.editable != null;
  bool get hasChildren => children != null && children!.isNotEmpty;
  
  PinPosition? get pinPosition => capability?.pinnable?.position;
}
