# TolyUI Statistic

一个用于显示统计数据的 Flutter 包，支持倒计时/正计时功能。

## 功能特性

- **基础统计**: 显示数值数据，支持自定义格式化

- **计时器组件**: 支持倒计时和正计时，格式灵活
- **自定义样式**: 支持自定义文本样式、前缀和后缀
- **水平居中**: 可选择内容居中对齐
- **精度控制**: 小数精度和数字格式化选项

## 开始使用

在你的 `pubspec.yaml` 文件中添加：

```yaml
dependencies:
  tolyui_statistic: ^1.0.0
```

然后运行：

```bash
flutter pub get
```

## 使用方法

### 基础统计

```dart
import 'package:tolyui_statistic/tolyui_statistic.dart';

Statistic(
  title: '用户总数',
  value: 112893,
)
```

### 带精度的统计

```dart
Statistic(
  title: '账户余额 (CNY)',
  value: 112893,
  precision: 2,
)
```

### 居中显示的自定义样式统计

```dart
Statistic(
  title: '本月签到',
  horizontalCenter: true,
  value: 20,
  valueStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.blue,
  ),
  suffix: Text('/31天'),
)
```

### 带前缀和后缀的统计

```dart
Statistic(
  title: '安装人数',
  value: 6.33,
  prefix: Icon(Icons.arrow_upward, color: Colors.red),
  suffix: Text('%', style: TextStyle(color: Colors.red)),
  valueStyle: TextStyle(color: Colors.red, fontSize: 24),
)
```

### 倒计时器

```dart
StatisticTimer(
  type: TimerType.countdown,
  title: 'Countdown',
  value: DateTime.now().add(Duration(days: 2)).millisecondsSinceEpoch,
  format: 'D 天 H 时 m 分 s 秒',
  onFinish: () {
    print('Countdown finished!');
  },
)
```

### 正计时器

```dart
StatisticTimer(
  type: TimerType.countup,
  title: 'Count Up',
  value: DateTime.now().subtract(Duration(hours: 2)).millisecondsSinceEpoch,
  format: 'HH:mm:ss',
)
```

## 参数说明

### Statistic

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| title | String? | null | 显示在数值上方的标题文本 |
| value | ValueType | 0 | 要显示的数值 |
| prefix | Widget? | null | 显示在数值前面的组件 |
| suffix | Widget? | null | 显示在数值后面的组件 |
| titleStyle | TextStyle? | null | 标题的自定义样式 |
| valueStyle | TextStyle? | null | 数值的自定义样式 |
| horizontalCenter | bool | false | 是否水平居中对齐内容 |

| precision | int? | null | 小数位数 |
| decimalSeparator | String | '.' | 小数分隔符 |
| groupSeparator | String | ',' | 千位分隔符 |

### StatisticTimer

| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| type | TimerType | 必需 | 倒计时或正计时 |
| value | ValueType | 必需 | 目标时间（毫秒时间戳） |
| title | String? | null | 标题文本 |
| format | String | 'HH:mm:ss' | 时间格式字符串 |
| onFinish | VoidCallback? | null | 倒计时结束时的回调 |
| onChange | ValueChanged<int>? | null | 每次时间更新时的回调 |

## 格式模式

对于 StatisticTimer，你可以使用以下格式模式：

- `Y` - 年
- `M` - 月  
- `D` - 天
- `H` - 小时
- `m` - 分钟
- `s` - 秒
- `S` - 毫秒

示例：`'D 天 H 时 m 分 s 秒'` → `"2 天 5 时 30 分 45 秒"`
