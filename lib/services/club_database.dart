import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/club.dart';

class ClubDatabaseService {
  final String? uid;
  final String? cid;
  ClubDatabaseService({this.uid, this.cid});

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

  Future updateClubData(ClubData clubData) async {
    return await clubCollection.doc(clubData.club_ID).update({
      'club_name': clubData.club_name,
      'club_email': clubData.club_email,
      'club_desc': clubData.club_desc,
      'club_category': clubData.club_category,
    });
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

  //get clubdata stream
  Stream<List<ClubData>> get clubdata {
    return clubCollection
        .where('club_chairman', isEqualTo: uid)
        .snapshots()
        .map(_clubListFromSnapshot);
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
    }else{
      return null;
    }
  }
}
