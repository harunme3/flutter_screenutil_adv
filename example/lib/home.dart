import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/with_screenutil/with_screenutil_page.dart';
import 'features/with_screenutil/signup_page.dart';
import 'features/without_screenutil/without_screenutil_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WithScreenUtilPage()),
                );
              },
              child: const Text('Features With ScreenUtil'),
            ),
            10.verticalSpace,
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SignupPage()));
              },
              child: const Text('Signup Page (ScreenUtil)'),
            ),
            10.verticalSpace,
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const WithoutScreenUtilPage(),
                  ),
                );
              },
              child: const Text('Features Without ScreenUtil'),
            ),
          ],
        ),
      ),
    );
  }
}
