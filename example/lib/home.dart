import 'package:flutter/material.dart';

import 'features/with_screenutil/with_screenutil_page.dart';
import 'features/without_screenutil/without_screenutil_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil only once in the main app or the root widget,
    // but ensuring it's available here.
    // Assuming main.dart calls ScreenUtilInit around MaterialApp or HomePage.
    // If not, we might need to wrap here, but typically it is done in main.dlart.

    return Scaffold(
      appBar: AppBar(title: const Text('ScreenUtil Example')),
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
            const SizedBox(height: 20),
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
