import 'package:flutter/material.dart';
import '../lib/ant_empty.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ant Empty Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const EmptyDemoPage(),
    );
  }
}

class EmptyDemoPage extends StatelessWidget {
  const EmptyDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empty Component Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '基础用法',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntEmpty(),
            SizedBox(height: 32),
            Text(
              '简单图片',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntEmpty(image: EmptyImageType.simple),
            SizedBox(height: 32),
            Text(
              '自定义描述',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntEmpty(
              description: Text('自定义描述文本'),
            ),
            SizedBox(height: 32),
            Text(
              '带操作按钮',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntEmpty(
              description: Text('暂无数据'),
              children: ElevatedButton(
                onPressed: null,
                child: Text('立即创建'),
              ),
            ),
            SizedBox(height: 32),
            Text(
              '自定义图片',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntEmpty(
              image:
                  'https://gw.alipayobjects.com/zos/antfincdn/ZHrcdLPrvN/empty.svg',
              description: Text('自定义图片和描述'),
              styles: EmptyStyles(
                image: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              children: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: null,
                    child: Text('刷新'),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: null,
                    child: Text('创建'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
