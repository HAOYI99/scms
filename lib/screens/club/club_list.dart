import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/screens/club/club_tile.dart';

class ClubList extends StatefulWidget {
  final bool isMyClub;
  ClubList({Key? key, required this.isMyClub}) : super(key: key);

  @override
  State<ClubList> createState() => _ClubListState();
}

class _ClubListState extends State<ClubList> {
  @override
  Widget build(BuildContext context) {
    final clubs = Provider.of<List<ClubData>>(context);
    clubs.sort((a, b) {
      return a.club_name!.toLowerCase().compareTo(b.club_name!.toLowerCase());
    });
    if (clubs.isNotEmpty) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          return ClubTile(clubData: clubs[index], isMyClub: widget.isMyClub);
        },
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: const Text('No Club',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
      );
    }
  }
}
