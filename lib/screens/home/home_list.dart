import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/event.dart';
import 'package:scms/screens/home/home_tile.dart';

class HomeList extends StatefulWidget {
  final bool isFollowed;
  HomeList({Key? key, required this.isFollowed}) : super(key: key);

  @override
  State<HomeList> createState() => HomeListState();
}

class HomeListState extends State<HomeList> {
  @override
  Widget build(BuildContext context) {
    // final events = Provider.of<List<EventData>>(context);

    // if (events.isNotEmpty) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return HomeTile();
        },
      );
    // } else {
    //   return Padding(
    //     padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
    //     child: const Text('No event posted yet',
    //         style: TextStyle(
    //             color: Colors.blue,
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20.0)),
    //   );
    // }
  }
}
