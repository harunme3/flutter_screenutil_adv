import 'package:device_preview/device_preview.dart';
import 'package:example/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  runApp(
    DevicePreview(
      enabled: kDebugMode && kIsWeb,
      builder: (context) {
        return MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      responsiveWidgets: const ['HomePageScaffold'],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Responsive Widgets',
          home: const HomePage(title: 'Responsive Widgets'),
        );
      },
    );
  }
}
