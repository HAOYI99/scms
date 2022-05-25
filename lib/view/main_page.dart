import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/controller/login_controller.dart';
import 'package:scms/main.dart';
import 'package:scms/view/attendance_page.dart';
import 'package:scms/view/calendar_page.dart';
import 'package:scms/view/home_page.dart';
import 'package:scms/view/login_page.dart';
import 'package:scms/view/profile_page.dart';
import 'package:scms/view/search_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 2;
  final screen = [
    SearchPage(),
    AttendancePage(),
    HomePage(),
    CalendarPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.red,
        buttonBackgroundColor: Colors.red,
        backgroundColor: Colors.transparent,
        height: 55.0,
        index: selectedIndex,
        items: const [
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.checklist_rtl_rounded, size: 30, color: Colors.white),
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.calendar_today_rounded, size: 30, color: Colors.white),
          Icon(Icons.account_circle_rounded, size: 30, color: Colors.white),
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

  _appBar() {
    //getting the size of app bar
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: const Text('SCMS'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            logout(context);
          }, icon: const Icon(Icons.logout_outlined))
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await Provider.of<LoginController>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => CheckAuth(),
    ));
  }
}
