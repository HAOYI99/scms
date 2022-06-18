import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/user.dart';

class UserDatabaseService {
  final String? uid;
  UserDatabaseService({required this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUserData(String firstname, String lastname, String email) async {
    return await userCollection.doc(uid).set({
      'user_name': firstname,
      'user_lastName': lastname,
      'user_email': email,
      'user_matricNo': '',
      'user_HPno': '',
      'user_gender': '',
      'user_dob': '',
      'user_addStreet1': '',
      'user_addStreet2': '',
      'user_addPostcode': '',
      'user_addCity': '',
      'user_addState': '',
      'user_photo': '',
    });
  }

  Future updateUserData(UserData userData) async {
    return await userCollection.doc(uid).update({
      'user_name': userData.user_name,
      'user_lastName': userData.user_lastName,
      'user_matricNo': userData.user_matricNo,
      'user_HPno': userData.user_HPno,
      'user_gender': userData.user_gender,
      'user_dob': userData.user_dob,
      'user_addStreet1': userData.user_addStreet1,
      'user_addStreet2': userData.user_addStreet2,
      'user_addPostcode': userData.user_addPostcode,
      'user_addCity': userData.user_addCity,
      'user_addState': userData.user_addState
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        user_ID: uid,
        user_name: snapshot['user_name'],
        user_lastName: snapshot['user_lastName'],
        user_email: snapshot['user_email'],
        user_photo: snapshot['user_photo'],
        user_matricNo: snapshot['user_matricNo'],
        user_HPno: snapshot['user_HPno'],
        user_gender: snapshot['user_gender'],
        user_dob: snapshot['user_dob'],
        user_addStreet1: snapshot['user_addStreet1'],
        user_addStreet2: snapshot['user_addStreet2'],
        user_addPostcode: snapshot['user_addPostcode'],
        user_addCity: snapshot['user_addCity'],
        user_addState: snapshot['user_addState']);
  }

  // userlist from snapshot
  List<UserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return UserData(
          user_ID: doc.id,
          user_name: doc.get('user_name'),
          user_lastName: doc.get('user_lastName'),
          user_email: doc.get('user_email'),
          user_photo: doc.get('user_photo'),
          user_matricNo: doc.get('user_matricNo'),
          user_HPno: doc.get('user_HPno'),
          user_gender: doc.get('user_gender'),
          user_dob: doc.get('user_dob'),
          user_addStreet1: doc.get('user_addStreet1'),
          user_addStreet2: doc.get('user_addStreet2'),
          user_addPostcode: doc.get('user_addPostcode'),
          user_addCity: doc.get('user_addCity'),
          user_addState: doc.get('user_addState'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get user list stream
  Stream<List<UserData>> get userDataList {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Future uploadImage(File? image, BuildContext context) async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user')
        .child('${uid!}/images')
        .child("post_$postID");

    await ref.putFile(image!);
    String profilePicture = await ref.getDownloadURL();

    //upload url to cloudfirestore
    await firebaseFirestore
        .collection('users')
        .doc(uid)
        .update({'user_photo': profilePicture});
  }
}
