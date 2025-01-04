import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

typedef MenuItemBuilder<T> = Widget Function(
  BuildContext context,
  TextEditingController textEditingController,
  T data,
  SelectEvent selectAction,
);

typedef ValueFormat = String Function();
typedef SelectEvent = void Function(ValueFormat data);

class TolyAutocomplete<T extends Object> extends StatefulWidget {
  final AutocompleteOptionsBuilder<T> optionsBuilder;
  final AutocompleteFieldViewBuilder fieldViewBuilder;
  final MenuItemBuilder<T>? itemBuilder;

  final ValueChanged<T>? onSelected;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const TolyAutocomplete({
    super.key,
    this.onSelected,
    required this.optionsBuilder,
    required this.fieldViewBuilder,
    this.controller,
    this.itemBuilder,
    this.focusNode,
  });

  @override
  State<TolyAutocomplete<T>> createState() => _TolyAutocompleteState<T>();
}

enum AutocompleteStatus {
  none,
  loading,
  ready,
}

class _TolyAutocompleteState<T extends Object> extends State<TolyAutocomplete<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final PopoverController _popCtrl = PopoverController();
  late MenuItemBuilder<T> _itemBuilder;

  AutocompleteStatus _status = AutocompleteStatus.none;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onChangedField);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);

    _itemBuilder = widget.itemBuilder ?? _defaultMenuItemBuilder;
    super.initState();
  }

  Widget _defaultMenuItemBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    T data,
    SelectEvent selectAction,
  ) {
    return MenuItem(
      onTap: () => selectAction(() => data.toString()),
      text: data.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cts) {
      return TolyPopover(
        placement: Placement.bottomStart,
        maxWidth: cts.maxWidth,
        maxHeight: 300,
        gap: 4,
        controller: _popCtrl,
        overlayDecorationBuilder: _overlayDecorationBuilder,
        overlayBuilder: _buildOverlay,
        child: widget.fieldViewBuilder(
          context,
          _controller,
          _focusNode,
          _onSubmit,
        ),
      );
    });
  }

  void _onSubmit() {}

  Widget _buildOverlay(BuildContext context, PopoverController ctrl) {
    return ValueListenableBuilder<List<T>>(
        valueListenable: _options,
        builder: (context, value, child) {
          if (_controller.text.isEmpty) return const SizedBox();
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            shrinkWrap: true,
            itemCount: value.length,
            itemBuilder: (ctx, index) => _itemBuilder(
              ctx,
              _controller,
              value[index],
              select,
            ),
          );
        });
  }

  void select(ValueFormat action) {
    _status = AutocompleteStatus.none;
    _controller.text = action();
    _popCtrl.close();
  }

  void onSelect(T option) {
    _status = AutocompleteStatus.none;
    _controller.text = option.toString();
    _popCtrl.close();
  }

  final ValueNotifier<List<T>> _options = ValueNotifier([]);

  void _onChangedField() async {
    if (_status != AutocompleteStatus.ready) return;
    final TextEditingValue value = _controller.value;
    final Iterable<T> options = await widget.optionsBuilder(value);
    _options.value = options.toList();

    if (value.text.isEmpty) {
      _popCtrl.close();
      return;
    }

    if (!_popCtrl.isOpen) {
      _popCtrl.open();
    }
  }

  Decoration _overlayDecorationBuilder(PopoverDecoration decoration) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDark ? const Color(0xff303133) : Colors.white;
    Color borderColor = isDark ? const Color(0xff414243) : const Color(0xffe4e7ed);
    return BoxDecoration(
      color: backgroundColor,
      boxShadow: [
        BoxShadow(
          color: borderColor,
          offset: Offset.zero,
          blurRadius: 0,
          spreadRadius: 0.5,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
        )
      ],
      borderRadius: const BorderRadius.all(Radius.circular(6)),
    );
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _status = AutocompleteStatus.ready;
    } else {
      _status = AutocompleteStatus.none;
    }
    _onChangedField();
  }
}

class MenuItem extends StatefulWidget {
  final bool selected;
  final String text;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    required this.text,
    this.selected = false,
    this.onTap,
  });

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> with HoverActionMix {
  Color? get color {
    if (widget.selected) {
      return const Color(0xfff5f5f5);
    }
    if (hovered) {
      return const Color(0xfff5f5f5);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return wrap(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: Text(widget.text),
        ),
      ),
    );
  }
}
