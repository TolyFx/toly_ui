# TolyUI 脚本工具

本目录包含 TolyUI 项目的辅助脚本工具。

## create_module.dart

快速创建 TolyUI 模块的脚本。

### 使用方式

```bash
dart test/script/create_module.dart <module_name> <category>
```

### 参数说明

- `module_name`: 模块名称，使用小写加下划线格式（如 `toly_button`、`toly_avatar`）
- `category`: 模块分类，可选值：
  - `data` - 数据展示类组件
  - `form` - 表单类组件
  - `feedback` - 反馈类组件
  - `media` - 媒体类组件
  - `navigation` - 导航类组件

### 示例

创建一个表单类的按钮组件：
```bash
dart test/script/create_module.dart toly_button form
```

创建一个数据展示类的头像组件：
```bash
dart test/script/create_module.dart toly_avatar data
```

### 脚本功能

脚本会自动完成以下操作：

1. ✅ 使用 `flutter create --template=package` 创建 Flutter package
2. ✅ 创建 `lib/src/` 目录用于存放源代码
3. ✅ 更新 `pubspec.yaml`，设置正确的描述、版本和仓库信息
4. ✅ 创建 MIT `LICENSE` 文件
5. ✅ 创建 `README.md` 模板，包含基础结构
6. ✅ 创建 `CHANGELOG.md` 模板
7. ✅ 清理默认生成的文件

### 创建后的目录结构

```
modules/<category>/<module_name>/
├── lib/
│   ├── src/              # 源代码目录
│   └── <module_name>.dart  # 库导出文件
├── test/
│   └── <module_name>_test.dart
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── CHANGELOG.md
├── LICENSE
├── pubspec.yaml
└── README.md
```

### 下一步操作

模块创建完成后，你需要：

1. 在 `lib/src/` 目录下创建组件文件
2. 在 `lib/<module_name>.dart` 中导出组件
3. 完善 `README.md` 和 `CHANGELOG.md`
4. 在主项目 `pubspec.yaml` 中添加依赖：
   ```yaml
   dependencies:
     <module_name>:
       path: modules/<category>/<module_name>
   ```

### 注意事项

- 模块名称建议使用 `toly_` 前缀，保持命名一致性
- 确保在项目根目录下运行脚本
- 如果模块已存在，脚本会提示错误并退出
- 创建后记得运行 `flutter pub get` 获取依赖
