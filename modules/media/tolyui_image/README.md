# TolyUI Image

一个功能强大的 Flutter 图像处理插件，提供图像加载、手势操作、编辑和缓存等功能。

## 主要功能

### 🖼️ 多种图像源支持
- **网络图像**: 支持 HTTP/HTTPS 图像加载，带有缓存机制
- **本地文件**: 支持本地文件系统图像加载
- **内存图像**: 支持从 Uint8List 加载图像
- **资源图像**: 支持 Flutter 资源包中的图像

### 🎯 手势操作
- **缩放**: 双指缩放，支持最小/最大缩放比例限制
- **平移**: 单指拖拽移动图像
- **双击**: 双击缩放到指定比例
- **鼠标滚轮**: 支持桌面端鼠标滚轮缩放

### ✂️ 图像编辑
- **裁剪**: 支持自定义裁剪区域和宽高比
- **旋转**: 支持任意角度旋转
- **翻转**: 支持水平翻转
- **撤销/重做**: 完整的编辑历史记录

### 🚀 性能优化
- **智能缓存**: 内存和磁盘双重缓存机制
- **图像压缩**: 支持图像压缩和尺寸调整
- **懒加载**: 按需加载图像资源
- **跨平台**: 支持 iOS、Android、Web、Desktop

### 📱 UI 增强
- **加载状态**: 自定义加载、失败状态显示
- **边框装饰**: 支持圆角、边框等装饰效果
- **滑动页面**: 支持图像查看器滑动效果
- **页面视图**: 集成 PageView 手势处理

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  tolyui_image: ^0.0.1+2
```

## 基础用法

### 1. 显示网络图像

```dart
import 'package:tolyui_image/tolyui_image.dart';

TolyImage.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  loadStateChanged: (state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return const CircularProgressIndicator();
      case LoadState.completed:
        return state.completedWidget;
      case LoadState.failed:
        return const Icon(Icons.error);
    }
  },
)
```

### 2. 手势操作图像

```dart
TolyImage.network(
  'https://example.com/image.jpg',
  mode: ExtendedImageMode.gesture,
  initGestureConfigHandler: (state) {
    return GestureConfig(
      minScale: 0.5,
      maxScale: 3.0,
      animationMinScale: 0.7,
      animationMaxScale: 3.5,
      speed: 1.0,
      inertialSpeed: 100.0,
      initialScale: 1.0,
      inPageView: false,
      initialAlignment: InitialAlignment.center,
    );
  },
)
```

### 3. 图像编辑功能

```dart
class ImageEditorPage extends StatefulWidget {
  @override
  _ImageEditorPageState createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  final GlobalKey<ExtendedImageEditorState> editorKey = 
      GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图像编辑'),
        actions: [
          IconButton(
            icon: Icon(Icons.crop_rotate),
            onPressed: () {
              editorKey.currentState?.rotate(degree: 90);
            },
          ),
          IconButton(
            icon: Icon(Icons.flip),
            onPressed: () {
              editorKey.currentState?.flip();
            },
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              editorKey.currentState?.undo();
            },
          ),
        ],
      ),
      body: TolyImage.network(
        'https://example.com/image.jpg',
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: editorKey,
        initEditorConfigHandler: (state) {
          return EditorConfig(
            maxScale: 8.0,
            cropRectPadding: const EdgeInsets.all(20.0),
            hitTestSize: 20.0,
            cropAspectRatio: null, // 自由裁剪
          );
        },
      ),
    );
  }
}
```

### 4. 本地文件和资源图像

```dart
// 本地文件
TolyImage.file(
  File('/path/to/image.jpg'),
  width: 200,
  height: 200,
)

// 资源图像
TolyImage.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)

// 内存图像
TolyImage.memory(
  imageBytes,
  width: 150,
  height: 150,
)
```

### 5. 自定义缓存配置

```dart
TolyImage.network(
  'https://example.com/image.jpg',
  cache: true,
  cacheMaxAge: Duration(days: 7),
  cacheKey: 'custom_cache_key',
  retries: 3,
  timeLimit: Duration(seconds: 10),
  headers: {
    'Authorization': 'Bearer token',
  },
)
```

## 高级功能

### 图像滑动页面

```dart
ExtendedImageSlidePage(
  child: TolyImage.network(
    imageUrl,
    mode: ExtendedImageMode.gesture,
    enableSlideOutPage: true,
  ),
  slideAxis: SlideAxis.both,
  slideType: SlideType.onlyImage,
)
```

### 自定义加载状态

```dart
TolyImage.globalStateWidgetBuilder = (context, state) {
  switch (state.extendedImageLoadState) {
    case LoadState.loading:
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    case LoadState.completed:
      return state.completedWidget;
    case LoadState.failed:
      return GestureDetector(
        onTap: () => state.reLoadImage(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red),
              Text('加载失败，点击重试'),
            ],
          ),
        ),
      );
  }
};
```

## 配置选项

### GestureConfig 手势配置

```dart
GestureConfig(
  minScale: 0.8,              // 最小缩放比例
  maxScale: 5.0,              // 最大缩放比例
  animationMinScale: 0.7,     // 动画最小缩放比例
  animationMaxScale: 5.5,     // 动画最大缩放比例
  speed: 1.0,                 // 手势速度
  inertialSpeed: 100.0,       // 惯性速度
  initialScale: 1.0,          // 初始缩放比例
  inPageView: false,          // 是否在 PageView 中
  initialAlignment: InitialAlignment.center, // 初始对齐方式
  cacheGesture: false,        // 是否缓存手势状态
)
```

### EditorConfig 编辑配置

```dart
EditorConfig(
  maxScale: 8.0,                           // 最大缩放比例
  cropRectPadding: EdgeInsets.all(20.0),   // 裁剪区域内边距
  hitTestSize: 20.0,                       // 触摸测试大小
  cropAspectRatio: 16.0 / 9.0,            // 裁剪宽高比
  initCropRectType: InitCropRectType.imageRect, // 初始裁剪区域类型
)
```

## 注意事项

1. **Web 平台限制**: 在 Web 平台上不支持 `TolyImage.file()` 方法
2. **内存管理**: 大图像建议设置 `clearMemoryCacheWhenDispose: true`
3. **网络权限**: Android 需要在 `AndroidManifest.xml` 中添加网络权限
4. **文件权限**: 读取本地文件可能需要相应的存储权限

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。