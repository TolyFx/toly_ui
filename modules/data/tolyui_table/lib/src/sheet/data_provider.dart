import 'dart:async';
import 'sheet_types.dart';

abstract class SheetDataProvider<T> {
  Stream<SheetDataSnapshot<T>> get dataStream;
  Future<void> refresh();
  Future<void> loadMore();
}

class LocalSheetProvider<T> extends SheetDataProvider<T> {
  final List<T> data;
  late final StreamController<SheetDataSnapshot<T>> _controller;

  LocalSheetProvider({required this.data}) {
    _controller = StreamController<SheetDataSnapshot<T>>.broadcast();
    Future.microtask(() => _emitData());
  }

  void _emitData() {
    if (!_controller.isClosed) {
      _controller.add(SheetDataSnapshot(
        items: data,
        totalCount: data.length,
        state: data.isEmpty ? SheetDataState.empty : SheetDataState.loaded,
      ));
    }
  }

  @override
  Stream<SheetDataSnapshot<T>> get dataStream => _controller.stream;

  @override
  Future<void> refresh() async {
    _emitData();
  }

  @override
  Future<void> loadMore() async {}

  void dispose() {
    _controller.close();
  }
}

class RemoteSheetProvider<T> extends SheetDataProvider<T> {
  final Future<SheetDataSnapshot<T>> Function(SheetDataRequest) fetcher;
  final StreamController<SheetDataSnapshot<T>> _controller;
  int _currentPage = 1;
  final int _pageSize = 20;

  RemoteSheetProvider({required this.fetcher})
      : _controller = StreamController<SheetDataSnapshot<T>>.broadcast() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final snapshot = await fetcher(SheetDataRequest(
        page: _currentPage,
        pageSize: _pageSize,
      ));
      _controller.add(snapshot);
    } catch (e) {
      _controller.add(SheetDataSnapshot<T>(
        items: [],
        totalCount: 0,
        state: SheetDataState.error,
      ));
    }
  }

  @override
  Stream<SheetDataSnapshot<T>> get dataStream => _controller.stream;

  @override
  Future<void> refresh() async {
    _currentPage = 1;
    await _loadData();
  }

  @override
  Future<void> loadMore() async {
    _currentPage++;
    await _loadData();
  }

  void dispose() {
    _controller.close();
  }
}

class SheetDataRequest {
  final int page;
  final int pageSize;
  final Map<String, dynamic>? filters;
  final List<SortInfo>? sorts;

  const SheetDataRequest({
    required this.page,
    required this.pageSize,
    this.filters,
    this.sorts,
  });
}

class SortInfo {
  final String field;
  final bool ascending;

  const SortInfo({required this.field, this.ascending = true});
}
