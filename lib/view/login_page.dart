import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/controller/login_controller.dart';
import 'package:scms/main.dart';
import 'package:scms/view/profile_page.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginUI(),
    );
  }

  //create login ui
  loginUI() {
    
    //logged UI
    //loginControllers
    
    return Consumer<LoginController>(builder: (context, model, child) {
      //if logged in
      if (model.userDetails != null) {
        return Center(
          child: loggedInUI(model),
        );
      } else {
        return loginControllers(context);
      }
    });
  }

  loggedInUI(LoginController model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      //3 children in UI, name email photo and logout button
      children: [
        CircleAvatar(
            backgroundImage:
                Image.network(model.userDetails!.photoURL ?? "").image,
            radius: 50),
        Text(model.userDetails!.displayName ?? ""),
        Text(model.userDetails!.email ?? ""),

        //logout button
        ActionChip(
          label: Text('Logout'),
          onPressed: () {
            Provider.of<LoginController>(context, listen: false).logout();
          },
          avatar: Icon(Icons.logout),
        )
      ],
    );
  }

  loginControllers(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Image.asset("assets/images/google.png", width: 240),
            onTap: () async {
              await Provider.of<LoginController>(context, listen: false)
                  .googleLogin();

            },
          ),
        ],
      ),
    );
  }
  
}