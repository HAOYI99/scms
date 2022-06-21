import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/club.dart';
import 'package:scms/models/event.dart';

class ClubDatabaseService {
  final String? uid;
  final String? cid;
  final String? eid;
  ClubDatabaseService({this.uid, this.cid, this.eid});

  //collection reference
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');

  Future createClubData(ClubData clubData) async {
    return await clubCollection.doc().set({
      'club_name': clubData.club_name,
      'club_email': clubData.club_email,
      'club_desc': clubData.club_desc,
      'club_category': clubData.club_category,
      'club_registerDate': clubData.club_registerDate,
      'club_chairman': clubData.club_chairman,
      'club_logo': '',
    });
  }

  Future createEvents(
      EventData eventData, File? image, BuildContext buildContext) async {
    DocumentReference eventDocument =
        clubCollection.doc(cid).collection('events').doc();
    return await eventDocument.set({
      'event_title': eventData.event_title,
      'event_caption': eventData.event_caption,
      'event_location': eventData.event_location,
      'event_startDate': eventData.event_startDate,
      'event_endDate': eventData.event_endDate,
      'event_startTime': eventData.event_startTime,
      'event_endTime': eventData.event_endTime,
      'event_audience': eventData.event_audience,
      'event_numAudience': eventData.event_numAudience,
      'event_poster': '',
    }).then((value) => uploadEventPost(image, buildContext, eventDocument.id));
  }

  Future updateClubData(ClubData clubData) async {
    return await clubCollection.doc(clubData.club_ID).update({
      'club_name': clubData.club_name,
      'club_email': clubData.club_email,
      'club_desc': clubData.club_desc,
      'club_category': clubData.club_category,
    });
  }

  Future deleteEventPost() async {
    DocumentReference eventDocument =
        clubCollection.doc(cid).collection('events').doc(eid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(eventDocument));
  }

  Future updateEventData(
      EventData eventData, File? image, BuildContext buildContext) async {
    return await clubCollection.doc(cid).collection('events').doc(eid).update({
      'event_title': eventData.event_title,
      'event_caption': eventData.event_caption,
      'event_location': eventData.event_location,
      'event_startDate': eventData.event_startDate,
      'event_endDate': eventData.event_endDate,
      'event_startTime': eventData.event_startTime,
      'event_endTime': eventData.event_endTime,
      'event_audience': eventData.event_audience,
      'event_numAudience': eventData.event_numAudience,
    }).then((value) => uploadEventPost(image, buildContext, eid!));
  }

  // clublist from snapshot
  List<ClubData> _clubListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return ClubData(
          club_ID: doc.id,
          club_name: doc.get('club_name'),
          club_desc: doc.get('club_desc'),
          club_email: doc.get('club_email'),
          club_category: doc.get('club_category'),
          club_chairman: doc.get('club_chairman'),
          club_registerDate: doc.get('club_registerDate'),
          club_logo: doc.get('club_logo'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  // clublist from snapshot
  List<EventData> _eventListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return EventData(
          event_ID: doc.id,
          event_title: doc.get('event_title'),
          event_caption: doc.get('event_caption'),
          event_location: doc.get('event_location'),
          event_startDate: doc.get('event_startDate'),
          event_endDate: doc.get('event_endDate'),
          event_startTime: doc.get('event_startTime'),
          event_endTime: doc.get('event_endTime'),
          event_audience: doc.get('event_audience'),
          event_numAudience: doc.get('event_numAudience'),
          event_poster: doc.get('event_poster'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  //get clubdata stream
  Stream<List<ClubData>> get clubdata {
    return clubCollection
        .where('club_chairman', isEqualTo: uid)
        .snapshots()
        .map(_clubListFromSnapshot);
  }

  //get event stream
  Stream<List<EventData>> get eventdata {
    return clubCollection
        .doc(cid)
        .collection('events')
        .snapshots()
        .map(_eventListFromSnapshot);
  }

  Future uploadLogo(File? image, BuildContext context) async {
    if (cid!.isNotEmpty) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('clubs')
          .child('${cid!}/logo')
          .child("logo_$postID");

      await ref.putFile(image!);
      String logo = await ref.getDownloadURL();

      //upload url to cloudfirestore
      await firebaseFirestore
          .collection('clubs')
          .doc(cid)
          .update({'club_logo': logo});
    } else {
      return null;
    }
  }

  Future uploadEventPost(File? image, BuildContext context, String id) async {
    if (cid!.isNotEmpty) {
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
          .collection('clubs')
          .doc(cid)
          .collection('events')
          .doc(id)
          .update({'event_poster': eventPoster});
    } else {
      return null;
    }
  }
}
