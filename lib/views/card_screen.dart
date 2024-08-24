import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customs/color_helper.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.darkGrey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15.h),
            Container(
              width: MediaQuery.of(context).size.width,
              color: ColorHelper.primaryTheme,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Activity',
                  style: TextStyle(
                    color: ColorHelper.secondryTheme, // Amber color
                    fontSize: 22.sp,
                  ),
                ),
              ),
            ),
           Stack(
             children: [
               SizedBox(
                 height: 270.h,
                 width: MediaQuery.of(context).size.width,
               ),
               Container(
                 height: 120.h,
                 width: MediaQuery.of(context).size.width,
                 color: ColorHelper.primaryTheme,
               ),
               Align(
                 alignment: Alignment.center,
                 child: Container(
                   width: 300.w,
                   child: Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         SizedBox(height: 20.h),
                         Container(
                           padding: EdgeInsets.all(16.w),
                           decoration: BoxDecoration(
                             color: ColorHelper.primaryTheme,
                             borderRadius: BorderRadius.circular(6.r),
                             border: Border.all(
                               color: ColorHelper.secondryTheme, // Amber border
                               width: 1.w,
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
                               Container(
                                 decoration: BoxDecoration(
                                   color: ColorHelper.darkGrey,
                                   borderRadius: BorderRadius.circular(25)
                                 ),
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(
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
                                 ),
                               ),
                             ],
                           ),
                         ),

                       ],
                     ),
                   ),
                 ),
               ),
             ],
           ),
            SizedBox(height: 15.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,height: 100.w,
                  decoration: BoxDecoration(
                    color: ColorHelper.primaryTheme,
                      borderRadius: BorderRadius.circular(90)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Icon(Icons.add_card,color: ColorHelper.secondryTheme.withOpacity(0.7),size: 50.sp,)
                  ),
                ),
                SizedBox(height: 5.h,),
                Text(
                  'No card available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorHelper.secondryTheme,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 5.h,),
                Text(
                  'Please add an card to view your travel activity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorHelper.secondryTheme,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
