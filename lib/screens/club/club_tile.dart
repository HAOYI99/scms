import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/access_right.dart';
import 'package:scms/models/access_right.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/club/edit_club.dart';
import 'package:scms/screens/committee/committee.dart';
import 'package:scms/screens/event/event.dart';
import 'package:scms/screens/position/position.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/services/user_database.dart';
import 'package:scms/shared/constants.dart';

class ClubTile extends StatelessWidget {
  final ClubData clubData;
  final bool isMyClub;
  final bool isRequested;
  final bool isJoined;
  final String memberID;
  // final accessLimit accessLimitData;
  ClubTile(
      {Key? key,
      required this.clubData,
      required this.isMyClub,
      required this.isRequested,
      required this.isJoined,
      required this.memberID,
      // required this.accessLimitData
      })
      : super(key: key);

  String buttonText = '';
  @override
  Widget build(BuildContext context) {
    if (isRequested) {
      isJoined ? buttonText = 'Joined' : buttonText = 'Requested';
    } else {
      buttonText = 'Join';
    }
    final user = Provider.of<thisUser>(context);
    final functionList = Provider.of<List<function>>(context);

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
                    : const AssetImage('assets/umt_logo.png') as ImageProvider,
                radius: 25.0,
                backgroundColor: Colors.white,
              ),
            ),
            title: Text(clubData.club_name!),
            subtitle: Text(clubData.club_ID!),
            iconColor: Colors.blue,
            trailing: isMyClub
                ? const Icon(Icons.edit)
                : const Icon(Icons.expand_more),
          ),
        ),
        onTap: () {
          if (isMyClub) {
            _showEditPanel(clubData, context, functionList);
          } else {
            _showClubInfo(clubData, user, context, isJoined, isRequested);
          }
        },
      ),
    );
  }

  void _showEditPanel(
      ClubData clubData, BuildContext context, List<function> functionList) {
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
                        'Edit Club Action',
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
                      child: _buildListItem('Manage Event', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Event(clubData: clubData)));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Manage Committee', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Committee(clubData: clubData)));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Manage Position', context),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Position(
                                  clubData: clubData,
                                  functionList: functionList),
                            ));
                      },
                    )
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

  void _showClubInfo(ClubData clubData, thisUser user, BuildContext context,
      bool? isJoined, bool isRequested) {
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
                        style:
                            const TextStyle(fontSize: 18.0, color: Colors.blue),
                      ),
                    ),
                    Column(
                      //mediaquery.of(context).size.width
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                            border: TableBorder.symmetric(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: IntrinsicColumnWidth(),
                              2: IntrinsicColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(children: <Widget>[
                                Text('Category'),
                                Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: 15,
                                    child: Text(':')),
                                Text(clubData.club_category!)
                              ]),
                              TableRow(children: <Widget>[
                                Text('Registration Date'),
                                Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: 15,
                                    child: Text(':')),
                                Text(DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(
                                        clubData.club_registerDate!)))
                              ]),
                              TableRow(children: <Widget>[
                                Text('Description'),
                                Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: 15,
                                    child: Text(':')),
                                Text(clubData.club_desc!)
                              ]),
                              TableRow(children: <Widget>[
                                Text('Email'),
                                Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: 15,
                                    child: Text(':')),
                                Text(clubData.club_email!)
                              ]),
                              TableRow(children: <Widget>[
                                Text('Chairman'),
                                Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: 15,
                                    child: Text(':')),
                                StreamBuilder<UserData>(
                                    stream: UserDatabaseService(
                                            uid: clubData.club_chairman)
                                        .userData,
                                    builder: (context, snapshot) {
                                      UserData? userData = snapshot.data;
                                      if (userData != null) {
                                        return Text(
                                            '${userData.user_name!} ${userData.user_lastName!}');
                                      } else {
                                        return const Text('');
                                      }
                                    })
                              ])
                            ]),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (isRequested) {
                          if (isJoined!) {
                            Navigator.of(context).pop();
                            showSuccessSnackBar(
                                'You are one of the member !', context);
                          } else {
                            Navigator.of(context).pop();
                            showNormalSnackBar(
                                'Already requested, please wait for their response',
                                context);
                          }
                        } else {
                          dynamic result = ClubDatabaseService(
                                  cid: clubData.club_ID, uid: user.uid)
                              .requestJoinClub(memberID)
                              .whenComplete(() {
                            showSuccessSnackBar('Request Sent !', context);
                            Navigator.of(context).pop();
                          }).catchError((e) =>
                                  showFailedSnackBar(e.toString(), context));
                          if (result == null) {
                            showFailedSnackBar(
                                'Could not join the club, please try again',
                                context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.9, 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
