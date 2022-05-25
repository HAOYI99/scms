import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scms/model/user_detail.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserDetails loggedInUser = UserDetails();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then(
      (value) {
        this.loggedInUser = UserDetails.fromMap(value.data());
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Image.network('${loggedInUser.photoURL}'),
              Text(
                '${loggedInUser.displayName}',
              ),
              Text(
                '${loggedInUser.email}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
