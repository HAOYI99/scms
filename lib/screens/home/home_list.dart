import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/event.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/home/home_tile.dart';

class HomeList extends StatefulWidget {
  HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => HomeListState();
}

class HomeListState extends State<HomeList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<EventData>>(context);
    final clubs = Provider.of<List<ClubData>>(context);
    final registerData = Provider.of<List<RegisterData>>(context);
    final user = Provider.of<thisUser>(context);

    if (events.isNotEmpty) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: events.length,
        itemBuilder: (context, index) {
          events.sort((a, b) {
            return b.event_end!.compareTo(a.event_end!);
          });
          return HomeTile(
            eventData: events[index],
            clubData: getTheClub(clubs, events[index]),
            isRegistered: isRegistered(registerData, events[index], user),
            isRegistrationClosed:
                isRegistrationClosed(registerData, events[index]),
          );
        },
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: const Text('No Event posted yet',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
      );
    }
  }

  ClubData getTheClub(List<ClubData> clubs, EventData event) {
    ClubData theClub = ClubData();
    for (var i = 0; i < clubs.length; i++) {
      if (event.club_ID == clubs[i].club_ID) {
        return clubs[i];
      }
    }
    return theClub;
  }

  bool isRegistered(
      List<RegisterData> registerData, EventData event, thisUser user) {
    for (var i = 0; i < registerData.length; i++) {
      if (event.event_ID == registerData[i].event_ID &&
          registerData[i].user_ID == user.uid) {
        return true;
      }
    }
    return false;
  }

  bool isRegistrationClosed(List<RegisterData> registerData, EventData event) {
    var count = 0;
    var numAudience = event.event_numAudience?.toInt() ?? 0;
    for (var i = 0; i < registerData.length; i++) {
      if (event.event_ID == registerData[i].event_ID) {
        count++;
      }
    }
    if (count < numAudience) {
      if (DateTime.parse(event.event_end!).compareTo(DateTime.now()) < 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
