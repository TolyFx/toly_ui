import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:tolyui/basic/basic.dart';
import 'package:tolyui/form/checkbox/toly_check_box.dart';

import '../../data/empty/empty_data_view.dart';
import 'transfer_action.dart';

typedef OnSelectChange = void Function(List<String> keys);
typedef OnTransferChange = void Function(List<String> selectKeys, TransferAction action);

class TolyTransfer extends StatefulWidget {
  final List<TransferItem> dataSource;
  final List<String> targetKeys;
  final List<String> selectedKeys;
  final OnSelectChange onSelectChange;
  final OnTransferChange onChange;
  final WidgetBuilder? emptyBuilder;

  const TolyTransfer({
    super.key,
    required this.dataSource,
    required this.targetKeys,
    required this.selectedKeys,
    required this.onSelectChange,
    this.emptyBuilder,
    required this.onChange,
  });

  @override
  State<TolyTransfer> createState() => _TolyTransferState();
}

class _TolyTransferState extends State<TolyTransfer> {
  List<TransferItem> _targets = [];
  List<TransferItem> _sources = [];
  List<String> _selectTargets = [];
  List<String> _selectSources = [];

  bool get _enableToTarget => _selectSources.isNotEmpty;

  bool get _enableToSource => _selectTargets.isNotEmpty;

  @override
  void initState() {
    super.initState();
    updateList();
    updateSelectedList();
  }

  void updateList() {
    _targets = widget.dataSource.where((e) => widget.targetKeys.contains(e.key)).toList();
    _sources = widget.dataSource.where((e) => !widget.targetKeys.contains(e.key)).toList();
  }

  void updateSelectedList() {
    _selectTargets =
        _targets.where((e) => widget.selectedKeys.contains(e.key)).map((e) => e.key).toList();
    _selectSources =
        _sources.where((e) => widget.selectedKeys.contains(e.key)).map((e) => e.key).toList();
  }

  @override
  void didUpdateWidget(covariant TolyTransfer oldWidget) {
    updateList();
    updateSelectedList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TransferPanel(
              data: _sources,
              selects: _selectSources,
              onTap: widget.onSelectChange,
              tailing: Text('Source'),
            )),
        TransferActions(
          onTap: _doTransfer,
          enableToTarget: _enableToTarget,
          enableToSource: _enableToSource,
        ),
        Expanded(
            child: TransferPanel(
              data: _targets,
              selects: _selectTargets,
              onTap: widget.onSelectChange,
              tailing: Text('Target'),
            )),
      ],
    );
  }

  void _doTransfer(TransferAction action) {
    List<String> keys = switch (action) {
      TransferAction.toTarget => _selectSources,
      TransferAction.toSource => _selectTargets,
    };

    widget.onChange(keys, action);
  }
}

class TransferItem {
  final String key;
  final String title;
  final String? description;
  final bool? disabled;

  TransferItem({
    required this.key,
    required this.title,
    this.description,
    this.disabled,
  });
}

class TransferPanel extends StatelessWidget {
  final List<TransferItem> data;
  final List<String> selects;
  final Widget? tailing;
  final OnSelectChange onTap;
  final WidgetBuilder? emptyBuilder;

  const TransferPanel({
    super.key,
    required this.data,
    required this.selects,
    required this.onTap,
    this.tailing,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.5, color: Color(0xffd9d9d9))),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                TolyCheckBox(
                    value: selects.isNotEmpty,
                    indeterminate: selects.length != data.length,
                    onChanged: (bool active) {
                      List<String> keys = [];
                      if (selects.isEmpty || selects.length == data.length) {
                        keys = data.where((e)=>!(e.disabled??false)).map((e) => e.key).toList();
                      } else {
                        keys =
                            data.where((e) => !selects.contains(e.key)&&!(e.disabled??false)).map((e) => e.key).toList();
                      }
                      onTap(keys);
                    }),
                const SizedBox(
                  width: 8,
                ),
                Text('${selects.length}/${data.length} 项'),
                Spacer(),
                if (tailing != null) tailing!,
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: data.isEmpty
                ? _buildEmptyPanel(context)
                : ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) {
                  TransferItem item = data[index];
                  return TransferItemMenu(
                    active: selects.contains(item.key),
                    item: item,
                    onSelectChange: onTap,
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPanel(BuildContext context) {
    if (emptyBuilder != null) {
      return emptyBuilder!(context);
    }
    return const EmptyDataView();
  }
}

class TransferItemMenu extends StatefulWidget {
  final bool active;
  final TransferItem item;
  final OnSelectChange onSelectChange;

  const TransferItemMenu({
    super.key,
    required this.active,
    required this.item,
    required this.onSelectChange,
  });

  @override
  State<TransferItemMenu> createState() => _TransferItemMenuState();
}

class _TransferItemMenuState extends State<TransferItemMenu> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    bool disable = widget.item.disabled ?? false;
    Widget child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disable ? null : () => widget.onSelectChange([widget.item.key]),
      child: Container(
        color: _hover ? Color(0xfff5f5f5) : null,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            IgnorePointer(child: TolyCheckBox(

                value: widget.active, onChanged: (_) => {})),
            const SizedBox(
              width: 6,
            ),
            Text(widget.item.title,style: disable?TextStyle(color: Colors.grey):null)
          ],
        ),
      ),
    );

    return MouseRegion(
      onExit: _onExit,
      onEnter: _onEnter,
      cursor: disable?SystemMouseCursors.forbidden:SystemMouseCursors.click,
      child: child,
    );
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _hover = false;
    });
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _hover = true;
    });
  }
}
