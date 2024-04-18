import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppState extends Equatable {
  /// [appStyle] app 深色样式;
  final ThemeMode themeMode;

  const AppState({
    required this.themeMode,
  });

  @override
  List<Object?> get props => [themeMode];

  AppState copyWith({
    ThemeMode? themeMode,
  }) =>
      AppState(themeMode: themeMode ?? this.themeMode);
}
