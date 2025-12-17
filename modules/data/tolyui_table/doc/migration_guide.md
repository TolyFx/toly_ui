# TolyTable 到 TolySheet 迁移指南

## 核心差异

| TolyTable | TolySheet |
|-----------|-----------|
| `TableColumn` | `FieldSpec` |
| `dataSource` | `LocalSheetProvider(data: ...)` |
| `dataIndex` | `builder` |
| `render` | `builder` |
| `bordered` | `appearance.showBorder` |
| `title/footer` | 需自行包装 |

## 迁移步骤

### 1. 基础表格迁移

**TolyTable 写法：**
```dart
TolyTable<UserData>(
  columns: [
    TableColumn(
      title: 'Name',
      dataIndex: (data) => data.name,
    ),
  ],
  dataSource: users,
)
```

**TolySheet 写法：**
```dart
TolySheet<UserData>(
  provider: LocalSheetProvider(data: users),
  fields: [
    FieldSpec(
      key: 'name',
      header: FieldHeader(title: 'Name'),
      builder: (ctx) => Text(ctx.data.name),
    ),
  ],
)
```

### 2. 自定义渲染迁移

**TolyTable 写法：**
```dart
TableColumn(
  title: 'Tags',
  render: (data, index) => Wrap(
    children: data.tags.map((tag) => Tag(child: Text(tag))).toList(),
  ),
)
```

**TolySheet 写法：**
```dart
FieldSpec(
  key: 'tags',
  header: FieldHeader(title: 'Tags'),
  builder: (ctx) => Wrap(
    children: ctx.data.tags.map((tag) => Tag(child: Text(tag))).toList(),
  ),
)
```

### 3. 带边框表格迁移

**TolyTable 写法：**
```dart
TolyTable(
  bordered: true,
  title: Text('Header'),
  footer: Text('Footer'),
  columns: [...],
  dataSource: data,
)
```

**TolySheet 写法：**
```dart
Column(
  children: [
    Container(
      padding: EdgeInsets.all(16),
      child: Text('Header'),
    ),
    TolySheet(
      provider: LocalSheetProvider(data: data),
      fields: [...],
      appearance: SheetAppearance(showBorder: true),
    ),
    Container(
      padding: EdgeInsets.all(16),
      child: Text('Footer'),
    ),
  ],
)
```

### 4. 选择功能迁移

**TolyTable 写法：**
```dart
TolyTable(
  rowSelection: TableRowSelection(
    type: RowSelectionType.checkbox,
    onChange: (keys, rows) => print(keys),
  ),
  columns: [...],
  dataSource: data,
)
```

**TolySheet 写法：**
```dart
TolySheet(
  provider: LocalSheetProvider(data: data),
  fields: [...],
  behavior: SheetBehavior(
    pickStrategy: PickStrategy(
      mode: PickMode.multiple,
      onChanged: (indices) => print(indices),
    ),
  ),
)
```

### 5. 合并表头迁移

**TolyTable 写法：**
```dart
TableColumn(
  title: 'Personal Info',
  children: [
    TableColumn(title: 'Age', dataIndex: (d) => d.age),
    TableColumn(title: 'Gender', dataIndex: (d) => d.gender),
  ],
)
```

**TolySheet 写法：**
```dart
FieldSpec(
  key: 'personal',
  header: FieldHeader(title: 'Personal Info'),
  children: [
    FieldSpec(
      key: 'age',
      header: FieldHeader(title: 'Age'),
      builder: (ctx) => Text('${ctx.data.age}'),
    ),
    FieldSpec(
      key: 'gender',
      header: FieldHeader(title: 'Gender'),
      builder: (ctx) => Text(ctx.data.gender),
    ),
  ],
)
```

## 优势

1. **更清晰的架构** - Provider 模式管理数据流
2. **更灵活的配置** - 通过 Behavior/Appearance 分离关注点
3. **更强大的功能** - 支持排序、过滤、固定列等高级特性
4. **更好的性能** - 内置虚拟滚动和优化机制
