---
theme: cyanosis
---

#### 《Flutter TolyUI 框架》系列前言:

**TolyUI** 是 [张风捷特烈]() 打造的 Fluter 全平台应用开发 UI 框架。具备 **全平台**、**组件化**、**源码开放**、**响应式** 四大特点。可以帮助开发者迅速构建具有响应式全平台应用软件：

> 开源地址： <https://github.com/TolyFx/toly_ui>

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/de8c6bed9bfe46b3865accea7d493d4c~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1563\&h=409\&s=62505\&e=png\&b=ffffff)

---

## 一、文本的增强之路

在移动应用开发中，文本从来不只是信息的载体，更是用户与应用交互的桥梁。从最初的静态展示，到如今的智能识别与交互，文本组件的演进反映了整个行业对用户体验的不断追求。TolyUI 的 HighlightText 组件正是这一演进过程中的重要成果，它将文本处理从简单的样式渲染提升到了智能交互的新高度。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e035091f6b8b4fea8ea6c7283272cbc8~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1236&h=852&s=209353&e=png&b=ffffff)

## 二、设计理念：轻量级的文本处理方案

传统的 Flutter 文本处理方式往往让开发者陷入繁琐的细节之中。实现一个简单的搜索高亮功能，需要手动分割字符串、处理大小写逻辑、管理样式状态。比如下面这样的代码：

```dart
// 传统方式：繁琐的手动处理
List<TextSpan> buildHighlightSpans(String text, String keyword) {
  List<TextSpan> spans = [];
  int start = 0;
  while (start < text.length) {
    int index = text.indexOf(keyword, start);
    if (index == -1) {
      spans.add(TextSpan(text: text.substring(start)));
      break;
    }
    if (index > start) {
      spans.add(TextSpan(text: text.substring(start, index)));
    }
    spans.add(TextSpan(
      text: keyword,
      style: TextStyle(backgroundColor: Colors.yellow),
    ));
    start = index + keyword.length;
  }
  return spans;
}
```

HighlightText 的设计从这些实际痛点出发，提供了一套轻量级的解决方案。它不追求复杂的算法，而是通过简洁的 API 让开发者用最少的代码实现需求：

```dart
// HighlightText：简洁优雅
HighlightText.withArg(
  text,
  arg: keyword,
  highlightStyle: TextStyle(backgroundColor: Colors.yellow),
)
```

这种声明式的设计理念，让复杂的文本处理变得简单而优雅。开发者只需要描述"想要什么"，而不必关心"如何实现"。

## 三、在 TolyUI 生态中的定位

HighlightText 并非孤立存在，它是 TolyUI 文本生态的核心组件。在整个框架的架构中，基础层提供了 Text 和 SelectableText 等原生能力，增强层的 HighlightText 则在此之上构建了智能识别与交互能力，表单层的 TolyTextField 和 TolyCheckBox 为其提供输入控制，而复合层的 SearchBar、LegalTerms 等组件则是基于 HighlightText 构建的高级应用。

这种分层设计体现了 TolyUI 的组件化思维。每个组件都有明确的职责边界，同时又能无缝协作。比如在搜索高亮场景中，TolyCheckBox 控制大小写敏感性，ToggleButtons 提供样式选择，Message 组件反馈交互结果，它们共同构成了一个完整的用户体验闭环。这种协同不是简单的功能堆砌，而是经过精心设计的生态整合。

## 四、核心技术：轻量级的冲突解决

HighlightText 最实用的特性是其轻量级的冲突解决机制。在实际应用中，多个正则表达式往往会匹配到重叠的文本区域。比如在识别联系方式时，数字模式会匹配到邮箱地址中的数字部分，导致邮箱无法被完整识别：

```dart
// 问题场景：重叠匹配
HighlightText(
  "联系邮箱：1981462002@qq.com",
  rules: {
    Rule(RegExp(r'\d+')): TextStyle(color: Colors.blue),        // 匹配 "1981462002"
    Rule(RegExp(r'\S+@\S+\.\S+')): TextStyle(color: Colors.green), // 匹配 "1981462002@qq.com"
  },
)
```

HighlightText 采用了长度优先的策略来解决这个问题。当检测到重叠匹配时，组件会自动选择更长的匹配结果，因为更长的匹配通常意味着更具体的模式。比如邮箱地址 "1981462002@qq.com" 会优先于其中的数字 "1981462002"。这个看似简单的策略，背后是对文本识别场景的深刻理解。

实现这个机制的核心代码非常简洁：

```dart
// 按长度排序，优先处理更长的匹配
parts.sort((a, b) {
  int startCompare = a.start.compareTo(b.start);
  if (startCompare != 0) return startCompare;
  return b.text.length.compareTo(a.text.length); // 长度降序
});

// 过滤重叠的匹配
for (final highlight in parts) {
  bool hasOverlap = filteredParts.any((existing) {
    int existingEnd = existing.start + existing.text.length;
    int highlightEnd = highlight.start + highlight.text.length;
    return !(highlight.start >= existingEnd || highlightEnd <= existing.start);
  });
  if (!hasOverlap) filteredParts.add(highlight);
}
```

## 五、三个经典场景的深度解析

第一个场景是交互式搜索高亮。这是最常见的文本处理需求，HighlightText 提供了 withArg 构造函数，让开发者可以快速实现：

```dart
class SearchDemo extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() => _keyword = value),
          decoration: InputDecoration(labelText: '输入搜索关键词'),
        ),
        TolyCheckBox(
          value: _caseSensitive,
          label: Text('区分大小写'),
          onChanged: (value) => setState(() => _caseSensitive = value),
        ),
        HighlightText.withArg(
          _content,
          arg: _keyword,
          caseSensitive: _caseSensitive,
          highlightStyle: _styles[_selectedIndex],
        ),
      ],
    );
  }
}
```

配合 TolyCheckBox 的大小写控制和 ToggleButtons 的样式切换，用户可以根据自己的需求调整搜索行为。这种灵活性的背后，是组件对状态管理的精心设计，确保每次交互都能即时响应。

第二个场景是法律条款识别。在注册、支付等页面，法律条款的展示是合规要求：

```dart
HighlightText(
  "注册即表示您已阅读并同意《用户服务协议》、《隐私政策》和《儿童隐私政策》。",
  rules: {
    Rule(
      RegExp(r'《[^》]+》'),
      onTap: (match) => _showAgreement(match.matchedText),
    ): TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
  },
)
```

通过正则表达式自动识别书名号包围的文本，并为其添加点击交互。这种自动化的处理方式，不仅减少了开发工作量，更重要的是保证了不同页面、不同场景下的一致性。

第三个场景是多模式文本识别。在联系方式、个人简介等场景中，文本中往往包含多种类型的信息：

```dart
HighlightText(
  "大家好，我是张风捷特烈，1994年3月28日出生。\n"
  "联系方式：邮箱1981462002@qq.com，微信zdl1994328，QQ群1046304516",
  rules: {
    Rule(RegExp(r'\d+'), onTap: (m) => _copyNumber(m.matchedText)): 
      TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
    Rule(RegExp(r'\S+@\S+\.\S+'), onTap: (m) => _sendEmail(m.matchedText)): 
      TextStyle(color: Colors.purple, decoration: TextDecoration.underline),
    Rule(RegExp(r'zdl1994328'), onTap: (m) => _openWechat(m.matchedText)): 
      TextStyle(color: Color(0xff01e16e), fontWeight: FontWeight.bold),
  },
)
```

每个规则都有独立的样式和交互行为，组件会自动处理这些规则之间的关系，确保最终呈现的效果既准确又美观。

## 六、轻量级设计的优势

HighlightText 的核心优势在于其轻量级的设计。整个组件的实现非常简洁，核心逻辑只有不到 200 行代码。这种简洁性带来了多方面的好处：首先是性能优异，组件的渲染开销极小，即使在长文本场景下也能保持流畅；其次是易于理解和维护，开发者可以快速掌握组件的工作原理；最后是包体积小，不会给应用增加额外的负担。

组件的核心实现基于 Flutter 原生的 Text.rich 和 TextSpan，没有引入任何第三方依赖：

```dart
class HighlightText extends StatelessWidget {
  final String src;
  final Map<Rule, TextStyle> rules;
  
  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) {
      return Text(src, style: style);
    }
    
    List<_Highlight> parts = _collectMatches();
    parts = _resolveConflicts(parts);
    
    return Text.rich(
      _buildTextSpan(parts),
      style: style,
    );
  }
}
```

扩展性方面，HighlightText 提供了灵活的 Rule 机制。开发者可以根据需要定义任意数量的匹配规则，每个规则都是一个简单的正则表达式和回调函数的组合。这种设计让组件具备了无限的可能性，同时保持了代码的简洁性。

## 七、与主题系统的深度整合

TolyUI 的主题系统为整个框架提供了统一的视觉规范。HighlightText 深度整合了这套系统，可以自动继承主题中定义的颜色、字体、间距等样式属性。这意味着当应用切换主题时，所有使用 HighlightText 的地方都会自动适配新的视觉风格，无需任何额外代码。

这种整合不仅体现在视觉层面，还包括响应式布局和无障碍访问。组件会根据设备类型和屏幕尺寸自动调整文本样式，确保在不同平台上都有良好的显示效果。对于视障用户，组件会自动生成语义化标签，让屏幕阅读器能够正确理解和朗读文本内容。这些细节的打磨，体现了 TolyUI 对用户体验的全面考虑。

## 八、实践中的最佳模式

在实际使用中，合理设计正则表达式的优先级至关重要。建议从具体到通用的顺序定义规则：

```dart
// 推荐：从具体到通用
final rules = {
  Rule(RegExp(r'\S+@\S+\.\S+')): emailStyle,    // 邮箱（具体）
  Rule(RegExp(r'1[3-9]\d{9}')): phoneStyle,      // 手机号（具体）
  Rule(RegExp(r'\d+')): numberStyle,             // 数字（通用）
};
```

交互反馈的统一性也值得重视。建议定义统一的回调处理函数：

```dart
void handleMatch(HighlightMatch match) {
  switch (match.pattern) {
    case r'\S+@\S+\.\S+':
      _sendEmail(match.matchedText);
      break;
    case r'1[3-9]\d{9}':
      _callPhone(match.matchedText);
      break;
    default:
      _copyToClipboard(match.matchedText);
  }
}
```

样式设计方面，建议根据应用场景定义不同的样式主题：

```dart
class HighlightStyles {
  static const registration = TextStyle(color: Colors.blue);
  static const payment = TextStyle(color: Colors.orange);
  static const membership = TextStyle(color: Colors.purple);
}
```

这种模式化的处理方式，让代码更加清晰和易于维护。

## 九、未来的演进方向

HighlightText 的发展不会止步于当前的功能。在规划中的 2.0 版本，将引入更多实用的特性。比如预定义的常用模式库，让开发者可以直接使用邮箱、电话、URL 等常见模式，而不必自己编写正则表达式。再比如可视化的规则编辑器，降低正则表达式的使用门槛。

多语言支持也是重要的发展方向。不同语言的文本特征差异很大，需要针对性的处理策略。未来的版本将内置对主流语言的支持，并提供灵活的扩展机制，让开发者可以轻松添加新语言的支持。

社区生态的建设同样重要。计划建立第三方插件市场，让开发者可以分享和获取各种识别插件。这些举措将让 HighlightText 从一个组件演变为一个平台，汇聚社区的智慧和创造力。

## 十、结语

HighlightText 的价值不仅在于它解决了文本处理的技术难题，更在于它改变了开发者思考文本交互的方式。从繁琐的字符串操作到声明式的规则定义，从孤立的功能实现到生态化的组件协同，这种转变让开发工作变得更加高效和愉悦。

作为 TolyUI 生态的重要组成部分，HighlightText 承载着让文本智能化的使命。它不是终点，而是起点。随着技术的进步和社区的成长，相信会有更多创新的想法在这个平台上实现。让我们一起，探索文本交互的无限可能。

---

**关于 TolyUI**

TolyUI 是张风捷特烈打造的 Flutter 全平台 UI 框架，致力于为开发者提供高质量的组件库和最佳实践。框架秉承开源、创新、品质、共享的价值观，通过模块化架构、自动化测试、持续集成等工程化手段，确保每个组件都经得起实践检验。

目前 TolyUI 已经拥有超过 100 个组件，服务于 50 多家企业用户，覆盖 20 多个国家和地区。无论是个人开发者还是企业团队，都能在这里找到合适的解决方案。我们相信，通过持续的技术创新和社区协作，TolyUI 将为 Flutter 生态带来更多价值。

如果你对 TolyUI 感兴趣，欢迎访问官网 http://toly1994.com/ui 了解更多信息。也可以通过邮箱 1981462002@qq.com 或微信 zdl1994328 与我联系。让我们一起，重新定义 Flutter 应用的可能性。