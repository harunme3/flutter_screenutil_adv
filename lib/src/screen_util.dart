import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'dart:math' show min, max, sqrt, pow;
import 'dart:ui' as ui show FlutterView;
import 'package:flutter/widgets.dart';

enum DeviceType { mobile, tablet, web, mac, windows, linux, fuchsia }

typedef FontSizeResolver = double Function(num fontSize, ScreenUtil instance);

class ScreenUtil {
  ScreenUtil._();
  static ScreenUtil _instance = ScreenUtil._();
  factory ScreenUtil() => _instance;

  static const Size defaultSize = Size(360, 690);

  /// Size of the phone in UI Design , dp
  late Size _uiSize;

  ///Screen orientation
  late Orientation _orientation;

  /// Set of elements to rebuild
  Set<Element>? _elementsToRebuild;

  late bool _minTextAdapt;
  late MediaQueryData _data;
  late bool _splitScreenMode;
  late FontSizeResolver fontSizeResolver;
  late double _scaleDiagonal;

  static Future<void> ensureScreenSize([
    ui.FlutterView? window,
    Duration duration = const Duration(milliseconds: 10),
  ]) async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame();

    await Future.doWhile(() {
      if (window == null) {
        window = binding.platformDispatcher.implicitView;
      }

      if (window == null || window!.physicalSize.isEmpty) {
        return Future.delayed(duration, () => true);
      }

      return false;
    });

    binding.allowFirstFrame();
  }

  static void configure({
    required MediaQueryData data,
    required Size designSize,
    required bool splitScreenMode,
    required bool minTextAdapt,
    required FontSizeResolver fontSizeResolver,
  }) {
    _instance._data = data;
    _instance._uiSize = designSize;

    final MediaQueryData? deviceData = (data.size.isEmpty) ? null : data;
    final Size deviceSize = deviceData?.size ?? designSize;

    final orientation = deviceData?.orientation ??
        (deviceSize.width > deviceSize.height
            ? Orientation.landscape
            : Orientation.portrait);

    _instance
      ..fontSizeResolver = fontSizeResolver
      .._minTextAdapt = minTextAdapt
      .._splitScreenMode = splitScreenMode
      .._orientation = orientation;

    // Calculate diagonal scale (pre-calculated for performance)
    _instance._calculateDiagonalScale();

    _instance._elementsToRebuild?.forEach((el) => el.markNeedsBuild());
  }

  /// Calculate the diagonal scale factor (called once during configuration)
  void _calculateDiagonalScale() {
    final designDiagonal = sqrt(
      pow(_uiSize.width, 2) + pow(_uiSize.height, 2),
    );
    final actualDiagonal = sqrt(
      pow(screenWidth, 2) + pow(screenHeight, 2),
    );
    _scaleDiagonal = actualDiagonal / designDiagonal;
  }

  ///Get screen orientation
  Orientation get orientation => _orientation;

  /// The number of font pixels for each logical pixel.
  double get textScaleFactor => _data.textScaleFactor;

  /// The size of the media in logical pixels (e.g, the size of the screen).
  double? get pixelRatio => _data.devicePixelRatio;

  /// The horizontal extent of this size.
  double get screenWidth => _data.size.width;

  ///The vertical extent of this size. dp
  double get screenHeight => _data.size.height;

  /// The offset from the top, in dp
  double get statusBarHeight => _data.padding.top;

  /// The offset from the bottom, in dp
  double get bottomBarHeight => _data.padding.bottom;

  /// The ratio of actual width to UI design
  double get scaleWidth => screenWidth / _uiSize.width;

  /// The ratio of actual height to UI design
  double get scaleHeight =>
      (_splitScreenMode ? max(screenHeight, _uiSize.height) : screenHeight) /
      _uiSize.height;

  double scaleText(num fontSize) =>
      fontSize * (_minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth);

  /// Adapted to the device width of the UI Design.
  /// Height can also be adapted according to this to ensure no deformation ,
  /// if you want a square
  double setWidth(num width) => width * scaleWidth;

  /// Highly adaptable to the device according to UI Design
  /// It is recommended to use this method to achieve a high degree of adaptation
  /// when it is found that one screen in the UI design
  /// does not match the current style effect, or if there is a difference in shape.
  double setHeight(num height) => height * scaleHeight;

  ///Adapt according to the smaller of width or height
  double radius(num r) => r * min(scaleWidth, scaleHeight);

  /// Diagonal Scalling: Adapt according to the both width and height
  double diagonal(num d) => d * _scaleDiagonal;

  /// Area Scalling: Adapt according to the both width and height
  double area(num a) => a * scaleHeight * scaleWidth;

  /// Adapt according to the maximum value of scale width and scale height
  double diameter(num d) => d * max(scaleWidth, scaleHeight);

  ///Font size adaptation method
  ///- [fontSize] The size of the font on the UI design, in dp.
  double setSp(num fontSize) => fontSizeResolver.call(fontSize, _instance);

  DeviceType deviceType(BuildContext context) {
    var deviceType = DeviceType.web;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    if (kIsWeb) {
      deviceType = DeviceType.web;
    } else {
      bool isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android;
      bool isTablet =
          (orientation == Orientation.portrait && screenWidth >= 600) ||
              (orientation == Orientation.landscape && screenHeight >= 600);

      if (isMobile) {
        deviceType = isTablet ? DeviceType.tablet : DeviceType.mobile;
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.linux:
            deviceType = DeviceType.linux;
            break;
          case TargetPlatform.macOS:
            deviceType = DeviceType.mac;
            break;
          case TargetPlatform.windows:
            deviceType = DeviceType.windows;
            break;
          case TargetPlatform.fuchsia:
            deviceType = DeviceType.fuchsia;
            break;
          default:
            break;
        }
      }
    }

    return deviceType;
  }

  SizedBox setVerticalSpacing(num height) =>
      SizedBox(height: setHeight(height));

  SizedBox setHorizontalSpacing(num width) => SizedBox(width: setWidth(width));
}
