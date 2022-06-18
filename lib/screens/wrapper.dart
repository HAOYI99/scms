import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/authenticate/authenticate.dart';
import 'package:scms/screens/mainpage.dart';

class wrapper extends StatelessWidget {
  const wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);

    //return home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return MainPage();
    }
  }
}
