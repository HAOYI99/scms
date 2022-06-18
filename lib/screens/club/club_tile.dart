import 'package:flutter/material.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/club/edit_club.dart';
import 'package:scms/screens/club/edit_clublogo.dart';
import 'package:scms/screens/club/manage_member.dart';
import 'package:scms/services/user_database.dart';
import 'package:scms/shared/constants.dart';

class ClubTile extends StatelessWidget {
  final ClubData clubData;
  final bool isMyClub;
  ClubTile({Key? key, required this.clubData, required this.isMyClub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.blue,
              child: CircleAvatar(
                backgroundImage: clubData.club_logo!.isNotEmpty
                    ? NetworkImage(clubData.club_logo!)
                    : const AssetImage('assets/logo.png') as ImageProvider,
                radius: 25.0,
                backgroundColor: Colors.white,
              ),
            ),
            title: Text(clubData.club_name!),
            subtitle: Text(clubData.club_ID!),
            iconColor: Colors.blue,
            trailing: isMyClub ? const Icon(Icons.edit) : null,
          ),
        ),
        onTap: () {
          if (isMyClub) {
            _showEditPanel(clubData, context);
          } else {
            _showClubInfo(clubData, context);
          }
        },
      ),
    );
  }

  void _showEditPanel(ClubData clubData, BuildContext context) {
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
                      padding:
                          const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                      child: Container(
                          height: 5.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0)))),
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
                      child: _buildListItem('Edit Club Info', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditClub(clubData: clubData),
                            ));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Change Club Logo', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  changeLogo(club_ID: clubData.club_ID!),
                            ));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Manage Committee Member', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageCommitteeMember()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Container _buildListItem(String text, BuildContext context) {
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

  void _showClubInfo(ClubData clubData, BuildContext context) {
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
                      padding:
                          const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                      child: Container(
                          height: 5.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0)))),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.blue))),
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        clubData.club_name!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18.0, color: Colors.blue),
                      ),
                    ),
                    Column(
                      children: [
                        Text('Desc : ${clubData.club_desc!}'),
                        Text('category : ${clubData.club_category!}'),
                        Text('email : ${clubData.club_email!}'),
                        Text('registerDate : ${clubData.club_registerDate!}'),
                        StreamBuilder<UserData>(
                            stream:
                                UserDatabaseService(uid: clubData.club_chairman)
                                    .userData,
                            builder: (context, snapshot) {
                              UserData? userData = snapshot.data;
                              if (userData != null) {
                                return Text('Chairman : ${userData.user_name!} ${userData.user_lastName!}');
                              }else{
                                return const Text('');
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
