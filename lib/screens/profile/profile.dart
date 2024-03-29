import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/profile/edit_password.dart';
import 'package:scms/screens/profile/edit_profilepic.dart';
import 'package:scms/screens/profile/edit_profile.dart';
import 'package:scms/services/auth.dart';
import 'package:scms/services/user_database.dart';
import 'package:scms/shared/constants.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Profile',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      await _auth.signOut().then((value) {
                        showSuccessSnackBar('Signed Out', context);
                      }).catchError((e) {
                        showFailedSnackBar(e.toString(), context);
                      });
                    },
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: Colors.blue,
                    ))
              ],
            ),
            backgroundColor: Colors.white,
            body: StreamBuilder<UserData>(
                stream: UserDatabaseService(uid: user!.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData? userData = snapshot.data;
                    return ListView(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 130,
                              width: MediaQuery.of(context).size.width,
                            ),
                            //blueContainer
                            Positioned(
                              top: 50.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.indigoAccent,
                                        Colors.lightBlue
                                      ]),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(45),
                                    bottomRight: Radius.circular(45),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    buildNameTitle(context, userData),
                                    buildGradientLine(Colors.white, Colors.blue),
                                    buildProfileInfo(
                                        context,
                                        userData!.user_email!,
                                        Icons.mail_sharp),
                                    buildGradientLine(Colors.white, Colors.blue),
                                    buildProfileInfo(
                                        context,
                                        userData.user_matricNo!,
                                        MdiIcons.cardAccountDetailsOutline),
                                    buildGradientLine(Colors.white, Colors.blue),
                                    buildProfileInfo(
                                        context,
                                        userData.user_HPno!,
                                        Icons.phone_android_outlined),
                                    buildGradientLine(Colors.white, Colors.blue),
                                    buildProfileInfo(
                                        context,
                                        userData.user_gender!,
                                        genderIcon(userData.user_gender!)),
                                    buildGradientLine(Colors.white, Colors.blue),
                                    buildProfileInfo(
                                        context,
                                        userData.user_dob!,
                                        Icons.date_range_outlined),
                                    buildGradientLine(Colors.white, Colors.blue),
                                    //address here
                                    buildProfileInfo(
                                        context,
                                        getAddress(userData),
                                        Icons.location_on_outlined),
                                  ],
                                ),
                              ),
                            ),
                            //avatar
                            Positioned(
                              top: 0.0,
                              child: buildProfileAvatar(userData),
                            ),
                          ],
                        )
                      ],
                    );
                  } else {
                    return loadingIndicator();
                  }
                }),
          );
  }

  IconData genderIcon(String gender) {
    if (gender.isNotEmpty) {
      if (gender == 'Male') {
        return MdiIcons.genderMale;
      } else {
        return MdiIcons.genderFemale;
      }
    }
    return MdiIcons.genderMaleFemale;
  }

  String getAddress(UserData userData) {
    List<String> values = [
      userData.user_addStreet1.toString(),
      userData.user_addStreet2.toString(),
      '${userData.user_addPostcode} ${userData.user_addCity}',
      userData.user_addState.toString()
    ];
    if (values.toSet().toList().toString() == '[,  ]') {
      return '';
    } else {
      String result = values.map((val) => val.trim()).join(',\n');
      return result;
    }
  }

  SizedBox buildProfileInfo(
      BuildContext context, String userData, IconData icon) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
          child: Row(children: [
            Icon(icon, color: Colors.white, size: 25),
            Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(userData,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))
          ])),
    );
  }

  SizedBox buildRowProfileInfo(
      BuildContext context, String userData, IconData icon) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
          child: Row(children: [
            Icon(icon, color: Colors.white, size: 25),
            Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(userData,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))
          ])),
    );
  }

  Container buildRow2ProfileInfo(
      BuildContext context, String userData, IconData icon) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5))),
      child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
          child: Row(children: [
            Icon(icon, color: Colors.white, size: 25),
            Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(userData,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))
          ])),
    );
  }

  Container buildNameTitle(BuildContext context, UserData? userData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 100),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 25, bottom: 10),
        child: Text('${userData!.user_name!} ${userData.user_lastName!}',
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }

  GestureDetector buildProfileAvatar(UserData? userData) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 60.0,
        child: CircleAvatar(
          backgroundImage: 
          userData!.user_photo!.isNotEmpty
              ? NetworkImage('${userData.user_photo}')
              : const AssetImage('assets/umt_logo.png') as ImageProvider,
          radius: 55.0,
          backgroundColor: Colors.white,
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
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                    child: Container(
                        height: 5.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.blue))),
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: const Text(
                      'Edit Profile Action',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Colors.blue),
                    ),
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
                            builder: (context) => const changeProfilePicture(),
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
            ],
          );
        });
  }

  Container _buildListItem(String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
