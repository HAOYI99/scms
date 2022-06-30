import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/event.dart';
import 'package:scms/screens/home/home_list.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/services/event_database.dart';
import 'package:scms/shared/constants.dart';

enum EventPostSwitch { discover, follow }

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  EventPostSwitch selectedEventSwitch = EventPostSwitch.discover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Event',
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
              value: EventDatabaseService().eventdata, initialData: []),
          StreamProvider<List<ClubData>>.value(
              value: ClubDatabaseService().clubdatalist, initialData: []),
          StreamProvider<List<RegisterData>>.value(
              value: EventDatabaseService().registerDatalist, initialData: []),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Row(
              //   children: <Widget>[
              //     ContainerSelection(
              //         context, EventPostSwitch.discover, 'Discover'),
              //     ContainerSelection(
              //         context, EventPostSwitch.follow, 'Followed'),
              //   ],
              // ),
              // buildGradientLine(
              //   selectedEventSwitch == EventPostSwitch.discover
              //       ? Colors.blue
              //       : Colors.white,
              //   selectedEventSwitch == EventPostSwitch.follow
              //       ? Colors.blue
              //       : Colors.white,
              // ),
              buildGradientLine(Colors.blue, Colors.indigo),
              Container(child: HomeList()),
              const SizedBox(height: 10.0)
            ],
          ),
        ),
      ),
    );
  }

  // Container ContainerSelection(
  //     BuildContext context, EventPostSwitch eventSwitch, String title) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius:
  //           const BorderRadius.vertical(top: Radius.elliptical(75, 150)),
  //       color: selectedEventSwitch == eventSwitch ? Colors.blue : Colors.white,
  //     ),
  //     width: MediaQuery.of(context).size.width * 0.5,
  //     child: TextButton(
  //         onPressed: () {
  //           setState(() => selectedEventSwitch = eventSwitch);
  //         },
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //               color: selectedEventSwitch == eventSwitch
  //                   ? Colors.white
  //                   : Colors.blue),
  //         )),
  //   );
  // }

  // Widget getCustomContainer() {
  //   switch (selectedEventSwitch) {
  //     case EventPostSwitch.discover:
  //       return HomeList();
  //     case EventPostSwitch.follow:
  //       return HomeList();
  //   }
  // }
}
