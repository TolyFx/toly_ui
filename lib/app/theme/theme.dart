import 'dart:ui';

import 'package:flutter/material.dart';

double px1 = 1 / PlatformDispatcher.instance.views.first.devicePixelRatio;

ThemeData get lightTheme {
  return ThemeData(
    // useMaterial3: false,
    fontFamily: '黑体',
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    datePickerTheme: DatePickerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xfff4f8fb),
        surfaceTintColor: Colors.white),
    // scaffoldBackgroundColor: const Color(0xffF3F4F6),
    scaffoldBackgroundColor:  Colors.white,
    appBarTheme: AppBarTheme(
        // backgroundColor: Color(0xfff4f8fb),
        backgroundColor:  Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        )),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xfff2f2f2),
    ),
    chipTheme: ChipThemeData(
        side: BorderSide.none,
        backgroundColor: Color(0xfff3f4f6),
        labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
        labelPadding: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.zero),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xfff2f2f2),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
      },
    ),
    dividerTheme: DividerThemeData(
      color: const Color(0xffdcdfe6),
      space: px1,
      thickness: px1,
    ),
  );
}
