# TolyUI Text

基于正则表达式的 Flutter 文本高亮组件，支持自定义样式和点击事件。

## 功能特性

- 🎨 基于正则表达式的文本高亮
- 👆 支持点击事件回调
- 🎯 自定义高亮样式
- 🔧 支持所有 Text 组件属性
- 🚀 优化的 Rule 和 TextStyle 映射关系

## 使用方法

### 基础用法

```dart
HighlightText(
  "点击 123 或者 hello@email.com",
  rules: {
    Rule(
      RegExp(r'\d+'),
      onTap: (match) => print('点击了数字: ${match.matchedText}'),
    ): TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
    Rule(
      RegExp(r'\S+@\S+\.\S+'),
      onTap: (match) => print('点击了邮箱: ${match.matchedText}'),
    ): TextStyle(
      color: Colors.green,
      decoration: TextDecoration.underline,
    ),
  },
  style: TextStyle(fontSize: 16),
)
```

### 快速搜索高亮

```dart
// 区分大小写
HighlightText.withArg(
  "Flutter 是 Google 开发的 UI 框架",
  arg: "Flutter",
  highlightStyle: TextStyle(
    backgroundColor: Colors.yellow,
    fontWeight: FontWeight.bold,
  ),
)

// 忽略大小写
HighlightText.withArg(
  "Flutter 是 Google 开发的 UI 框架",
  searchText: "flutter",
  highlightStyle: TextStyle(backgroundColor: Colors.yellow),
  caseSensitive: false,
)
```


## API 参数

### HighlightText

| 参数 | 类型 | 描述 |
|------|------|------|
| src | String | 源文本内容 |
| rules | Map<Rule, TextStyle> | Rule 和样式的映射关系 |
| style | TextStyle? | 基础文本样式 |
| ... | ... | 支持所有 Text 组件属性 |

### Rule

| 参数 | 类型 | 描述 |
|------|------|------|
| pattern | Pattern | 匹配模式（支持 RegExp 等） |
| onTap | OnMatchTap? | 点击回调函数 |

### HighlightMatch

| 属性 | 类型 | 描述 |
|------|------|------|
| pattern | String | 匹配的正则表达式 |
| matchedText | String | 匹配到的文本 |
| startIndex | int | 开始位置 |
| endIndex | int | 结束位置 |