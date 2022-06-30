import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/access_right.dart';
import 'package:scms/models/club.dart';
import 'package:scms/screens/position/position_tile.dart';

class PositionList extends StatefulWidget {
  String club_ID;
  PositionList({Key? key, required this.club_ID}) : super(key: key);

  @override
  State<PositionList> createState() => _PositionListState();
}

class _PositionListState extends State<PositionList> {
  @override
  Widget build(BuildContext context) {
    final positions = Provider.of<List<PositionData>>(context);
    final accessList = Provider.of<List<accessRight>>(context);

    List<PositionData> positionList = [];
    accessRight accessData = accessRight();

    for (var i = 0; i < positions.length; i++) {
      if (positions[i].club_ID == widget.club_ID) {
        positionList.add(positions[i]);
        positionList.sort((a, b) {
          return a.seq_number!.compareTo(b.seq_number!);
        });
      }
    }
    for (var i = 0; i < positionList.length; i++) {
      for (var j = 0; j < accessList.length; j++) {
        if (positionList[i].position_ID == accessList[j].position_ID) {
          accessData = accessList[j];
        }
      }
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: positionList.length,
      itemBuilder: (context, index) {
        return PositionTile(
          accessData: getThisAccessRight(accessList, positionList[index]),
          club_ID: widget.club_ID,
          positionData: positionList[index],
        );
      },
    );
  }
  List<accessRight> getThisAccessRight(List<accessRight> accessList , PositionData positionData){
    List<accessRight> ThisAccessList = [];
    for (var i = 0; i < accessList.length; i++) {
      if(accessList.elementAt(i).position_ID == positionData.position_ID){
        ThisAccessList.add(accessList.elementAt(i));
      }
    }
    return ThisAccessList;
  }
}
