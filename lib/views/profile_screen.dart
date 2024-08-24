import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customs/color_helper.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.darkGrey, // Set background to dark grey
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryTheme,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: ColorHelper.primaryText,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage('https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'), // Replace with actual image path
              ),
              SizedBox(height: 16.h),
              Text(
                'Syed Mahiuddin',
                style: TextStyle(
                  color: ColorHelper.primaryText,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'syed.mahiuddin@example.com',
                style: TextStyle(
                  color: ColorHelper.secondaryryText,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Divider(color: ColorHelper.primaryText.withOpacity(0.2)),
              _buildProfileOption(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  // Navigate to settings screen
                },
              ),
              _buildProfileOption(
                icon: Icons.payment,
                title: 'Payment Methods',
                onTap: () {
                  // Navigate to payment methods screen
                },
              ),
              _buildProfileOption(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {
                  // Navigate to notifications settings screen
                },
              ),
              _buildProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  // Navigate to help and support screen
                },
              ),
              SizedBox(height: 24.h),
              Divider(color: ColorHelper.primaryText.withOpacity(0.2)),
              ListTile(
                leading: Icon(Icons.logout, color: ColorHelper.primaryText),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: ColorHelper.primaryText,
                    fontSize: 16.sp,
                  ),
                ),
                onTap: () {
                  // Implement logout functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
        leading: Icon(icon, color: ColorHelper.primaryText),
    title: Text(
    title,        style: TextStyle(
      color: ColorHelper.primaryText,
      fontSize: 16.sp,
    ),
    ),
      trailing: Icon(Icons.arrow_forward_ios, color: ColorHelper.primaryText, size: 16.sp),
      onTap: onTap,
    );
  }
}
