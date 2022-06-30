import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/event.dart';
import 'package:scms/screens/schedule.dart/schedule_list.dart';
import 'package:scms/services/event_database.dart';

class Schedule extends StatefulWidget {
  Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Schedule',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: MultiProvider(
        providers: [
          StreamProvider<List<EventData>>.value(
              initialData: [], value: EventDatabaseService().eventdata),
          StreamProvider<List<RegisterData>>.value(
              initialData: [], value: EventDatabaseService().registerDatalist),
        ],
        child: SingleChildScrollView(
          child: Center(child: ScheduleList()),
        ),
      ),
    );
  }
}
