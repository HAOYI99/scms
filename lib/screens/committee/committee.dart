import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/committee.dart';
import 'package:scms/services/committee_database.dart';
import 'package:scms/shared/constants.dart';

enum CommitteeSwitch { member, pending }

class Committee extends StatefulWidget {
  ClubData clubData;
  Committee({Key? key, required this.clubData}) : super(key: key);

  @override
  State<Committee> createState() => _CommitteeState();
}

class _CommitteeState extends State<Committee> {
  CommitteeSwitch selectedCommitteeSwitch = CommitteeSwitch.member;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CommitteeData>>.value(
      initialData: [],
      value: CommitteeDatabaseService(cid: widget.clubData.club_ID).committeedata,
      child: Scaffold(
        appBar: buildAppBar(context, 'Committee'),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  ContainerSelection(context, CommitteeSwitch.member, 'Members'),
                  ContainerSelection(context, CommitteeSwitch.pending, 'Request'),
                ],
              ),
              buildGradientLine(
                selectedCommitteeSwitch == CommitteeSwitch.member
                    ? Colors.blue
                    : Colors.white,
                selectedCommitteeSwitch == CommitteeSwitch.pending
                    ? Colors.blue
                    : Colors.white,
              ),
              Container(child: getCustomContainer())
            ],
          ),
        ),
      ),
    );
  }

  Container ContainerSelection(
      BuildContext context, CommitteeSwitch committeeSwitch, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.vertical(top: Radius.elliptical(75, 150)),
        color: selectedCommitteeSwitch == committeeSwitch
            ? Colors.blue
            : Colors.white,
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextButton(
          onPressed: () {
            setState(() => selectedCommitteeSwitch = committeeSwitch);
          },
          child: Text(
            title,
            style: TextStyle(
                color: selectedCommitteeSwitch == committeeSwitch
                    ? Colors.white
                    : Colors.blue),
          )),
    );
  }

  Widget getCustomContainer() {
    switch (selectedCommitteeSwitch) {
      case CommitteeSwitch.member:
      // return EventList(club_ID: widget.clubData.club_ID!, isExpired: false);
      case CommitteeSwitch.pending:
      // return EventList(club_ID: widget.clubData.club_ID!, isExpired: true);
    }
    return Container();
  }
}
