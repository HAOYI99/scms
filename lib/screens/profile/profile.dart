import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/profile/edit_password.dart';
import 'package:scms/screens/profile/edit_profilepic.dart';
import 'package:scms/screens/profile/editprofile.dart';
import 'package:scms/services/auth.dart';
import 'package:scms/services/user_database.dart';
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
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 200.0,
                              ),
                              GestureDetector(
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 60.0,
                                  child: CircleAvatar(
                                    backgroundImage: userData!
                                            .user_photo!.isNotEmpty
                                        ? NetworkImage('${userData.user_photo}')
                                        : AssetImage('assets/logo.png')
                                            as ImageProvider,
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
                                  _showEditPanel(userData);
                                },
                              ),
                              Text(userData.user_email!),
                              Text(userData.user_lastName! +
                                  ' ' +
                                  userData.user_name!),
                              ElevatedButton(
                                  onPressed: () async {
                                    setState(() => isLoading = true);
                                    await _auth.signOut().then((value) {
                                      showSuccessSnackBar(
                                          'Signed Out', context);
                                    }).catchError((e) {
                                      showFailedSnackBar(e.toString(), context);
                                    });
                                  },
                                  child: Text('Sign Out'))
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return loadingIndicator();
                  }
                }),
          );
  }

  void _showEditPanel(UserData userData) {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
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
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.blue))),
                      child: const Text(
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
                              builder: (context) => changePassword(
                                  user_email: userData.user_email!),
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
                              builder: (context) => changeProfilePicture(),
                            ));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Edit Profile'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfile(userData: userData),
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
