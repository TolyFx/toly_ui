import 'dart:ui' as ui;

import '../../model/notice_intent.dart';
import '../theme/toly_message_style_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../notice/countdown_border.dart';

/// 默认磨砂通知内容，动画、堆叠及动作执行由消息处理器统一管理。
class NotificationPanel extends StatelessWidget {
  const NotificationPanel({
    required this.title,
    required this.subtitle,
    this.level = NoticeLevel.info,
    this.duration = const Duration(seconds: 3),
    this.thumbnail,
    this.intent,
    this.onIntent,
    this.onClose,
    this.icon,
    this.foregroundColor,
    super.key,
  });

  /// 标题内容，继承缺省加粗样式。
  final Widget title;

  /// 正文内容，继承缺省正文样式。
  final Widget subtitle;

  /// 通知的语义级别。
  final NoticeLevel level;

  /// 原始显示时长，动作策略可将其转换为常驻。
  final Duration duration;

  /// 可选图片来源，支持内存、资源或使用方提供的本地图片。
  final ImageProvider? thumbnail;

  /// 可选语义动作，不在组件内直接操作系统。
  final NoticeIntent? intent;

  /// 消息处理器提供的动作分发入口。
  final VoidCallback? onIntent;

  /// 消息处理器提供的关闭入口。
  final VoidCallback? onClose;

  /// 兼容原有面板的自定义状态图标。
  final IconData? icon;

  /// 兼容原有面板的强调色覆盖。
  final Color? foregroundColor;

  /// 颜色只用于状态图标，正文保持清晰的中性色。
  Color _accent(BuildContext context) =>
      foregroundColor ??
      switch (level) {
        NoticeLevel.info => Theme.of(context).colorScheme.primary,
        NoticeLevel.success => const Color(0xFF27996A),
        NoticeLevel.warning => const Color(0xFFD48A13),
        NoticeLevel.error => const Color(0xFFD95353),
      };

  IconData get _icon =>
      icon ??
      switch (level) {
        NoticeLevel.info => CupertinoIcons.info,
        NoticeLevel.success => Icons.check_circle_rounded,
        NoticeLevel.warning => Icons.error,
        NoticeLevel.error => CupertinoIcons.exclamationmark_circle_fill,
      };

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final BorderRadius radius = Theme.of(context)
            .extension<TolyMessageStyleTheme>()
            ?.noticeBorderRadius ??
        const BorderRadius.all(Radius.circular(12));
    final Color accent = _accent(context);
    final Color foreground =
        dark ? const Color(0xFFF0F1F3) : const Color(0xFF303640);
    return Semantics(
      container: true,
      liveRegion: true,
      child: NoticeCountdownBorder(
        duration: noticeDisplayDuration(duration, intent),
        borderRadius: radius,
        color: accent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 20,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _glassColors(context, dark),
                  ),
                  borderRadius: radius,
                  border: Border.all(
                    color: dark
                        ? const Color(0x40FFFFFF)
                        : const Color(0xCCFFFFFF),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLeading(context, dark),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeading(foreground),
                            const SizedBox(height: 4),
                            DefaultTextStyle.merge(
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: dark
                                    ? const Color(0xFFBFC4CD)
                                    : const Color(0xFF525C6B),
                              ),
                              child: subtitle,
                            ),
                            if (onIntent != null && intent != null) ...[
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: onIntent,
                                  style: TextButton.styleFrom(
                                    foregroundColor: accent,
                                    backgroundColor: dark
                                        ? const Color(0xFF3B4048)
                                        : const Color(0xFFF0F1F3),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    // 桌面紧凑密度会抵消内边距，此处独立保持按钮留白。
                                    visualDensity: VisualDensity.standard,
                                    alignment: Alignment.center,
                                    minimumSize: const Size(0, 26),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    textStyle: const TextStyle(
                                        fontSize: 11,
                                        height: 1.2,
                                        leadingDistribution:
                                            TextLeadingDistribution.even,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  child: Text('${intent!.label} →'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 关闭按钮只占标题行，正文和动作行可以对齐到卡片右侧内边距。
  Widget _buildHeading(Color foreground) => Row(
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
                child: title,
                style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: foreground)),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              tooltip: '关闭通知',
              padding: EdgeInsets.zero,
              iconSize: 13,
              color: const Color(0xFF969DA8),
              onPressed: onClose,
              icon: const Icon(CupertinoIcons.clear),
            ),
          ),
        ],
      );

  /// 高对比度模式使用实色背景，普通模式保留真实背景模糊。
  List<Color> _glassColors(BuildContext context, bool dark) {
    if (MediaQuery.highContrastOf(context)) {
      return dark
          ? const [Color(0xFF24272C), Color(0xFF24272C)]
          : const [Colors.white, Colors.white];
    }
    return dark
        ? const [Color(0xD9363C46), Color(0xC4242932)]
        : const [Color(0xD9FFFFFF), Color(0xA6FFFFFF)];
  }

  /// 有缩略图时展示图片，否则保持语义状态图标。
  Widget _buildLeading(BuildContext context, bool dark) {
    final ImageProvider? image = thumbnail;
    if (image == null) {
      return _buildStatusIcon(context, dark);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image(
        image: ResizeImage.resizeIfNeeded(168, null, image),
        width: 56,
        height: 64,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: _buildImageFallback,
      ),
    );
  }

  Widget _buildImageFallback(
          BuildContext context, Object error, StackTrace? stackTrace) =>
      _buildStatusIcon(
          context, Theme.of(context).brightness == Brightness.dark);

  Widget _buildStatusIcon(BuildContext context, bool dark) => Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _accent(context).withValues(alpha: dark ? 0.22 : 0.13),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(_icon, color: _accent(context), size: 17),
      );
}
