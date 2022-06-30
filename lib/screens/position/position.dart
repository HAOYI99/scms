import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/access_right.dart';
import 'package:scms/models/club.dart';
import 'package:scms/screens/position/position_form.dart';
import 'package:scms/screens/position/position_list.dart';
import 'package:scms/services/access_right_database.dart';
import 'package:scms/services/club_database.dart';

class Position extends StatefulWidget {
  final ClubData clubData;
  final List<function> functionList;
  Position({Key? key, required this.clubData, required this.functionList})
      : super(key: key);

  @override
  State<Position> createState() => _PositionState();
}

class _PositionState extends State<Position> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<PositionData>>.value(
          initialData: [],
          value: ClubDatabaseService().positionDataList,
        ),
        StreamProvider<List<accessRight>>.value(
          initialData: [],
          value: AccessRightDatabaseService().accessdatalist,
        ),
        StreamProvider<List<function>>.value(
          initialData: [],
          value: AccessRightDatabaseService().functionlist,
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("${widget.clubData.club_name}'s Structure",
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
          actions: [
            IconButton(
                tooltip: 'Add Club Structure',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PositionForm(
                                club_ID: widget.clubData.club_ID!, functionList: widget.functionList,
                              )));
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.blue,
                ))
          ],
        ),
        body: PositionList(club_ID: widget.clubData.club_ID!),
      ),
    );
  }
}
