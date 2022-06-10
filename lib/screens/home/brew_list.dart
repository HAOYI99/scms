import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/brew.dart';
import 'package:scms/screens/home/brew_tile.dart';

class BrewList extends StatefulWidget {
  BrewList({Key? key}) : super(key: key);

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<Brew>>(context);

    return ListView.builder(
      itemCount: brews.length,
      itemBuilder:(context, index) {
        return BrewTile(brew: brews[index]);
      }, 
    );
  }
}
