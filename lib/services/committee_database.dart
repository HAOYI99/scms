import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/committee.dart';

//clubs/{clubID}/committee/{committeeID}
class CommitteeDatabaseService {
  final String? cid;
  final String? cmid;
  CommitteeDatabaseService({this.cid, this.cmid});

  //collection reference
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');

  //get Committee Stream
  Stream<List<CommitteeData>> get committeedata {
    return clubCollection
        .doc(cid)
        .collection('committees')
        .snapshots()
        .map(_committeeListFromSnapshot);
  }

  List<CommitteeData> _committeeListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return CommitteeData(
            // event_ID: doc.id,
            // event_title: doc.get('event_title'),
            );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future newCommittee(CommitteeData committeeData) async {
    DocumentReference committeeDocument =
        clubCollection.doc(cid).collection('committees').doc();
    return await committeeDocument.set({
      // 'event_title': eventData.event_title,
    });
  }

  Future updateCommitteeData(CommitteeData committeeData) async {
    return await clubCollection
        .doc(cid)
        .collection('committees')
        .doc(cmid)
        .update({
      // 'event_title': eventData.event_title,
    });
  }
}
