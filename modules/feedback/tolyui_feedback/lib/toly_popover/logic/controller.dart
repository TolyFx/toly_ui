part of '../toly_popover.dart';

class PopoverController {
  _TolyPopoverState? _state;

  bool get isOpen {
    assert(_state != null);
    return _state!._isOpen;
  }

  void close() {
    assert(_state != null);
    _state!._close();
  }

  void open({Offset? position}) {
    assert(_state != null);
    _state!._open(position: position);
  }

  void _attach(_TolyPopoverState state) {
    _state = state;
  }

  void _detach(_TolyPopoverState state) {
    if (_state == state) {
      _state = null;
    }
  }
}
