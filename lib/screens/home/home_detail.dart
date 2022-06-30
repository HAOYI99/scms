import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/event.dart';
import 'package:scms/models/user.dart';
import 'package:scms/services/event_database.dart';
import 'package:scms/shared/constants.dart';

class EventDetail extends StatefulWidget {
  final EventData eventData;
  final ClubData clubData;
  final bool isRegistered;
  final bool isRegistrationClosed;
  EventDetail(
      {Key? key,
      required this.eventData,
      required this.clubData,
      required this.isRegistered,
      required this.isRegistrationClosed})
      : super(key: key);

  @override
  State<EventDetail> createState() => EventDetailState();
}

class EventDetailState extends State<EventDetail> {
  bool isLoading = false;
  String buttonText = '';

  @override
  void initState() {
    super.initState();
    if (widget.isRegistrationClosed) {
      widget.isRegistered
          ? buttonText = 'Registered'
          : buttonText = 'Registration Closed';
    } else {
      widget.isRegistered
          ? buttonText = 'Registered'
          : buttonText = 'Register Now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: widget.eventData.event_poster!,
                        child: CachedNetworkImage(
                          imageUrl: widget.eventData.event_poster!,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 30),
                        ),
                      ),
                      Positioned(
                        top: 40.0,
                        right: 15.0,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.4),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Organizer : ${widget.clubData.club_name}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Contact Email : \n${widget.clubData.club_email}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.eventData.event_title}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Caption : \n${widget.eventData.event_caption}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Location : \n${widget.eventData.event_location}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Event Date : \n${DateFormat('dd-MMM-yyyy').format(DateTime.parse(widget.eventData.event_start!))} - ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(widget.eventData.event_end!))}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Event Time : \n${DateFormat('HH-mm').format(DateTime.parse(widget.eventData.event_start!))} - ${DateFormat('HH-mm').format(DateTime.parse(widget.eventData.event_end!))}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Target Audience : \n${widget.eventData.event_audience}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Number of Audience : \n${widget.eventData.event_numAudience}'),
                  ),
                  SizedBox(height: 80)
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ElevatedButton(
              onPressed: () async {
                if (widget.isRegistrationClosed) {
                  if (widget.isRegistered) {
                    showNormalSnackBar(
                        'You have registered this event', context);
                  } else {
                    showNormalSnackBar('Registration has closed', context);
                  }
                } else {
                  if (widget.isRegistered) {
                    showNormalSnackBar(
                        'You have registered this event', context);
                  } else {
                    setState(() => isLoading = true);
                    String registerTime = DateTime.now().toString();
                    dynamic result = EventDatabaseService(
                            eid: widget.eventData.event_ID, uid: user!.uid)
                        .registerEvent(registerTime)
                        .whenComplete(() {
                      showSuccessSnackBar('Registration Done !', context);
                      Navigator.of(context).pop();
                    }).catchError(
                            (e) => showFailedSnackBar(e.toString(), context));
                    if (result == null) {
                      showFailedSnackBar(
                          'Could not register the event, please try again',
                          context);
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              child: Text(
                buttonText,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}
