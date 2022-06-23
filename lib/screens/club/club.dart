import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/club/club_list.dart';
import 'package:scms/screens/club/register_club.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

enum ClubSwitch { allclub, myclub }

class Club extends StatefulWidget {
  Club({Key? key}) : super(key: key);

  @override
  State<Club> createState() => _ClubState();
}

class _ClubState extends State<Club> {
  ClubSwitch selectedClubSwitch = ClubSwitch.allclub;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Club',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              tooltip: 'Register Club',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterClub(),
                    ));
              },
              icon: const Icon(
                MdiIcons.feather,
                color: Colors.blue,
              ))
        ],
      ),
      body: MultiProvider(
        providers: [
          StreamProvider<List<ClubData>>.value(
              initialData: [],
              value: (selectedClubSwitch == ClubSwitch.allclub)
                  ? ClubDatabaseService().clubdatalist
                  : ClubDatabaseService(uid: user!.uid).clubdatalist),
          StreamProvider<List<CommitteeData>>.value(
              value: ClubDatabaseService().committeeDatalist, initialData: []),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  ContainerSelection(context, ClubSwitch.allclub, 'All Club'),
                  ContainerSelection(context, ClubSwitch.myclub, 'My Club'),
                ],
              ),
              buildGradientLine(
                selectedClubSwitch == ClubSwitch.allclub
                    ? Colors.blue
                    : Colors.white,
                selectedClubSwitch == ClubSwitch.myclub
                    ? Colors.blue
                    : Colors.white,
              ),
              Container(child: getCustomContainer()),
              const SizedBox(height: 10.0)
            ],
          ),
        ),
      ),
    );
  }

  Container ContainerSelection(
      BuildContext context, ClubSwitch whichClub, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.vertical(top: Radius.elliptical(75, 150)),
        color: selectedClubSwitch == whichClub ? Colors.blue : Colors.white,
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextButton(
          onPressed: () {
            setState(() => selectedClubSwitch = whichClub);
          },
          child: Text(
            title,
            style: TextStyle(
                color: selectedClubSwitch == whichClub
                    ? Colors.white
                    : Colors.blue),
          )),
    );
  }

  Widget getCustomContainer() {
    switch (selectedClubSwitch) {
      case ClubSwitch.allclub:
        return ClubList(isMyClub: false);
      case ClubSwitch.myclub:
        return ClubList(isMyClub: true);
    }
  }
}
