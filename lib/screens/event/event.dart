import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/event.dart';
import 'package:scms/screens/event/event_list.dart';
import 'package:scms/screens/event/register_event.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

enum EventSwitch { upcoming, expired }

class Event extends StatefulWidget {
  String club_ID;
  Event({Key? key, required this.club_ID}) : super(key: key);

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  EventSwitch selectedEventSwitch = EventSwitch.upcoming;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<EventData>>.value(
      initialData: [],
      value: ClubDatabaseService(cid: widget.club_ID).eventdata,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Club's Events",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0)),
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
                tooltip: 'Create New Event',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateEvents(club_ID: widget.club_ID),
                      ));
                },
                icon: const Icon(
                  Icons.post_add,
                  color: Colors.blue,
                ))
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  ContainerSelection(
                      context, EventSwitch.upcoming, 'Upcoming Events'),
                  ContainerSelection(
                      context, EventSwitch.expired, 'Expired Event'),
                ],
              ),
              buildGradientLine(
                selectedEventSwitch == EventSwitch.upcoming
                    ? Colors.blue
                    : Colors.white,
                selectedEventSwitch == EventSwitch.expired
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
      BuildContext context, EventSwitch eventSwitch, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.vertical(top: Radius.elliptical(75, 150)),
        color: selectedEventSwitch == eventSwitch ? Colors.blue : Colors.white,
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextButton(
          onPressed: () {
            setState(() => selectedEventSwitch = eventSwitch);
          },
          child: Text(
            title,
            style: TextStyle(
                color: selectedEventSwitch == eventSwitch
                    ? Colors.white
                    : Colors.blue),
          )),
    );
  }

  Widget getCustomContainer() {
    switch (selectedEventSwitch) {
      case EventSwitch.upcoming:
        return EventList(club_ID: widget.club_ID, isExpired: false);
      case EventSwitch.expired:
        return EventList(club_ID: widget.club_ID, isExpired: true);
    }
  }
}
