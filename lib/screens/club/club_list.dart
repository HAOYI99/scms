import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final user = Provider.of<thisUser>(context);

    if (clubs.isNotEmpty) {
      clubs.sort((a, b) {
        return a.club_name!.toLowerCase().compareTo(b.club_name!.toLowerCase());
      });
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          return ClubTile(
            clubData: clubs[index],
            isMyClub: widget.isMyClub,
            isRequested: isRequested(committee, clubs[index], user),
            isJoined: isJoined(committee, clubs[index], user),
          );
        },
      );
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

  bool? isJoined(
      List<CommitteeData> committeeData, ClubData clubData, thisUser user) {
    for (var i = 0; i < committeeData.length; i++) {
      if (clubData.club_ID == committeeData[i].club_ID &&
          committeeData[i].user_ID == user.uid) {
        return committeeData[i].isApproved;
      }
    }
    return false;
  }
}
