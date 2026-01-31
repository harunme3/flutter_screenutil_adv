import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'src/first_method.dart' as firstMethod;
import 'src/second_method.dart' as secondMethod;

void main() async {
  const method = int.fromEnvironment('method', defaultValue: 1);
  await ScreenUtil.ensureScreenSize();
  runApp(
    DevicePreview(
      enabled: kDebugMode && kIsWeb,
      builder: (context) {
        return method == 1 ? firstMethod.MyApp() : secondMethod.MyApp();
      },
    ),
  );
}
