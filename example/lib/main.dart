import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'src/first_method.dart' as firstMethod;

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(
    DevicePreview(
      enabled: kDebugMode && kIsWeb,
      builder: (context) {
        return firstMethod.MyApp();
      },
    ),
  );
}
