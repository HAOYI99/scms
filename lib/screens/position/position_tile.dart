import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/access_right.dart';
import 'package:scms/models/club.dart';
import 'package:scms/screens/position/position_form.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

class PositionTile extends StatelessWidget {
  final String club_ID;
  final PositionData positionData;
  final List<accessRight>? accessData;
  PositionTile({
    Key? key,
    required this.club_ID,
    required this.positionData,
    required this.accessData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final functionList = Provider.of<List<function>>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: ListTile(
              title: Text('${positionData.position_name}'),
              iconColor: Colors.blue,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                    tooltip: 'Edit Position',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PositionForm(
                                    club_ID: club_ID,
                                    positionData: positionData,
                                    accessData: accessData,
                                    functionList: functionList,
                                  )));
                    },
                    iconSize: 25,
                    icon: const Icon(Icons.mode_edit)),
                const SizedBox(width: 10.0),
                IconButton(
                    iconSize: 25,
                    tooltip: 'Delete Position',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Are you Sure?'),
                          elevation: 3.0,
                          actions: [
                            TextButton(
                                onPressed: () {
                                  ClubDatabaseService(
                                          pid: positionData.position_ID)
                                      .deletePosition()
                                      .whenComplete(() {
                                    showFailedSnackBar(
                                        'Position Deleted', context);
                                    Navigator.of(context).pop();
                                  }).catchError((e) => showFailedSnackBar(
                                          e.toString(), context));
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
                    },
                    icon: const Icon(Icons.delete, color: Colors.red)),
              ])),
        ),
        onTap: () {},
      ),
    );
  }
}
