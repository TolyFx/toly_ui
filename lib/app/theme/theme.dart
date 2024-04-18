import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tolyui/tolyui.dart';

import '../../navigation/router/transition/fade_page_transitions_builder.dart';
import '../../navigation/router/transition/slide_transition/slide_page_transition_builder.dart';
import '../../view/widgets/basic/layout/layout_display_page.dart';

double px1 = 1 / PlatformDispatcher.instance.views.first.devicePixelRatio;

Re _elementParserStrategy(double width) {
  if (width < 768) return Re.xs;
  if (width >= 768 && width < 992) return Re.sm;
  if (width >= 992 && width < 1200) return Re.md;
  if (width >= 1200 && width < 1920) return Re.lg;
  return Re.xl;
}

ThemeData get darkTheme {
  Color scaffoldBackgroundColor = const Color(0xff010201);

  SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  );

  return ThemeData(
    fontFamily: '黑体',
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: SlidePageTransitionsBuilder(),
      TargetPlatform.iOS: SlidePageTransitionsBuilder(),
      TargetPlatform.macOS: FadePageTransitionsBuilder(),
      TargetPlatform.windows: FadePageTransitionsBuilder(),
      TargetPlatform.linux: FadePageTransitionsBuilder(),
    }),
    tabBarTheme: TabBarTheme(
      dividerColor:  Colors.transparent,
    ),
    // fontFamily: state.fontFamily,
    useMaterial3:true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xff4699FB),
    listTileTheme: ListTileThemeData(
      tileColor: Color(0xff181818),
      textColor: Color(0xffD6D6D6),
    ),
    appBarTheme:  AppBarTheme(
        systemOverlayStyle: overlayStyle,
        elevation: 0,
        centerTitle: false,
        backgroundColor: Color(0xff181818),

        iconTheme: IconThemeData(color:  Color(0xffCCCCCC)),

        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xffCCCCCC))),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white, backgroundColor: Color(0xff4699FB)),
    dividerTheme: DividerThemeData(
      color: const Color(0xff2F2F2F),
      space: px1,
      thickness: px1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xff181818),
        selectedItemColor: Color(0xff4699FB)),
  );
}
ThemeData get lightTheme {
  return ThemeData(
    dividerColor: Colors.transparent,
    // useMaterial3: false,
    fontFamily: '黑体',
    extensions: [
      LinkTheme(
        style: TextStyle(fontSize: 14,color:Color(0xff606266) ),
        hoverColor: Color(0xff0061a4),
        // lineType:LineType.always,
        // hoverColor: Colors.redAccent,
      ),

      ReParserStrategyTheme(parserStrategy: _elementParserStrategy)],
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent)
      )
    ),
    datePickerTheme: DatePickerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xfff4f8fb),
        surfaceTintColor: Colors.white),
    // scaffoldBackgroundColor: const Color(0xffF3F4F6),
    scaffoldBackgroundColor: Colors.white,
    // buttonTheme: ButtonThemeData(
    //   hoverColor: Colors.transparent,
    //   highlightColor: Colors.transparent,
    //   focusColor: Colors.transparent,
    //   minWidth: 240
    // ),

    splashFactory: NoSplash.splashFactory,
    // tabBarTheme: TabBarTheme(
    //   overlayColor: MaterialStatePropertyAll(Colors.transparent)
    // ),
    //
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(elevation: MaterialStatePropertyAll(0)
          // overlayColor: MaterialStatePropertyAll<Color>(Colors.transparent),
          ),
    ),
    // outlinedButtonTheme: OutlinedButtonThemeData(
    //     style: ButtonStyle(
    //         overlayColor: MaterialStatePropertyAll<Color>(Colors.transparent)
    //     )
    // ),
    appBarTheme: AppBarTheme(
        // backgroundColor: Color(0xfff4f8fb),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: '黑体',
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

    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: SlidePageTransitionsBuilder(),
      TargetPlatform.iOS: SlidePageTransitionsBuilder(),
      TargetPlatform.macOS: SlidePageTransitionsBuilder(),
      TargetPlatform.windows: SlidePageTransitionsBuilder(),
      TargetPlatform.linux: SlidePageTransitionsBuilder(),
    }),
    dividerTheme: DividerThemeData(
      color: const Color(0xffdcdfe6),
      space: px1,
      thickness: px1,
    ),
  );
}
