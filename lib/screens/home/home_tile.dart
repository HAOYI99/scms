import 'package:flutter/material.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/event.dart';

class HomeTile extends StatelessWidget {
  final EventData eventData;
  final ClubData clubData;
  
  const HomeTile({Key? key, required this.eventData, required this.clubData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          
        },
        child: Card(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          ),
          elevation: 5.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    backgroundImage: clubData.club_logo != null
                        ? NetworkImage('${clubData.club_logo}')
                        : const AssetImage('assets/umt_logo.png')
                            as ImageProvider,
                    radius: 18.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                title: Text('${eventData.event_title}'),
                subtitle: Text('${clubData.club_email}'),
                iconColor: Colors.blue,
              ),
              Center(
                  child: Image.network('${eventData.event_poster}',
                      fit: BoxFit.fitWidth)),
            ],
          ),
        ),
      ),
    );
  }
}
