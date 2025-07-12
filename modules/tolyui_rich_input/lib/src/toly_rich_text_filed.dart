import 'package:flutter/material.dart' hide Element;
import 'package:characters/characters.dart';

enum RichElementType { text, image, emoji, file }

class RichElement {
  final RichElementType type;
  final String content;
  final Map<String, dynamic>? data;

  RichElement({required this.type, required this.content, this.data});
  
  @override
  String toString() => 'RichElement(type: $type, content: $content)';
}

class ImRichInput extends StatefulWidget {
  const ImRichInput({super.key});

  @override
  State<ImRichInput> createState() => ImRichInputState();
}

class ImRichInputState extends State<ImRichInput> {
  final RichTextEditingController controller = RichTextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Wrap(
            spacing: 8,
            children: [
              _buildActionButton(
                  '📷', () => controller.insertImage('image_url')),
              _buildActionButton('😀', () => controller.insertEmoji('😀')),
              _buildActionButton(
                  '📁', () => controller.insertFile('file_name', 'file_path')),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            maxLines: null,
            minLines: null,
            expands: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            controller: controller,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text),
      ),
    );
  }
}

class RichTextEditingController extends TextEditingController {
  static const String _placeholder = '\uFFFC'; // Object replacement character
  final List<RichElement> _elements = [];
  String _lastText = '';
  
  @override
  set value(TextEditingValue newValue) {
    _syncElements(newValue.text);
    super.value = newValue;
    _lastText = newValue.text;
  }
  
  void _syncElements(String newText) {
    final placeholders = <int>[];
    for (int i = 0; i < newText.length; i++) {
      if (newText[i] == _placeholder) {
        placeholders.add(i);
      }
    }
    
    // 保持元素数量与占位符数量一致
    if (placeholders.length < _elements.length) {
      _elements.removeRange(placeholders.length, _elements.length);
    }
  }

  void insertImage(String imageUrl) {
    final element = RichElement(
      type: RichElementType.image,
      content: _placeholder,
      data: {'url': imageUrl},
    );
    _elements.add(element);
    _insertText(_placeholder);
  }

  void insertEmoji(String emoji) {
    _insertText(emoji);
  }

  void insertFile(String fileName, String filePath) {
    final element = RichElement(
      type: RichElementType.file,
      content: _placeholder,
      data: {'name': fileName, 'path': filePath},
    );
    _elements.add(element);
    _insertText(_placeholder);
  }

  void _insertText(String textToInsert) {
    final currentText = text;
    final selection = this.selection;
    
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      textToInsert,
    );
    
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + textToInsert.length,
      ),
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    bool? withComposing,
  }) {
    final children = <InlineSpan>[];
    final textChars = text.characters.toList();
    String currentText = '';
    int elementIndex = 0;
    
    void addTextSpan() {
      if (currentText.isNotEmpty) {
        children.add(TextSpan(text: currentText, style: style));
        currentText = '';
      }
    }
    
    for (final char in textChars) {
      if (char == _placeholder && elementIndex < _elements.length) {
        addTextSpan();
        final element = _elements[elementIndex++];
        
        if (element.type == RichElementType.image) {
          children.add(WidgetSpan(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.image, size: 16),
            ),
          ));
        } else if (element.type == RichElementType.file) {
          children.add(WidgetSpan(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_file, size: 12),
                  SizedBox(width: 2),
                  Text(
                    element.data?['name'] ?? 'File',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ));
        }
      } else {
        currentText += char;
      }
    }
    
    addTextSpan();
    return TextSpan(children: children, style: style);
  }

  List<RichElement> get elements => List.unmodifiable(_elements);
}
