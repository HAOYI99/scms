import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/access_right.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/club/club_tile.dart';

class ClubList extends StatefulWidget {
  final bool isMyClub;
  ClubList({Key? key, required this.isMyClub}) : super(key: key);

  @override
  State<ClubList> createState() => _ClubListState();
}

class _ClubListState extends State<ClubList> {
  @override
  Widget build(BuildContext context) {
    final clubs = Provider.of<List<ClubData>>(context);
    final committee = Provider.of<List<CommitteeData>>(context);
    final position = Provider.of<List<PositionData>>(context);
    final accessRightList = Provider.of<List<accessRight>>(context);
    final functionList = Provider.of<List<function>>(context);
    final user = Provider.of<thisUser>(context);

    if (clubs.isNotEmpty) {
      List<ClubData> myclublist = [];
      for (var i = 0; i < clubs.length; i++) {
        for (var j = 0; j < committee.length; j++) {
          if (clubs[i].club_ID == committee[j].club_ID &&
              committee[j].user_ID == user.uid &&
              committee[j].isApproved == true) {
            myclublist.add(clubs[i]);
            myclublist.sort((a, b) {
              return b.club_name!.compareTo(a.club_name!);
            });
          }
        }
      }

      clubs.sort((a, b) {
        return b.club_name!.compareTo(a.club_name!);
      });
      if (widget.isMyClub) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: myclublist.length,
          itemBuilder: (context, index) {
            return ClubTile(
              memberID: getMemberID(position, myclublist[index]),
              clubData: myclublist[index],
              isMyClub: widget.isMyClub,
              // accessLimitData: getAccessRight(myclublist[index], committee, user, position, accessRightList, functionList),
              isRequested: isRequested(committee, myclublist[index], user),
              isJoined: isJoined(committee, myclublist[index], user),
            );
          },
        );
      } else {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: clubs.length,
          itemBuilder: (context, index) {
            return ClubTile(
              memberID: getMemberID(position, clubs[index]),
              clubData: clubs[index],
              isMyClub: widget.isMyClub,
              // accessLimitData: getAccessRight(clubs[index], committee, user, position, accessRightList, functionList),
              isRequested: isRequested(committee, clubs[index], user),
              isJoined: isJoined(committee, clubs[index], user),
            );
          },
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: const Text('No Club',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
      );
    }
  }

  bool isRequested(
      List<CommitteeData> committeeData, ClubData clubData, thisUser user) {
    for (var i = 0; i < committeeData.length; i++) {
      if (clubData.club_ID == committeeData[i].club_ID &&
          committeeData[i].user_ID == user.uid) {
        return true;
      }
    }
    return false;
  }

  bool isJoined(
      List<CommitteeData> committeeData, ClubData clubData, thisUser user) {
    bool isJoined = false;
    for (var i = 0; i < committeeData.length; i++) {
      if (clubData.club_ID == committeeData[i].club_ID &&
          committeeData[i].user_ID == user.uid) {
        return isJoined = committeeData[i].isApproved!;
      }
    }
    return isJoined;
  }

  String getMemberID(List<PositionData> positions, ClubData clubData) {
    String memberID = '';
    if (positions.isNotEmpty) {
      positions.sort((a, b) => a.seq_number!.compareTo(b.seq_number!));
      memberID = positions[positions.length - 1].position_ID!;
      return memberID;
    } else {
      return memberID;
    }
  }

  accessLimit getAccessRight(
      ClubData clubData,
      List<CommitteeData> cmData,
      thisUser user,
      List<PositionData> postionData,
      List<accessRight> accessRightList,
      List<function> functionList) {
    List<CommitteeData> myCom = [];
    for (var i = 0; i < cmData.length; i++) {
      if (clubData.club_ID == cmData[i].club_ID &&
          cmData[i].user_ID == user.uid) {
        //get joined position id
        var currentAccessRight = accessRightList
            .where((r) => r.position_ID == cmData[i].position_ID)
            .toList();
        for (var i = 0; i < currentAccessRight.length; i++) {
          var function = functionList
              .where((r) => r.function_ID == currentAccessRight[i].function_ID)
              .first;
          return accessLimit(
              function_name: function.function_name,
              access_right_code: currentAccessRight[i].access_right_code);
        }
      }
    }
    return accessLimit();
  }
}
