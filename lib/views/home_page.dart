
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../customs/color_helper.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryTheme,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
          color: ColorHelper.primaryTheme, // Black background
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  color: ColorHelper.secondryTheme, // Amber color
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: ColorHelper.primaryTheme,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: ColorHelper.secondryTheme, // Amber border
                    width: 2.w,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add,
                      size: 36.sp,
                      color: ColorHelper.secondryTheme,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Add an Opal card or credit/\ndebit card',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorHelper.secondryTheme,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://d28wu8o6itv89t.cloudfront.net/images/Visadebitcardpng-1599584312349.png', // Replace with actual asset paths
                          width: 40.w,
                        ),
                        SizedBox(width: 10.w),
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/MasterCard_Logo.svg/1280px-MasterCard_Logo.svg.png',
                          width: 40.w,
                        ),
                        SizedBox(width: 10.w),
                        Image.network(
                          'https://d28wu8o6itv89t.cloudfront.net/images/Visadebitcardpng-1599584312349.png',
                          width: 40.w,
                        ),
                        SizedBox(width: 10.w),
                        Image.network(
                          'https://d28wu8o6itv89t.cloudfront.net/images/Visadebitcardpng-1599584312349.png',
                          width: 40.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  ColorHelper.secondryTheme, // Amber color
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_wallet, color: ColorHelper.primaryTheme, size: 24.w),
                      SizedBox(width: 10.w),
                      Text(
                        'Top up',
                        style: TextStyle(
                          color: ColorHelper.primaryTheme,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Where to?',
                    hintStyle: TextStyle(
                      color: ColorHelper.secondryTheme.withOpacity(0.7),
                      fontSize: 16.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorHelper.secondryTheme.withOpacity(0.7),
                      size: 28.w,
                    ),
                    filled: true,
                    fillColor: ColorHelper.darkGrey,
                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Saved trips',
                style: TextStyle(
                  color: ColorHelper.secondryTheme,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Card(
                color: ColorHelper.darkGrey,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ListTile(
                  leading: Container(
                    width: 60.w,height: 65.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1uF41YmnKTcgob8sYbzcaEdbD9L_Tl3sB5Q&s', // Replace with actual asset paths
                        width: 60.w,height: 65.h,fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    'Save time searching',
                    style: TextStyle(
                      color: ColorHelper.secondryTheme,
                      fontSize: 16.sp,
                    ),
                  ),
                  subtitle: Text(
                    'Search and tap save on your regular trips for quicker trip planning',
                    style: TextStyle(
                      color: ColorHelper.secondryTheme.withOpacity(0.7),
                      fontSize: 14.sp,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: ColorHelper.secondryTheme, size: 20.w),
                  onTap: () {
                    // Handle card tap
                  },
                ),
              ),
            ],
          ),
        ),

          SizedBox(height: 30.h),
            Text(
              'Recent Journeys',
              style: TextStyle(
                color: ColorHelper.primaryText,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                leading: Icon(
                  Icons.directions_bus,
                  color: ColorHelper.primaryText,
                ),
                title: Text(
                  'Central Station to Town Hall',
                  style: TextStyle(
                    color: ColorHelper.primaryText,
                  ),
                ),
                subtitle: Text(
                  'Cost: \$3.20',
                  style: TextStyle(
                    color: ColorHelper.secondaryryText,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: ColorHelper.primaryText,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
