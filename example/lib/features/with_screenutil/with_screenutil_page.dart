import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WithScreenUtilPage extends StatelessWidget {
  const WithScreenUtilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('With ScreenUtil')),
      body: Center(
        child: Container(
          width: 300.w,
          height: 300.h,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Responsive Text',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Icon(Icons.check_circle, size: 50.w, color: Colors.white),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'This layout uses flutter_screenutil extensions like .w, .h, .sp, and .r to adapt to different screen sizes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
