
# Toly UI 项目分析

## 1. 项目概述

`toly_ui` 是一个基于 Flutter 的 UI 组件库项目。它采用多模块化的方式组织代码，便于维护、复用和独立发布。该项目旨在提供一套高质量、可定制的 Flutter UI 组件。

## 2. 模块结构

项目核心的 UI 组件和功能被拆分到 `modules` 目录下的多个独立模块中。这种结构使得每个模块都可以独立开发、测试和发布。以下是当前项目包含的模块：

```mermaid
graph TD
    A[toly_ui] --> B{modules};
    subgraph B
        C[tolyui]
        D[tolyui_color]
        E[tolyui_feedback]
        F[tolyui_image]
        G[tolyui_message]
        H[tolyui_meta]
        I[tolyui_navigation]
        J[tolyui_refresh]
        K[tolyui_rich_input]
        L[tolyui_rx_layout]
        M[tolyui_skeleton]
        N[tolyui_text]
        O[media]
        P[wrapper]
        Q[feedback]
        R[fx_plugin]
        S[publish]
    end
```

## 3. 主要依赖项

项目依赖了多个第三方库来提供核心功能，以下是主要的依赖项及其关系：

```mermaid
graph TD
    subgraph 状态管理
        H[flutter_bloc];
        I[equatable];
    end

    subgraph 路由
        J[go_router];
    end

    subgraph UI 和其他
        K[url_launcher];
        L[flutter_svg];
        M[oktoast];
    end

    A[toly_ui] --> H;
    A --> I;
    A --> J;
    A --> K;
    A --> L;
    A --> M;
```

## 4. 应用结构

`lib` 目录是应用的主要代码目录，其结构如下：

```mermaid
treegraph
  root(lib)
    A[main.dart - 应用入口]
    B[app]
      B1[bloc]
      B2[theme]
    C[view]
      C1[pages]
      C2[widgets]
    D[components - 通用组件]
    E[navigation - 路由管理]
```

## 5. 状态管理

项目使用 `flutter_bloc` 库来实现 BLoC (Business Logic Component) 模式进行状态管理。这种模式将业务逻辑与 UI 分离，提高了代码的可测试性和可维护性。

```mermaid
graph LR
    A[UI Widgets] -- Events --> B(Bloc);
    B -- States --> A;
    B -- interacts with --> C(Data Layer);
```

- **UI (Widgets)**: 用户界面，负责展示数据和发送用户事件。
- **Events**: 从 UI 发送到 Bloc 的事件，用于触发业务逻辑。
- **Bloc**: 处理业务逻辑，接收事件并根据事件更新状态。
- **States**: Bloc 输出的状态，UI 根据状态来更新视图。

## 6. 路由管理

项目使用 `go_router` 库进行声明式路由。路由配置很可能集中在 `lib/navigation` 目录中，方便统一管理和维护。

```mermaid
graph TD
    subgraph 路由配置
        A[GoRouter]
    end
    subgraph 页面
        B[HomePage]
        C[DetailPage]
        D[SettingsPage]
    end
    A --> |/home| B;
    A --> |/details/:id| C;
    A --> |/settings| D;
```

## 7. 构建和发布

项目包含一个位于 `modules/publish.dart` 的发布脚本。该脚本自动化了各个模块的发布流程。

该脚本会遍历 `modules` 目录下的所有模块，并执行 `dart pub publish` 命令来将它们发布到 pub.dev 或私有的 pub 服务器。

```mermaid
sequenceDiagram
    participant User as 开发者
    participant Script as publish.dart
    participant CLI as Dart CLI
    participant Pub as Pub 服务器

    User->>Script: 运行脚本
    Script->>CLI: 为 'tolyui' 模块执行 'dart pub publish'
    CLI->>Pub: 上传 'tolyui' 包
    Pub-->>CLI: 发布成功
    CLI-->>Script: 返回结果
    Script->>CLI: 为 'tolyui_image' 模块执行 'dart pub publish'
    CLI->>Pub: 上传 'tolyui_image' 包
    Pub-->>CLI: 发布成功
    CLI-->>Script: 返回结果
    Script-->>User: 输出所有模块的发布结果
```
