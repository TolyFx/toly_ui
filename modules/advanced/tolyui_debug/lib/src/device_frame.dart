import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DeviceType { ios, android }

class DeviceFrame extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color frameColor;
  final double borderRadius;
  final double notchWidth;
  final double notchHeight;
  final double devicePixelRatio;
  final DeviceType deviceType;
  final bool showStatusBar;
  final bool showNavigationBar;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  const DeviceFrame({
    super.key,
    required this.child,
    this.width = 375,
    this.height = 812,
    this.frameColor = Colors.black,
    this.borderRadius = 40,
    this.notchWidth = 150,
    this.notchHeight = 30,
    this.devicePixelRatio = 3.0,
    this.deviceType = DeviceType.ios,
    this.showStatusBar = true,
    this.showNavigationBar = false,
    this.systemUiOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 20,
      height: height + 20,
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 10,
            right: 10,
            bottom: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius - 5),
              child: MediaQuery(
                data: MediaQueryData(
                  size: Size(width, height),
                  devicePixelRatio: devicePixelRatio,
                  textScaler: TextScaler.linear(1.0),
                  padding: EdgeInsets.only(
                    top: showStatusBar
                        ? (deviceType == DeviceType.ios ? 44 : 24)
                        : 0,
                    bottom: showNavigationBar
                        ? (deviceType == DeviceType.ios ? 34 : 48)
                        : 0,
                  ),
                ),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: systemUiOverlayStyle ?? _defaultSystemUiOverlayStyle,
                  child: Stack(
                    children: [
                      child,
                      if (showStatusBar) _buildStatusBar(),
                      if (showNavigationBar) _buildNavigationBar(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (deviceType == DeviceType.ios)
            Positioned(
              left: (width + 20 - notchWidth) / 2,
              top: 9,
              child: Container(
                width: notchWidth,
                height: notchHeight,
                decoration: BoxDecoration(
                  color: frameColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  SystemUiOverlayStyle get _defaultSystemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    );
  }

  Widget _buildStatusBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: deviceType == DeviceType.ios ? 44 : 24,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: deviceType == DeviceType.ios ? 8 : 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '9:41',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: deviceType == DeviceType.ios ? 15 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.signal_cellular_4_bar,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Icon(Icons.wifi, color: Colors.black, size: 16),
                  const SizedBox(width: 4),
                  Icon(Icons.battery_full, color: Colors.black, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: deviceType == DeviceType.ios ? 34 : 48,
        color: Colors.transparent,
        child: deviceType == DeviceType.ios
            ? Center(
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  Icon(Icons.circle_outlined, color: Colors.white, size: 24),
                  Icon(Icons.square_outlined, color: Colors.white, size: 24),
                ],
              ),
      ),
    );
  }
}
