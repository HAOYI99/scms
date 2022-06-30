import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/committee/committee_tile.dart';

class CommitteeList extends StatefulWidget {
  final ClubData clubData;
  final bool isPending;
  CommitteeList({Key? key, required this.clubData, required this.isPending})
      : super(key: key);

  @override
  State<CommitteeList> createState() => _CommitteeListState();
}

class _CommitteeListState extends State<CommitteeList> {
  @override
  Widget build(BuildContext context) {
    final committee = Provider.of<List<CommitteeData>>(context);
    final positions = Provider.of<List<PositionData>>(context);
    final users = Provider.of<List<UserData>>(context);

    List<CommitteeData> committeeMember = [];
    List<CommitteeData> pendingRequest = [];
    for (var i = 0; i < committee.length; i++) {
      if (committee[i].isApproved == true &&
          committee[i].approved_by!.isNotEmpty) {
        committeeMember.add(committee[i]);
      } else {
        pendingRequest.add(committee[i]);
      }
    }
    if (widget.isPending) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pendingRequest.length,
        itemBuilder: (context, index) {
          return CommitteeTile(
              positionData: getPositionData(positions, pendingRequest[index]),
              clubPositionList: getClubPositionList(positions, widget.clubData),
              committeeData: pendingRequest[index],
              clubData: widget.clubData,
              userData: getUserdata(users, pendingRequest[index]),
              isPending: widget.isPending);
        },
      );
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: committeeMember.length,
        itemBuilder: (context, index) {
          return CommitteeTile(
              clubPositionList: getClubPositionList(positions, widget.clubData),
              positionData: getPositionData(positions, committeeMember[index]),
              committeeData: committeeMember[index],
              clubData: widget.clubData,
              userData: getUserdata(users, committeeMember[index]),
              isPending: widget.isPending);
        },
      );
    }
  }

  UserData getUserdata(List<UserData> users, CommitteeData committee) {
    for (var i = 0; i < users.length; i++) {
      if (users[i].user_ID == committee.user_ID) {
        return users[i];
      }
    }
    return UserData();
  }

  PositionData getPositionData(
      List<PositionData> positions, CommitteeData committeeData) {
    for (var i = 0; i < positions.length; i++) {
      if (positions[i].position_ID == committeeData.position_ID) {
        return positions[i];
      }
    }
    return PositionData();
  }

  List<PositionData> getClubPositionList(
      List<PositionData> positions, ClubData clubData) {
    List<PositionData> clubPositionList = [];
    for (var i = 0; i < positions.length; i++) {
      if (positions[i].club_ID == clubData.club_ID) {
        clubPositionList.add(positions[i]);
      }
    }
    return clubPositionList;
  }
}
