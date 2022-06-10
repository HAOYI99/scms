import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/profile/edit_password.dart';
import 'package:scms/screens/profile/edit_profile.dart';
import 'package:scms/services/auth.dart';
import 'package:scms/services/database.dart';
import 'package:scms/shared/constants.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);

    return isLoading
        ? loadingIndicator()
        : Scaffold(
            body: StreamBuilder<UserData>(
                stream: DatabaseService(uid: user!.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData? userData = snapshot.data;
                    return Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 200.0,
                            ),
                            GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 60.0,
                                child: CircleAvatar(
                                  backgroundImage: Image.network(
                                          'https://assets-global.website-files.com/60bbe7b27107c8b9e196657f/615a9cab7fa875af3586e6b3_ultraman.jpeg')
                                      .image,
                                  radius: 55.0,
                                  backgroundColor: Colors.blue,
                                  child: Stack(
                                    children: const [
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: CircleAvatar(
                                          radius: 17.0,
                                          child: Icon(Icons.edit),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                _showEditPanel(userData!.user_email!);
                              },
                            ),
                            Text(userData!.user_ID!),
                            Text(userData.user_email!),
                            Text(userData.user_name!),
                            Text(userData.user_lastName!),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() => isLoading = true);
                                  await _auth.signOut().then((value) {
                                    showSnackBar('Signed Out', Colors.white,
                                        Colors.blue, context);
                                  });
                                },
                                child: Text('Sign Out'))
                          ],
                        ),
                      ),
                    );
                  } else {
                    return loadingIndicator();
                  }
                }),
          );
  }

  void _showEditPanel(String email) {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (context) {
          return Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                      child: Container(
                          height: 5.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)))),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.blue))),
                      child: Text(
                        'Edit Profile Action',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.blue),
                      ),
                      padding: EdgeInsets.only(bottom: 15.0),
                    ),
                    InkWell(
                      child: _buildListItem('Change Password'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  changePassword(user_email: email),
                            ));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Change Profile Picture'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Edit Profile Information'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Container _buildListItem(String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
