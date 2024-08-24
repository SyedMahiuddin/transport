import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customs/color_helper.dart';

class SavedTripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.darkGrey, // Background color
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryTheme,
        title: Text(
          'Saved trips',
          style: TextStyle(
            color: ColorHelper.primaryText,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Text(
                'NEW',
                style: TextStyle(
                  color: ColorHelper.primaryText,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map,
                size: 100.sp,
                color: ColorHelper.primaryText, // Placeholder icon, replace with your image asset
              ),
              SizedBox(height: 16.h),
              Text(
                'No saved trips',
                style: TextStyle(
                  color: ColorHelper.primaryText,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Save your regular trips for quick access to public transport times and full journey planning.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorHelper.primaryText,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Start a new trip search, then tap save.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorHelper.primaryText,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      );
  }
}