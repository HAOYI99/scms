import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:scms/screens/authenticate/sign_in.dart';
import 'package:scms/screens/club/club.dart';
import 'package:scms/screens/home/home.dart';
import 'package:scms/screens/profile/profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List pages = [Club(), SignIn(), Home(), SignIn(), const Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        key: _bottomNavigationKey,
        height: 50,
        color: Colors.indigo,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.indigo,
        items: const [
          Icon(Icons.groups_sharp, color: Colors.white),
          Icon(Icons.checklist, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.event, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        animationCurve: Curves.fastLinearToSlowEaseIn,
      ),
      body: pages[_page],
    );
  }
}
