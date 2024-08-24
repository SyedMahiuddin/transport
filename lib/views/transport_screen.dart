import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:transport/views/map_screen.dart';

import '../customs/color_helper.dart';

class TripPlannerScreen extends StatefulWidget {
  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}
bool stWriting=true;
class _TripPlannerScreenState extends State<TripPlannerScreen> {
  int selectedTypeIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryTheme, // Black background
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: ColorHelper.darkGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: ColorHelper.darkGrey,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(stWriting?Icons.radio_button_checked:Icons.radio_button_unchecked, color: Colors.white, size: 20.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                  onTap: (){
                                    setState(() {
                                      stWriting=true;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter starting location',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.white, height: 20.h),
                          Row(
                            children: [
                              Icon(stWriting==false?Icons.radio_button_checked:Icons.radio_button_unchecked, color: Colors.white, size: 20.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                  onTap: (){
                                    setState(() {
                                      stWriting=false;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter destination',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.secondryTheme, // Amber button
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Save this trip',
                    style: TextStyle(
                      color: ColorHelper.primaryTheme, // Black text
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedTypeIndex=0;
                      });
                    },
                      child: _buildTransportOption(Icons.directions_walk, '1hr 14', selectedTypeIndex==0?true: false)),
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedTypeIndex=1;
                        });
                      },
                      child: _buildTransportOption(Icons.directions_bike, '3hr 22', selectedTypeIndex==1?true: false)),
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedTypeIndex=2;
                        });
                      },
                      child: _buildTransportOption(Icons.directions_walk, '--', selectedTypeIndex==2?true: false)),
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedTypeIndex=3;
                        });
                      },
                      child: _buildTransportOption(Icons.directions_car, '56 min',selectedTypeIndex==3?true: false)),
                  Icon(Icons.filter_list, color: Colors.white, size: 24.sp),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'Leaving now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Load earlier times',
                style: TextStyle(
                  color: ColorHelper.secondryTheme,
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                  onTap: () {
                    Get.to(() => MapScreen(),
                        transition: Transition.downToUp,
                        duration: Duration(milliseconds: 400));
                  },
                  child: _buildTripOption('4hrs', '7:18am - 8:32am', '1hr 14mins', '\$5.86', true)),
              InkWell(
                  onTap: () {
                    Get.to(() => MapScreen(),
                        transition: Transition.downToUp,
                        duration: Duration(milliseconds: 400));
                  },
                  child: _buildTripOption('4hrs', '7:48am - 9:02am', '1hr 14mins', '\$5.86', false)),
              InkWell(
                  onTap: () {
                    Get.to(() => MapScreen(),
                        transition: Transition.downToUp,
                        duration: Duration(milliseconds: 400));
                  },
                  child: _buildTripOption('5hrs', '8:18am - 9:32am', '1hr 14mins', '\$5.86', false)),
              InkWell(
                  onTap: () {
                    Get.to(() => MapScreen(),
                        transition: Transition.downToUp,
                        duration: Duration(milliseconds: 400));
                  },
                  child: _buildTripOption('5hrs', '8:23am - 9:57am', '1hr 34mins', '\$5.86', false)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransportOption(IconData icon, String time, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70),
        color: isSelected ? ColorHelper.secondryTheme : ColorHelper.darkGrey,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(height: 4.h),
          Text(
            time,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripOption(String departTime, String timeRange, String duration, String cost, bool isAccessible) {
    return Card(
      color: ColorHelper.darkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Departs $departTime',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.directions_walk, color: Colors.white, size: 18.sp),
                    SizedBox(width: 4.w),
                    Icon(Icons.directions_bus, color: Colors.blue, size: 18.sp),
                    Text('747', style: TextStyle(color: Colors.blue, fontSize: 14.sp)),
                    SizedBox(width: 4.w),
                    Icon(Icons.directions_railway, color: Colors.green, size: 18.sp),
                    Text('M1', style: TextStyle(color: Colors.green, fontSize: 14.sp)),
                    SizedBox(width: 4.w),
                    Icon(Icons.directions_walk, color: Colors.white, size: 18.sp),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '$timeRange $duration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'No real-time data',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cost,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (isAccessible)
                      Icon(Icons.accessible, color: Colors.white, size: 18.sp),
                    SizedBox(width: 8.w),
                    Icon(Icons.info_outline, color: Colors.white, size: 18.sp),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
