import 'package:flutter/material.dart';
import 'package:scms/view/screen_main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: screenMain(),
    );
  }
}
