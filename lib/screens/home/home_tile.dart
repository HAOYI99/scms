import 'package:flutter/material.dart';
import 'package:scms/models/event.dart';

class HomeTile extends StatefulWidget {
  HomeTile({Key? key}) : super(key: key);

  @override
  State<HomeTile> createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          print('test');
        },
        child: Card(
            elevation: 3.0,
            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  title: Text('Title'),
                  subtitle: Text('event time'),
                  iconColor: Colors.blue,
                ),
                Center(
                    child: Image.network(
                        'https://i.ytimg.com/vi/jz_DDcb0kog/maxresdefault.jpg',
                        height: 200,
                        fit: BoxFit.fill))
              ],
            )),
      ),
    );
  }
}
