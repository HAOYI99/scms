import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/event.dart';

//clubs/{clubID}/events/{eventID}
class EventDatabaseService {
  final String? eid;
  final String? cid;
  EventDatabaseService({this.eid, this.cid});

  //collection reference
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  //get event stream
  Stream<List<EventData>> get eventdata {
    return eventCollection
        .where('club_ID', isEqualTo: cid)
        .snapshots()
        .map(_eventListFromSnapshot);
  }

  List<EventData> _eventListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return EventData(
          event_ID: doc.id,
          event_title: doc.get('event_title'),
          event_caption: doc.get('event_caption'),
          event_location: doc.get('event_location'),
          event_start: doc.get('event_start'),
          event_end: doc.get('event_end'),
          event_audience: doc.get('event_audience'),
          event_numAudience: doc.get('event_numAudience'),
          event_poster: doc.get('event_poster'),
          club_ID: doc.get('club_ID'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future createEvents(
      EventData eventData, File? image, BuildContext buildContext) async {
    DocumentReference eventDocument = eventCollection.doc();
    return await eventDocument.set({
      'event_title': eventData.event_title,
      'event_caption': eventData.event_caption,
      'event_location': eventData.event_location,
      'event_start': eventData.event_start,
      'event_end': eventData.event_end,
      'event_audience': eventData.event_audience,
      'event_numAudience': eventData.event_numAudience,
      'event_poster': '',
      'club_ID': cid,
    }).then((value) => uploadEventPost(image, buildContext, eventDocument.id));
  }

  Future updateEventData(
      EventData eventData, File? image, BuildContext buildContext) async {
    if (image != null) {
      return await eventCollection.doc(eid).update({
        'event_title': eventData.event_title,
        'event_caption': eventData.event_caption,
        'event_location': eventData.event_location,
        'event_start': eventData.event_start,
        'event_end': eventData.event_end,
        'event_audience': eventData.event_audience,
        'event_numAudience': eventData.event_numAudience,
      }).then((value) => uploadEventPost(image, buildContext, eid!));
    } else {
      return await eventCollection.doc(eid).update({
        'event_title': eventData.event_title,
        'event_caption': eventData.event_caption,
        'event_location': eventData.event_location,
        'event_start': eventData.event_start,
        'event_end': eventData.event_end,
        'event_audience': eventData.event_audience,
        'event_numAudience': eventData.event_numAudience,
      });
    }
  }

  Future uploadEventPost(File? image, BuildContext context, String id) async {
    if (cid != null) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('clubs')
          .child('${cid!}/event')
          .child("post_$postID");

      await ref.putFile(image!);
      String eventPoster = await ref.getDownloadURL();

      //upload url to cloudfirestore
      await firebaseFirestore
          .collection('events')
          .doc(id)
          .update({'event_poster': eventPoster});
    } else {
      return null;
    }
  }

  Future deleteEventPost() async {
    DocumentReference eventDocument = eventCollection.doc(eid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(eventDocument));
  }
}
