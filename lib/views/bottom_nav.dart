import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transport/views/card_screen.dart';
import 'package:transport/views/transport_screen.dart';

import '../customs/color_helper.dart';
import 'home_page.dart';

class OpalBottomNavBar extends StatefulWidget {
  @override
  _OpalBottomNavBarState createState() => _OpalBottomNavBarState();
}

class _OpalBottomNavBarState extends State<OpalBottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  final List<Widget> _screens = [
    HomeScreen(),
    CardScreen(),
    TripPlannerScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryTheme,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: ColorHelper.primaryTheme,
          selectedItemColor: ColorHelper.secondryTheme,
          unselectedItemColor: ColorHelper.primaryText.withOpacity(0.7),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 24.w),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card, size: 24.w),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus, size: 24.w),
              label: 'Planner',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications, size: 24.w),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 24.w),
              label: 'Profile',
            ),
          ],
          onTap: _onItemTapped,
          selectedFontSize: 12.sp,
          unselectedFontSize: 10.sp,
          iconSize: 28.w,
        ),
      ),
    );
  }
}
