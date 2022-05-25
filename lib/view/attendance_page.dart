import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  
  @override
  State<AttendancePage> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Attendance'),
      ),
    );
  }
}