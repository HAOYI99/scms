import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/event.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/schedule.dart/schedule_tile.dart';

class ScheduleList extends StatefulWidget {
  ScheduleList({Key? key}) : super(key: key);

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  @override
  Widget build(BuildContext context) {
    final registerData = Provider.of<List<RegisterData>>(context);
    final events = Provider.of<List<EventData>>(context);
    final user = Provider.of<thisUser>(context);
    if (registerData.isNotEmpty) {
      List<RegisterData> myRegisterData = [];
      for (var i = 0; i < registerData.length; i++) {
        if (registerData[i].user_ID == user.uid) {
          myRegisterData.add(registerData[i]);
        }
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: myRegisterData.length,
        itemBuilder: (context, index) {
          events.sort((a, b) {
            return b.event_start!.compareTo(a.event_start!);
          });
          return ScheduleTile(
            eventData: getEventData(registerData[index], events),
            registerData: myRegisterData[index],
          );
        },
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: const Text('No Registered Event yet',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
      );
    }
  }

  EventData getEventData(RegisterData registerData, List<EventData> events) {
    for (var i = 0; i < events.length; i++) {
      if (registerData.event_ID == events[i].event_ID) {
        return events[i];
      }
    }
    return EventData();
  }
}
