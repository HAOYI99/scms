import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scms/models/event.dart';
import 'package:scms/screens/event/edit_event.dart';
import 'package:scms/services/club_database.dart';
import 'package:scms/shared/constants.dart';

class EventTile extends StatelessWidget {
  final String club_ID;
  final EventData eventData;
  final bool isExpired;
  EventTile(
      {Key? key,
      required this.eventData,
      required this.isExpired,
      required this.club_ID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: ListTile(
            title: Text(eventData.event_title!),
            subtitle: Text(eventData.event_ID!),
            iconColor: Colors.blue,
            trailing: isExpired
                ? const Icon(Icons.expand_more)
                : const Icon(Icons.edit),
          ),
        ),
        onTap: () {
          if (isExpired) {
            // _showClubInfo(clubData, context);
          } else {
            _showEditPanel(eventData, context);
          }
        },
      ),
    );
  }

  Container _buildListItem(String text, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showEditPanel(EventData eventData, BuildContext context) {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (context) {
          return Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                      child: Container(
                          height: 5.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0)))),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.blue))),
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: const Text(
                        'Edit Event Action',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.blue),
                      ),
                    ),
                    InkWell(
                      child: _buildListItem('Edit Event Info', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditEvent(
                                    club_ID: club_ID, eventData: eventData)));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Delete Event', context),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title:
                                const Text('Are you sure you want to do this?'),
                            content:
                                const Text('This action is irreversible !'),
                            elevation: 3.0,
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    ClubDatabaseService(
                                            cid: club_ID,
                                            eid: eventData.event_ID)
                                        .deleteEventPost()
                                        .whenComplete(() {
                                      showFailedSnackBar(
                                          'Event Post Deleted !', context);
                                      Navigator.of(context).pop();
                                    }).catchError((e) => showFailedSnackBar(
                                            e.toString(), context));
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'))
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
