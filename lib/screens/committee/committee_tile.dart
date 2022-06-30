import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/committee/edit_committee.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

class CommitteeTile extends StatelessWidget {
  final ClubData clubData;
  final CommitteeData committeeData;
  final UserData userData;
  final bool isPending;
  final PositionData positionData;
  final List<PositionData> clubPositionList;
  CommitteeTile(
      {Key? key,
      required this.positionData,
      required this.committeeData,
      required this.clubData,
      required this.isPending,
      required this.userData,
      required this.clubPositionList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: ListTile(
              title: Text('${userData.user_name} ${userData.user_lastName}'),
              subtitle: Text('${positionData.position_name}'),
              iconColor: Colors.blue,
              trailing: isPending
                  ? Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      IconButton(
                          tooltip: 'Approve',
                          onPressed: () {
                            ClubDatabaseService(
                                    uid: user.uid,
                                    cmid: committeeData.committee_ID)
                                .approveRequestCM()
                                .whenComplete(() {
                              showSuccessSnackBar('Approved', context);
                            }).catchError((e) => showFailedSnackBar(
                                    'Could not Approve the member, please try again',
                                    context));
                          },
                          iconSize: 40,
                          icon: const Icon(Icons.check_circle_rounded,
                              color: Colors.green)),
                      const SizedBox(width: 10.0),
                      IconButton(
                          tooltip: 'Reject',
                          onPressed: () {
                            ClubDatabaseService(
                                    cmid: committeeData.committee_ID)
                                .rejectKickCM()
                                .whenComplete(() {
                              showNormalSnackBar('Rejected', context);
                            }).catchError((e) => showFailedSnackBar(
                                    'Could not Reject the member, please try again',
                                    context));
                          },
                          iconSize: 40,
                          icon: const Icon(Icons.cancel_rounded,
                              color: Colors.red)),
                    ])
                  : Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      IconButton(
                          tooltip: 'change position',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCommittee(
                                    positionList: clubPositionList,
                                    thisMemberData: committeeData,
                                    userData: userData,
                                  ),
                                ));
                          },
                          iconSize: 35,
                          icon:
                              const Icon(Icons.mode_edit, color: Colors.green)),
                      const SizedBox(width: 10.0),
                      IconButton(
                          iconSize: 35,
                          tooltip: 'kick member',
                          onPressed: () {
                            if (committeeData.user_ID ==
                                clubData.club_chairman) {
                              showFailedSnackBar(
                                  'Chairman cannot be kicked !', context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                      'This action is irreversible !'),
                                  content: const Text(
                                      'Are you sure you want to kick this member ?'),
                                  elevation: 3.0,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          ClubDatabaseService(
                                                  cmid: committeeData
                                                      .committee_ID)
                                              .rejectKickCM()
                                              .whenComplete(() {
                                            showFailedSnackBar(
                                                '${userData.user_name} has been Kicked !',
                                                context);
                                            Navigator.of(context).pop();
                                          }).catchError((e) => showFailedSnackBar(
                                                  'Could not Kick the member, please try again',
                                                  context));
                                        },
                                        child: const Text('Yes')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'))
                                  ],
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.group_off, color: Colors.red)),
                    ])),
        ),
        onTap: () {
          _showMemberInfo(context);
        },
      ),
    );
  }

  void _showMemberInfo(BuildContext context) {
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
                        '${userData.user_name} ${userData.user_lastName}',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 18.0, color: Colors.blue),
                      ),
                    ),
                    Column(
                      children: [],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
