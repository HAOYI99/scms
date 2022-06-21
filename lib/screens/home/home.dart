import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/screens/home/home_list.dart';
import 'package:scms/shared/constants.dart';

enum EventPostSwitch { discover, follow }

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  EventPostSwitch selectedEventSwitch = EventPostSwitch.discover;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return isLoading
        ? loadingIndicator()
        : Scaffold(
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      ContainerSelection(
                          context, EventPostSwitch.discover, 'Discover'),
                      ContainerSelection(
                          context, EventPostSwitch.follow, 'Followed'),
                    ],
                  ),
                  buildGradientLine(
                    selectedEventSwitch == EventPostSwitch.discover
                        ? Colors.blue
                        : Colors.white,
                    selectedEventSwitch == EventPostSwitch.follow
                        ? Colors.blue
                        : Colors.white,
                  ),
                  Container(child: getCustomContainer()),
                  const SizedBox(height: 10.0)
                ],
              ),
            ),
          );
  }

  Container ContainerSelection(
      BuildContext context, EventPostSwitch eventSwitch, String title) {
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
      case EventPostSwitch.discover:
        return HomeList(isFollowed: false);
      case EventPostSwitch.follow:
        return HomeList(isFollowed: true);
    }
  }
}
