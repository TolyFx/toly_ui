# TolyUI Text

基于正则表达式的 Flutter 文本高亮组件，支持自定义样式和点击事件。

## 功能特性

- 🎨 基于正则表达式的文本高亮
- 👆 支持点击事件回调
- 🎯 自定义高亮样式
- 🔧 支持所有 Text 组件属性
- 🚀 优化的 Rule 和 TextStyle 映射关系
- 🛡️ 智能冲突解决策略，避免重叠匹配问题

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

## 冲突解决策略

当多个正则表达式匹配到重叠的文本区域时，组件采用以下策略解决冲突：

### 优先级规则

1. **长度优先**：更长的匹配优先于更短的匹配
2. **位置优先**：相同长度时，起始位置靠前的优先
3. **无重叠**：确保最终结果中没有重叠的高亮区域

### 示例场景

```dart
HighlightText(
  "联系邮箱：1981462002@qq.com",
  rules: {
    Rule(RegExp(r'\d+')): TextStyle(color: Colors.blue),        // 匹配: "1981462002"
    Rule(RegExp(r'\S+@\S+\.\S+')): TextStyle(color: Colors.green), // 匹配: "1981462002@qq.com"
  },
)
```

**结果**：邮箱模式 `1981462002@qq.com` 会被优先匹配（因为更长），数字模式 `1981462002` 被忽略，避免了重叠冲突。

### 算法流程

1. **收集所有匹配**：遍历所有 Rule，收集匹配结果
2. **智能排序**：按起始位置排序，相同位置时按长度降序
3. **冲突检测**：检查每个匹配是否与已选择的匹配重叠
4. **过滤重叠**：保留第一个匹配，丢弃后续重叠的匹配
5. **构建结果**：基于过滤后的匹配构建最终的文本样式

这种策略确保了更具体的模式（如邮箱、URL）优先于更通用的模式（如数字、单词），提供更准确的文本识别效果。