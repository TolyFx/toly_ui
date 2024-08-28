import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tolyui/tolyui.dart' hide TolyMenuTheme;

import '../../navigation/router/transition/fade_page_transitions_builder.dart';
import '../../navigation/router/transition/slide_transition/slide_page_transition_builder.dart';

double px1 = 1 / PlatformDispatcher.instance.views.first.devicePixelRatio;

Rx _elementParserStrategy(double width) {
  if (width < 768) return Rx.xs;
  if (width >= 768 && width < 992) return Rx.sm;
  if (width >= 992 && width < 1200) return Rx.md;
  if (width >= 1200 && width < 1920) return Rx.lg;
  return Rx.xl;
}

SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
);

ThemeData get darkTheme {
  return ThemeData(
    extensions: [
      TolyMessageStyleTheme.tolyuiDark(),
      TolyMessageShowTheme.tolyui(duration: const Duration(seconds: 3)),
      // ReParserStrategyTheme(parserStrategy: _elementParserStrategy),
    ],
    fontFamily: '黑体',
    scaffoldBackgroundColor: const Color(0xff010201),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: SlidePageTransitionsBuilder(),
      TargetPlatform.iOS: SlidePageTransitionsBuilder(),
      TargetPlatform.macOS: FadePageTransitionsBuilder(),
      TargetPlatform.windows: FadePageTransitionsBuilder(),
      TargetPlatform.linux: FadePageTransitionsBuilder(),
    }),
    tabBarTheme: const TabBarTheme(
      dividerColor: Colors.transparent,
    ),
    // fontFamily: state.fontFamily,
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xff4699FB),
    listTileTheme: const ListTileThemeData(
      tileColor: Color(0xff181818),
      textColor: Color(0xffD6D6D6),
    ),
    appBarTheme: AppBarTheme(
        systemOverlayStyle: overlayStyle,
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(0xff181818),
        iconTheme: const IconThemeData(color: Color(0xffCCCCCC)),
        titleTextStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffCCCCCC))),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white, backgroundColor: Color(0xff4699FB)),
    dividerTheme: DividerThemeData(
      color: const Color(0xff2F2F2F),
      space: px1,
      thickness: px1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xff181818), selectedItemColor: Color(0xff4699FB)),
  );
}

ThemeData get lightTheme {
  return ThemeData(
    extensions: [
      TolyMessageStyleTheme.tolyuiLight(),
      TolyMessageShowTheme.tolyui(duration: const Duration(seconds: 3), offset: Offset(0, 36)),
      LinkTheme(
        style: const TextStyle(fontSize: 14, color: Color(0xff606266)),
        hoverColor: const Color(0xff0061a4),
        // lineType:LineType.always,
        // hoverColor: Colors.redAccent,
      ),

      // TolyMenuTheme(
      //     backgroundColor: Colors.white,
      //     expandBackgroundColor: Colors.white,
      //     selectedItemBackground: Color(0xffe6f7ff),
      //     unselectedLabelTextStyle: TextStyle(color: Color(0xff2d3a53)),
      //     selectedLabelTextStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      // ReParserStrategyTheme(parserStrategy: _elementParserStrategy),
    ],
    dividerColor: Colors.transparent,
    // useMaterial3: false,
    fontFamily: '黑体',
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
    )),

    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent))),
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
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(elevation: MaterialStatePropertyAll(0)
          // overlayColor: MaterialStatePropertyAll<Color>(Colors.transparent),
          ),
    ),
    // outlinedButtonTheme: OutlinedButtonThemeData(
    //     style: ButtonStyle(
    //         overlayColor: MaterialStatePropertyAll<Color>(Colors.transparent)
    //     )
    // ),
    appBarTheme: const AppBarTheme(
        // backgroundColor: Color(0xfff4f8fb),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: '黑体',
        )),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xfff2f2f2),
    ),
    chipTheme: const ChipThemeData(
        side: BorderSide.none,
        backgroundColor: Color(0xfff3f4f6),
        labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
        labelPadding: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.zero),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xfff2f2f2),
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
