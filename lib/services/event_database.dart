import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/event.dart';

class EventDatabaseService {
  final String? eid;
  final String? cid;
  final String? uid;
  final String? rid;
  EventDatabaseService({this.eid, this.cid, this.uid, this.rid});

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
    }).then((value) async {
      await uploadEventPost(image, buildContext, eventDocument.id);
    });
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
      }).then((value) async {
        await uploadEventPost(image, buildContext, eid!);
      });
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
          .child(id)
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

  //registration.......................................................

  final CollectionReference registerCollection =
      FirebaseFirestore.instance.collection('registers');

  Future registerEvent(String register_time) async {
    return await registerCollection.doc().set({
      'event_ID': eid,
      'user_ID': uid,
      'register_time': register_time,
    });
  }

  Future cancelRegistration() async {
    DocumentReference registerDocument = registerCollection.doc(rid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(registerDocument));
  }

  RegisterData _registerDataFromSnapshot(DocumentSnapshot snapshot) {
    return RegisterData(
      register_ID: rid,
      event_ID: snapshot['event_ID'],
      user_ID: snapshot['user_ID'],
      register_time: snapshot['register_time'],
    );
  }

  List<RegisterData> _registerListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return RegisterData(
          register_ID: doc.id,
          event_ID: doc.get('event_ID'),
          user_ID: doc.get('user_ID'),
          register_time: doc.get('register_time'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<RegisterData>> get registerDatalist {
    return registerCollection.snapshots().map(_registerListFromSnapshot);
  }

  Stream<RegisterData> get registerdata {
    return registerCollection
        .doc(rid)
        .snapshots()
        .map(_registerDataFromSnapshot);
  }
}
