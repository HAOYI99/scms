import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/event.dart';
import 'package:scms/screens/event/event_tile.dart';

class EventList extends StatefulWidget {
  final String club_ID;
  final bool isExpired;
  EventList({Key? key, required this.isExpired, required this.club_ID})
      : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<EventData>>(context);
    events.sort((a, b) {
      return a.event_endTime!.compareTo(b.event_endTime!);
    });
    if (events.isNotEmpty) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventTile(
              club_ID: widget.club_ID,
              eventData: events[index],
              isExpired: widget.isExpired);
        },
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: const Text('No Event Posted Yet',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
      );
    }
  }
}
