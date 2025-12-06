import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui/data/tags/src/checkable_tag_group.dart';
import 'package:tolyui/data/tags/src/tag.dart';
import 'package:tolyui/data/tags/src/types.dart';

class TagDemo extends StatefulWidget {
  const TagDemo({Key? key}) : super(key: key);

  @override
  State<TagDemo> createState() => _TagDemoState();
}

class _TagDemoState extends State<TagDemo> {
  String? selectedTag;
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tag Component Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Basic Tags', [
              const Tag(child: Text('Tag 1')),
              const SizedBox(width: 8),
              const Tag(child: Text('Tag 2')),
              const SizedBox(width: 8),
              const Tag(child: Text('Tag 3')),
            ]),
            _buildSection('Closable Tags', [
              Tag(
                closable: true,
                onClose: () => print('Tag closed'),
                child: const Text('Closable'),
              ),
              const SizedBox(width: 8),
              Tag(
                closable: true,
                icon: const Icon(Icons.star, size: 12),
                child: const Text('With Icon'),
              ),
            ]),
            _buildSection('Variants', [
              const Tag(
                variant: TagVariant.filled,
                color: Colors.blue,
                child: Text('Filled'),
              ),
              const SizedBox(width: 8),
              const Tag(
                variant: TagVariant.outlined,
                color: Colors.blue,
                child: Text('Outlined'),
              ),
              const SizedBox(width: 8),
              const Tag(
                variant: TagVariant.solid,
                color: Colors.blue,
                child: Text('Solid'),
              ),
            ]),
            _buildSection('Colors', [
              const Tag(color: Colors.red, child: Text('Red')),
              const SizedBox(width: 8),
              const Tag(color: Colors.orange, child: Text('Orange')),
              const SizedBox(width: 8),
              const Tag(color: Colors.green, child: Text('Green')),
              const SizedBox(width: 8),
              const Tag(color: Colors.blue, child: Text('Blue')),
              const SizedBox(width: 8),
              const Tag(color: Colors.purple, child: Text('Purple')),
            ]),
            _buildSection('Disabled', [
              const Tag(disabled: true, child: Text('Disabled')),
              const SizedBox(width: 8),
              const Tag(
                disabled: true,
                closable: true,
                child: Text('Disabled Closable'),
              ),
            ]),
            _buildSection('Checkable Tag (Single)', [
              CheckableTagGroup<String>(
                options: const [
                  CheckableTagOption(value: 'tag1', label: Text('Tag 1')),
                  CheckableTagOption(value: 'tag2', label: Text('Tag 2')),
                  CheckableTagOption(value: 'tag3', label: Text('Tag 3')),
                ],
                value: selectedTag,
                onChange: (value) => setState(() => selectedTag = value),
              ),
              const SizedBox(height: 8),
              Text('Selected: ${selectedTag ?? "None"}'),
            ]),
            _buildSection('Checkable Tag (Multiple)', [
              CheckableTagGroup<String>(
                multiple: true,
                options: const [
                  CheckableTagOption(value: 'apple', label: Text('Apple')),
                  CheckableTagOption(value: 'banana', label: Text('Banana')),
                  CheckableTagOption(value: 'orange', label: Text('Orange')),
                ],
                values: selectedTags,
                onChangeMultiple: (values) =>
                    setState(() => selectedTags = values),
              ),
              const SizedBox(height: 8),
              Text('Selected: ${selectedTags.join(", ")}'),
            ]),
            _buildSection('With Icons', [
              const Tag(
                icon: Icon(Icons.check_circle, size: 12, color: Colors.green),
                color: Colors.green,
                child: Text('Success'),
              ),
              const SizedBox(width: 8),
              const Tag(
                icon: Icon(Icons.error, size: 12, color: Colors.red),
                color: Colors.red,
                child: Text('Error'),
              ),
              const SizedBox(width: 8),
              const Tag(
                icon: Icon(Icons.warning, size: 12, color: Colors.orange),
                color: Colors.orange,
                child: Text('Warning'),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: children,
          ),
        ],
      ),
    );
  }
}
