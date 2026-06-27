# tolyui_anchor

A powerful anchor component for TolyUI based on scrollable_positioned_list.

## Features

- **Precise Navigation**: Based on `scrollable_positioned_list` for accurate scrolling to specific indices
- **Scroll Spy**: Automatically syncs active menu state with scroll position
- **Smooth Animation**: Smooth scroll animations with customizable duration and curve
- **Lock Mechanism**: Prevents highlight flickering during scroll animations

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  tolyui_anchor:
    path: modules/navigation/tolyui_anchor
```

## Usage

### 1. Create a Controller

```dart
final TolyAnchorController _controller = TolyAnchorController();
```

### 2. Define Links

```dart
final List<TolyAnchorLink> _links = const [
  TolyAnchorLink(title: 'Section 1', href: 'section1'),
  TolyAnchorLink(title: 'Section 2', href: 'section2'),
  TolyAnchorLink(title: 'Section 3', href: 'section3'),
];
```

### 3. Build the UI

```dart
Row(
  children: [
    // Left: Navigation
    Container(
      width: 160,
      child: TolyAnchor(
        controller: _controller,
        links: _links,
      ),
    ),
    // Right: Content
    Expanded(
      child: TolyAnchorScrollable(
        controller: _controller,
        itemCount: _links.length,
        itemBuilder: (context, index) {
          return YourSectionWidget(index);
        },
      ),
    ),
  ],
)
```

### 4. Clean Up

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

## API

### TolyAnchorController

- `scrollToIndex(int index)` - Scroll to a specific index with animation
- `scrollTo(String tag)` - Scroll to a specific tag (for compatibility)
- `jumpToIndex(int index)` - Jump to index without animation
- `activeIndex` - Current active index
- `itemScrollController` - Access to underlying ItemScrollController
- `itemPositionsListener` - Access to underlying ItemPositionsListener

### TolyAnchor

- `controller` - The controller to use
- `links` - List of navigation links
- `linkBuilder` - Custom builder for navigation items

### TolyAnchorScrollable

- `controller` - The controller to use
- `itemCount` - Number of items
- `itemBuilder` - Builder function for items

