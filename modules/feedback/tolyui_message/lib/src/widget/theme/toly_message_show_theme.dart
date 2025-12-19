import 'package:flutter/material.dart';

import '../../logic/message/message_manager.dart';
import '../../model/position.dart';

class TolyMessageShowTheme extends ThemeExtension<TolyMessageShowTheme> {
  final Duration? duration;
  final Duration? animaDuration;
  final MessagePosition? messagePosition;
  final NoticePosition? noticePosition;
  final Offset? noticeOffset;
  final Offset? offset;
  final double? gap;

  const TolyMessageShowTheme({
    this.duration,
    this.animaDuration,
    this.messagePosition,
    this.noticePosition,
    this.offset,
    this.noticeOffset,
    this.gap,
  });

  TolyMessageShowTheme.tolyui({
    this.duration = const  Duration(seconds: 3),
    this.animaDuration= const  Duration(milliseconds: 250),
    this.messagePosition = MessagePosition.top,
    this.noticePosition = NoticePosition.topRight,
    this.offset = const Offset(0,16),
    this.noticeOffset = const Offset(16,16),
    this.gap = 12,
  });

  @override
  TolyMessageShowTheme copyWith({
    Duration? duration,
    Duration? animaDuration,
    NoticePosition? noticePosition,
    MessagePosition? messagePosition,
    Offset? offset,
    Offset? noticeOffset,
    double? gap,
  }) {
    return TolyMessageShowTheme(
      duration: duration ?? this.duration,
      animaDuration: animaDuration ?? this.animaDuration,
      messagePosition: messagePosition ?? this.messagePosition,
      noticePosition: noticePosition ?? this.noticePosition,
      offset: offset ?? this.offset,
      gap: gap ?? this.gap,
      noticeOffset: noticeOffset ?? this.noticeOffset,
    );
  }

  @override
  TolyMessageShowTheme lerp(TolyMessageShowTheme? other, double t) => this;
}

