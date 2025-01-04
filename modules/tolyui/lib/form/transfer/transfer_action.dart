import 'package:flutter/material.dart';

import '../../basic/basic.dart';

enum TransferAction {
  toTarget,
  toSource,
}

class TransferActions extends StatelessWidget {
  final ValueChanged<TransferAction> onTap;
  final bool enableToTarget;
  final bool enableToSource;

  const TransferActions({
    super.key,
    required this.onTap,
    required this.enableToTarget,
    required this.enableToSource,
  });

  @override
  Widget build(BuildContext context) {
    ActionStyle enableStyle = ActionStyle(
        selectColor: Colors.blue,
        borderRadius: BorderRadius.circular(4),
        padding: EdgeInsets.all(1));

    ActionStyle disableStyle = ActionStyle(
        selectColor: Color(0xfff5f5f5),
        disableColor: Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(4),
        padding: EdgeInsets.all(1));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TolyAction(
              selected: true,
              style: enableToTarget ? enableStyle : disableStyle,
              child: Icon(
                Icons.navigate_next,
                color:enableToTarget? Colors.white:Color(0xffb8b8b8),
                size: 20,
              ),
              onTap: !enableToTarget ? null : () => onTap(TransferAction.toTarget)),
          const SizedBox(height: 8),
          TolyAction(
              selected: true,
              style: enableToSource ? enableStyle : disableStyle,
              child: Icon(
                Icons.navigate_before,
                color: enableToSource? Colors.white: Color(0xffb8b8b8),
                size: 20,
              ),
              onTap: !enableToSource ? null : () => onTap(TransferAction.toSource)),
        ],
      ),
    );
  }
}
