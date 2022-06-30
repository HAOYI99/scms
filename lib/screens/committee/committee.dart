import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/committee/committee_list.dart';
import 'package:scms/screens/position/position.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/services/user_database.dart';
import 'package:scms/shared/constants.dart';

enum CommitteeSwitch { member, pending }

class Committee extends StatefulWidget {
  ClubData clubData;
  Committee({Key? key, required this.clubData}) : super(key: key);

  @override
  State<Committee> createState() => _CommitteeState();
}

class _CommitteeState extends State<Committee> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CommitteeSwitch selectedCommitteeSwitch = CommitteeSwitch.member;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.clubData.club_name}'s Committee Member",
            overflow: TextOverflow.clip,
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
        ),
      ),
      backgroundColor: Colors.white,
      body: MultiProvider(
        providers: [
          StreamProvider<List<CommitteeData>>.value(
              initialData: [],
              value: ClubDatabaseService(cid: widget.clubData.club_ID)
                  .committeeDatalist),
          StreamProvider<List<UserData>>.value(
              initialData: [], value: UserDatabaseService().userDataList),
          StreamProvider<List<PositionData>>.value(
              initialData: [], value: ClubDatabaseService().positionDataList),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  ContainerSelection(
                      context, CommitteeSwitch.member, 'Members'),
                  ContainerSelection(
                      context, CommitteeSwitch.pending, 'Request'),
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
        return CommitteeList(clubData: widget.clubData, isPending: false);
      case CommitteeSwitch.pending:
        return CommitteeList(clubData: widget.clubData, isPending: true);
    }
  }
}
