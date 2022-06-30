import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scms/models/access_right.dart';

class AccessRightDatabaseService {
  final String? pid;
  final String? aid;
  final String? fid;
  AccessRightDatabaseService({this.pid, this.aid, this.fid});

  final CollectionReference accessRightCollection =
      FirebaseFirestore.instance.collection('access_right');

  Future createAccessRight(List<accessRight> access_right) async {
    for (var i = 0; i < access_right.length; i++) {
      await accessRightCollection.doc().set({
        'function_ID': access_right.elementAt(i).function_ID,
        'position_ID': pid,
        'access_right_code': access_right.elementAt(i).access_right_code,
      });
    }
  }

  Future updateAccessRight(List<accessRight> access_right) async {
    await deleteAccessRight();
    for (var i = 0; i < access_right.length; i++) {
      await accessRightCollection.doc().set({
        'function_ID': access_right.elementAt(i).function_ID,
        'position_ID': pid,
        'access_right_code': access_right.elementAt(i).access_right_code,
      });
    }
  }

  accessRight _accessDataFromSnapshot(DocumentSnapshot snapshot) {
    return accessRight(
      access_ID: aid,
      function_ID: snapshot['function_ID'],
      position_ID: snapshot['position_ID'],
      access_right_code: snapshot['access_right_code'],
    );
  }

  List<accessRight> _accessListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return accessRight(
          access_ID: doc.id,
          function_ID: doc.get('function_ID'),
          position_ID: doc.get('position_ID'),
          access_right_code: doc.get('access_right_code'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<accessRight>> get accessdatalist {
    return accessRightCollection.snapshots().map(_accessListFromSnapshot);
  }

  Stream<accessRight> get accessdata {
    return accessRightCollection
        .doc(aid)
        .snapshots()
        .map(_accessDataFromSnapshot);
  }

  Future<void> deleteAccessRight() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    return accessRightCollection
        .where('position_ID', isEqualTo: pid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });
      return batch.commit();
    });
  }

  //function......................................................
  final CollectionReference functionCollection =
      FirebaseFirestore.instance.collection('Function');

  List<function> _functionListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return function(
          function_ID: doc.id,
          function_name: doc.get('function_name'),
          access_right_code: doc.get('access_right_code'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<function>> get functionlist {
    return functionCollection.snapshots().map(_functionListFromSnapshot);
  }
}
