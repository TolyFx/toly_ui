import 'package:flutter/material.dart';

class SheetController<T> extends ChangeNotifier {
  Set<int> _pickedIndices = {};
  Map<int, bool> _expandedRows = {};
  String? _sortField;
  bool _sortAscending = true;

  Set<int> get pickedIndices => _pickedIndices;
  Map<int, bool> get expandedRows => _expandedRows;
  String? get sortField => _sortField;
  bool get sortAscending => _sortAscending;

  void pickRow(int index) {
    _pickedIndices.add(index);
    notifyListeners();
  }

  void unpickRow(int index) {
    _pickedIndices.remove(index);
    notifyListeners();
  }

  void pickRows(List<int> indices) {
    _pickedIndices.addAll(indices);
    notifyListeners();
  }

  void clearPicks() {
    _pickedIndices.clear();
    notifyListeners();
  }

  void togglePick(int index) {
    if (_pickedIndices.contains(index)) {
      unpickRow(index);
    } else {
      pickRow(index);
    }
  }

  bool isPicked(int index) => _pickedIndices.contains(index);

  void expandRow(int index) {
    _expandedRows[index] = true;
    notifyListeners();
  }

  void collapseRow(int index) {
    _expandedRows[index] = false;
    notifyListeners();
  }

  void toggleExpand(int index) {
    _expandedRows[index] = !(_expandedRows[index] ?? false);
    notifyListeners();
  }

  bool isExpanded(int index) => _expandedRows[index] ?? false;

  void sortBy(String field, {bool ascending = true}) {
    _sortField = field;
    _sortAscending = ascending;
    notifyListeners();
  }

  void clearSort() {
    _sortField = null;
    notifyListeners();
  }
}
