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
    if (events.isNotEmpty) {
      List<EventData> upcomingEvent = [];
      List<EventData> expiredEvent = [];
      for (var i = 0; i < events.length; i++) {
        //if the end time is before now (expired)
        if (DateTime.parse(events[i].event_end!).compareTo(DateTime.now()) <
            0) {
          expiredEvent.add(events[i]);
          expiredEvent.sort((a, b) {
            return b.event_end!.compareTo(a.event_end!);
          });
        } else {
          //if the end time is after now (upcoming)
          upcomingEvent.add(events[i]);
          upcomingEvent.sort((a, b) {
            return b.event_end!.compareTo(a.event_end!);
          });
        }
      }
      if (widget.isExpired) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: expiredEvent.length,
          itemBuilder: (context, index) {
            return EventTile(
                club_ID: widget.club_ID,
                eventData: expiredEvent[index],
                isExpired: widget.isExpired);
          },
        );
      } else {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: upcomingEvent.length,
          itemBuilder: (context, index) {
            return EventTile(
                club_ID: widget.club_ID,
                eventData: upcomingEvent[index],
                isExpired: widget.isExpired);
          },
        );
      }
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
