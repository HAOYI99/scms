import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:scms/view/screen_attendance.dart';
import 'package:scms/view/screen_calendar.dart';
import 'package:scms/view/screen_home.dart';
import 'package:scms/view/screen_profile.dart';
import 'package:scms/view/screen_search.dart';

class screenMain extends StatefulWidget {
  @override
  State<screenMain> createState() => _screenMainState();
}

class _screenMainState extends State<screenMain> {
  int selectedIndex = 2;
  final screen = [
    screenSearch(),
    screenAttendance(),
    screenHome(),
    screenCalendar(),
    screenProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.blueAccent,
        backgroundColor: Colors.transparent,
        height: 50.0,
        index: selectedIndex,
        items: const [
          Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.checklist_rtl_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.calendar_today_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.account_circle_rounded,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        animationCurve: Curves.fastLinearToSlowEaseIn,
        animationDuration: const Duration(milliseconds: 300),
      ),
      body: screen[selectedIndex],
    );
  }
}
