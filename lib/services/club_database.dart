import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/club.dart';

class ClubDatabaseService {
  final String? uid;
  final String? cid;
  final String? cmid;
  ClubDatabaseService({this.uid, this.cid, this.cmid});

  //collection reference
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');

  Future createClubData(
      ClubData clubData, File? image, BuildContext buildContext) async {
    DocumentReference clubDocument = clubCollection.doc();
    return await clubDocument.set({
      'club_name': clubData.club_name,
      'club_email': clubData.club_email,
      'club_desc': clubData.club_desc,
      'club_category': clubData.club_category,
      'club_registerDate': clubData.club_registerDate,
      'club_chairman': clubData.club_chairman,
      'club_logo': '',
    }).then((value) => uploadLogo(image, buildContext, clubDocument.id));
  }

  Future updateClubData(
      ClubData clubData, File? image, BuildContext buildContext) async {
    if (image != null) {
      return await clubCollection.doc(cid).update({
        'club_name': clubData.club_name,
        'club_email': clubData.club_email,
        'club_desc': clubData.club_desc,
        'club_category': clubData.club_category,
      }).then((value) => uploadLogo(image, buildContext, cid!));
    } else {
      return await clubCollection.doc(cid).update({
        'club_name': clubData.club_name,
        'club_email': clubData.club_email,
        'club_desc': clubData.club_desc,
        'club_category': clubData.club_category,
      });
    }
  }

  ClubData _clubDataFromSnapshot(DocumentSnapshot snapshot) {
    return ClubData(
      club_ID: cid,
      club_name: snapshot['club_name'],
      club_desc: snapshot['club_desc'],
      club_email: snapshot['club_email'],
      club_category: snapshot['club_category'],
      club_chairman: snapshot['club_chairman'],
      club_registerDate: snapshot['club_registerDate'],
      club_logo: snapshot['club_logo'],
    );
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

  //get club list stream
  Stream<List<ClubData>> get clubdatalist {
    return clubCollection
        .where('club_chairman', isEqualTo: uid)
        .snapshots()
        .map(_clubListFromSnapshot);
  }

  Stream<ClubData> get clubdata {
    return clubCollection.doc(cid).snapshots().map(_clubDataFromSnapshot);
  }

  Future uploadLogo(File? image, BuildContext context, String id) async {
    if (cid != null) {
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
          .doc(id)
          .update({'club_logo': logo});
    } else {
      return null;
    }
  }

  //committee member......................................................

  final CollectionReference committeeCollection =
      FirebaseFirestore.instance.collection('committee');

  Future requestJoinClub() async {
    return await committeeCollection.doc().set({
      'club_ID': cid,
      'user_ID': uid,
      'isApproved': false,
      'approved_by': '',
      'approved_date': '',
      'position': 'member',
    });
  }

  Future updateCommitteeData(CommitteeData committeeData) async {
    return await committeeCollection.doc(cmid).update({
      'isApproved': committeeData.isApproved,
      'approved_by': committeeData.approved_by,
      'approved_date': committeeData.approved_date,
      'position': committeeData.position
    });
  }

  CommitteeData _committeeDataFromSnapshot(DocumentSnapshot snapshot) {
    return CommitteeData(
      committee_ID: cmid,
      club_ID: snapshot['club_ID'],
      user_ID: snapshot['user_ID'],
      isApproved: snapshot['isApproved'],
      approved_by: snapshot['approved_by'],
      approved_date: snapshot['approved_date'],
      position: snapshot['position'],
    );
  }

  List<CommitteeData> _committeeListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return CommitteeData(
          committee_ID: doc.id,
          club_ID: doc.get('club_ID'),
          user_ID: doc.get('user_ID'),
          isApproved: doc.get('isApproved'),
          approved_by: doc.get('approved_by'),
          approved_date: doc.get('approved_date'),
          position: doc.get('position'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<CommitteeData>> get committeeDatalist {
    return committeeCollection.snapshots().map(_committeeListFromSnapshot);
  }

  Stream<CommitteeData> get committeedata {
    return committeeCollection
        .doc(cmid)
        .snapshots()
        .map(_committeeDataFromSnapshot);
  }
}
