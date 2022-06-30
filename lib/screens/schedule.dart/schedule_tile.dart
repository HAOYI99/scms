import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scms/models/event.dart';

class ScheduleTile extends StatelessWidget {
  EventData? eventData;
  RegisterData? registerData;
  ScheduleTile({Key? key, required this.eventData, required this.registerData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: ListTile(
            title: Text('${eventData?.event_title}'),
            subtitle: Text('Upcoming : ${DateFormat('dd-MMM-yyyy HH-mm').format(DateTime.parse(eventData!.event_start!))}\nEnd At : ${DateFormat('dd-MMM-yyyy HH-mm').format(DateTime.parse(eventData!.event_end!))}'),
            isThreeLine: true,
            iconColor: Colors.blue,
            // trailing: IconButton(
                // tooltip: 'Cancel Registration',
                // onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PositionForm(
                  //               club_ID: club_ID,
                  //               positionData: positionData,
                  //               accessData: accessData,
                  //               functionList: functionList,
                  //             )));
                // },
                // iconSize: 25,
                // icon: const Icon(Icons.delete_forever)),
          ),
        ),
      ),
    );
  }
}
