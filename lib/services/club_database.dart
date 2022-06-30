import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/access_right.dart';
import 'package:scms/models/club.dart';
import 'package:scms/services/access_right_database.dart';

class ClubDatabaseService {
  final String? uid;
  final String? cid;
  final String? cmid;
  final String? pid;
  ClubDatabaseService({this.uid, this.cid, this.cmid, this.pid});

  //collection reference
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');

  Future createClubData(ClubData clubData, File? image,
      BuildContext buildContext, List<function>? functionList) async {
    DocumentReference clubDocument = clubCollection.doc();
    return await clubDocument.set({
      'club_name': clubData.club_name,
      'club_email': clubData.club_email,
      'club_desc': clubData.club_desc,
      'club_category': clubData.club_category,
      'club_registerDate': DateTime.now().toString(),
      'club_chairman': uid,
      'club_logo': '',
    }).then((value) async {
      await uploadLogo(image, buildContext, clubDocument.id);
      await createDefaultPosition(clubDocument.id, functionList);
    });
  }

  Future updateClubData(
      ClubData clubData, File? image, BuildContext buildContext) async {
    if (image != null) {
      return await clubCollection.doc(cid).update({
        'club_name': clubData.club_name,
        'club_email': clubData.club_email,
        'club_desc': clubData.club_desc,
        'club_category': clubData.club_category,
      }).then((value) async {
        await uploadLogo(image, buildContext, cid!);
      });
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
    if (id != null) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('clubs')
          .child('${id}/logo')
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

  Future createChairmanData(String clubID, String chairmanID) async {
    return await committeeCollection.doc().set({
      'club_ID': clubID,
      'user_ID': uid,
      'isApproved': true,
      'approved_by': uid,
      'approved_date': DateTime.now().toString(),
      'position_ID': chairmanID,
    });
  }

  Future updateCommitteeData(String position_ID) async {
    return await committeeCollection.doc(cmid).update({
      'position_ID': position_ID,
    });
  }

  Future requestJoinClub(String memberID) async {
    return await committeeCollection.doc().set({
      'club_ID': cid,
      'user_ID': uid,
      'isApproved': false,
      'approved_by': '',
      'approved_date': '',
      'position_ID': memberID,
    });
  }

  Future approveRequestCM() async {
    return await committeeCollection.doc(cmid).update({
      'isApproved': true,
      'approved_by': uid,
      'approved_date': DateTime.now().toString(),
    });
  }

  Future rejectKickCM() async {
    DocumentReference committeeDocument = committeeCollection.doc(cmid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(committeeDocument));
  }

  CommitteeData _committeeDataFromSnapshot(DocumentSnapshot snapshot) {
    return CommitteeData(
      committee_ID: cmid,
      club_ID: snapshot['club_ID'],
      user_ID: snapshot['user_ID'],
      isApproved: snapshot['isApproved'],
      approved_by: snapshot['approved_by'],
      approved_date: snapshot['approved_date'],
      position_ID: snapshot['position_ID'],
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
          position_ID: doc.get('position_ID'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<CommitteeData>> get committeeDatalist {
    return committeeCollection
        .where('club_ID', isEqualTo: cid)
        .snapshots()
        .map(_committeeListFromSnapshot);
  }

  Stream<CommitteeData> get committeedata {
    return committeeCollection
        .doc(cmid)
        .snapshots()
        .map(_committeeDataFromSnapshot);
  }

  //club structure (position)

  final CollectionReference positionCollection =
      FirebaseFirestore.instance.collection('positions');

  Future createDefaultPosition(
      String clubID, List<function>? functionList) async {
    List<accessRight> access_right = [];
    for (var i = 0; i < functionList!.length; i++) {
      var data = accessRight(
          function_ID: functionList[i].function_ID,
          access_right_code: functionList[i].access_right_code);
      access_right.add(data);
    }
    DocumentReference positionDocument = positionCollection.doc();
    await positionDocument.set({
      'position_name': 'Chairman',
      'seq_number': '1',
      'club_ID': clubID,
    });
    await positionCollection.doc().set({
      'position_name': 'Member',
      'seq_number': '5',
      'club_ID': clubID,
    });
    await createChairmanData(clubID, positionDocument.id);
    await AccessRightDatabaseService(pid: positionDocument.id)
        .createAccessRight(access_right);
  }

  Future createPosition(
      PositionData positionData, List<accessRight> accessData) async {
    DocumentReference positionDocument = positionCollection.doc();
    return await positionDocument.set({
      'position_name': positionData.position_name,
      'seq_number': positionData.seq_number,
      'club_ID': cid,
    }).then((value) => AccessRightDatabaseService(pid: positionDocument.id)
        .createAccessRight(accessData));
  }

  Future updatePosition(
      PositionData positionData, List<accessRight> accessData) async {
    return await positionCollection.doc(pid).update({
      'position_name': positionData.position_name,
      'seq_number': positionData.seq_number,
    }).then((value) =>
        AccessRightDatabaseService(pid: pid).updateAccessRight(accessData));
  }

  PositionData _positionDataFromSnapshot(DocumentSnapshot snapshot) {
    return PositionData(
      position_ID: pid,
      position_name: snapshot['position_name'],
      seq_number: snapshot['seq_number'],
      club_ID: snapshot['club_ID'],
    );
  }

  List<PositionData> _positionListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return PositionData(
          position_ID: doc.id,
          position_name: doc.get('position_name'),
          seq_number: doc.get('seq_number'),
          club_ID: doc.get('club_ID'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<PositionData> get positionData {
    return positionCollection
        .doc(pid)
        .snapshots()
        .map(_positionDataFromSnapshot);
  }

  Stream<List<PositionData>> get positionDataList {
    return positionCollection.snapshots().map(_positionListFromSnapshot);
  }

  Future deletePosition() async {
    DocumentReference positionDocument = positionCollection.doc(pid);
    await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(positionDocument));
    await AccessRightDatabaseService(pid: pid).deleteAccessRight();
  }
}
