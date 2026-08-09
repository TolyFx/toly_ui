/// 表情数据模型和内置表情目录
library;

/// 单个表情
class EmojiItem {
  const EmojiItem({
    required this.code,
    required this.name,
    required this.category,
    this.tags = const [],
  });

  final String code;
  final String name;
  final EmojiCategory category;
  final List<String> tags;
}

/// 表情分类
enum EmojiCategory {
  smileys('😀', 'Smileys & People'),
  gestures('👋', 'Gestures'),
  animals('🐱', 'Animals & Nature'),
  food('🍎', 'Food & Drink'),
  activities('⚽', 'Activities'),
  travel('🚗', 'Travel & Places'),
  objects('💡', 'Objects'),
  symbols('❤️', 'Symbols');

  const EmojiCategory(this.icon, this.label);
  final String icon;
  final String label;
}

/// 按关键词过滤表情
List<EmojiItem> filterEmojis(List<EmojiItem> emojis, String query) {
  if (query.isEmpty) return emojis;
  final lowerQuery = query.toLowerCase();
  return emojis.where((e) {
    if (e.name.toLowerCase().contains(lowerQuery)) return true;
    return e.tags.any((t) => t.toLowerCase().contains(lowerQuery));
  }).toList();
}

/// 按分类分组
Map<EmojiCategory, List<EmojiItem>> groupByCategory(
    List<EmojiItem> emojis) {
  final map = <EmojiCategory, List<EmojiItem>>{};
  for (final emoji in emojis) {
    map.putIfAbsent(emoji.category, () => []).add(emoji);
  }
  return map;
}

/// 内置表情目录
const List<EmojiItem> builtInEmojis = [
  // Smileys
  EmojiItem(code: '😀', name: 'grinning face', category: EmojiCategory.smileys, tags: ['happy', 'smile']),
  EmojiItem(code: '😂', name: 'face with tears of joy', category: EmojiCategory.smileys, tags: ['laugh', 'funny']),
  EmojiItem(code: '😊', name: 'smiling face with smiling eyes', category: EmojiCategory.smileys, tags: ['happy', 'blush']),
  EmojiItem(code: '😍', name: 'smiling face with heart-eyes', category: EmojiCategory.smileys, tags: ['love']),
  EmojiItem(code: '🤔', name: 'thinking face', category: EmojiCategory.smileys, tags: ['think', 'hmm']),
  EmojiItem(code: '😢', name: 'crying face', category: EmojiCategory.smileys, tags: ['sad', 'cry']),
  EmojiItem(code: '😡', name: 'pouting face', category: EmojiCategory.smileys, tags: ['angry', 'mad']),
  EmojiItem(code: '🥳', name: 'partying face', category: EmojiCategory.smileys, tags: ['party', 'celebrate']),
  // Gestures
  EmojiItem(code: '👍', name: 'thumbs up', category: EmojiCategory.gestures, tags: ['like', 'ok', 'good']),
  EmojiItem(code: '👎', name: 'thumbs down', category: EmojiCategory.gestures, tags: ['dislike', 'bad']),
  EmojiItem(code: '👋', name: 'waving hand', category: EmojiCategory.gestures, tags: ['hello', 'bye', 'wave']),
  EmojiItem(code: '👏', name: 'clapping hands', category: EmojiCategory.gestures, tags: ['clap', 'bravo']),
  EmojiItem(code: '🙏', name: 'folded hands', category: EmojiCategory.gestures, tags: ['pray', 'please', 'thanks']),
  // Animals
  EmojiItem(code: '🐱', name: 'cat face', category: EmojiCategory.animals, tags: ['cat', 'pet']),
  EmojiItem(code: '🐶', name: 'dog face', category: EmojiCategory.animals, tags: ['dog', 'pet']),
  // Food
  EmojiItem(code: '🍎', name: 'red apple', category: EmojiCategory.food, tags: ['apple', 'fruit']),
  EmojiItem(code: '☕', name: 'hot beverage', category: EmojiCategory.food, tags: ['coffee', 'tea']),
  // Activities
  EmojiItem(code: '⚽', name: 'soccer ball', category: EmojiCategory.activities, tags: ['football', 'sport']),
  // Symbols
  EmojiItem(code: '❤️', name: 'red heart', category: EmojiCategory.symbols, tags: ['love', 'heart']),
  EmojiItem(code: '✅', name: 'check mark', category: EmojiCategory.symbols, tags: ['done', 'yes', 'check']),
  EmojiItem(code: '🎉', name: 'party popper', category: EmojiCategory.symbols, tags: ['party', 'celebrate', 'tada']),
];
