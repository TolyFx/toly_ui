import 'package:flutter/material.dart';
import '../lib/ant_timeline.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ant Timeline Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TimelineDemoPage(),
    );
  }
}

class TimelineDemoPage extends StatelessWidget {
  const TimelineDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Component Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '基础用法',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntTimeline(
              items: [
                TimelineItemType(
                  content: Text('Create a services site 2015-09-01'),
                ),
                TimelineItemType(
                  content: Text('Solve initial network problems 2015-09-01'),
                ),
                TimelineItemType(
                  content: Text('Technical testing 2015-09-01'),
                ),
                TimelineItemType(
                  content: Text('Network problems being solved 2015-09-01'),
                ),
              ],
            ),
            
            SizedBox(height: 32),
            Text(
              '自定义图标和颜色',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntTimeline(
              items: [
                TimelineItemType(
                  content: Text('Create a services site 2015-09-01'),
                  color: Colors.green,
                ),
                TimelineItemType(
                  content: Text('Solve initial network problems 2015-09-01'),
                  color: Colors.blue,
                ),
                TimelineItemType(
                  icon: Icon(Icons.access_time, size: 16),
                  color: Colors.red,
                  content: Text('Technical testing 2015-09-01'),
                ),
                TimelineItemType(
                  content: Text('Network problems being solved 2015-09-01'),
                  loading: true,
                ),
              ],
            ),
            
            SizedBox(height: 32),
            Text(
              '带标题',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntTimeline(
              items: [
                TimelineItemType(
                  title: Text('2015-09-01'),
                  content: Text('Create a services site'),
                ),
                TimelineItemType(
                  title: Text('2015-09-01'),
                  content: Text('Solve initial network problems'),
                ),
                TimelineItemType(
                  title: Text('2015-09-01'),
                  content: Text('Technical testing'),
                  color: Colors.red,
                ),
                TimelineItemType(
                  title: Text('2015-09-01'),
                  content: Text('Network problems being solved'),
                ),
              ],
            ),
            
            SizedBox(height: 32),
            Text(
              '交替模式',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntTimeline(
              mode: TimelineMode.alternate,
              items: [
                TimelineItemType(
                  title: Text('Create a services site'),
                  content: Text('2015-09-01'),
                ),
                TimelineItemType(
                  title: Text('Solve initial network problems'),
                  content: Text('2015-09-01'),
                  color: Colors.green,
                ),
                TimelineItemType(
                  title: Text('Technical testing'),
                  content: Text('2015-09-01'),
                  color: Colors.red,
                ),
                TimelineItemType(
                  title: Text('Network problems being solved'),
                  content: Text('2015-09-01'),
                ),
              ],
            ),
            
            SizedBox(height: 32),
            Text(
              '水平方向',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            AntTimeline(
              orientation: TimelineOrientation.horizontal,
              items: [
                TimelineItemType(
                  title: Text('Step 1'),
                  content: Text('Create'),
                ),
                TimelineItemType(
                  title: Text('Step 2'),
                  content: Text('Solve'),
                  color: Colors.green,
                ),
                TimelineItemType(
                  title: Text('Step 3'),
                  content: Text('Test'),
                  loading: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}