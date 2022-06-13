import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scms/models/user.dart';
import 'package:scms/shared/constants.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //     //collection reference
  // final CollectionReference brewCollection =
  //     FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String firstname, String lastname, String email) async {
    return await userCollection.doc(uid).set({
      'user_name': firstname,
      'user_lastName': lastname,
      'user_email': email
    });
  }

  //brew list from snapshot
  // List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   try {
  //     return snapshot.docs.map((doc) {
  //       return Brew(
  //           name: doc.get('name') ?? '',
  //           sugar: doc.get('sugar') ?? '0',
  //           strength: doc.get('strength') ?? 0);
  //     }).toList();
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      user_ID: uid,
      user_name: snapshot['user_name'],
      user_lastName: snapshot['user_lastName'],
      user_email: snapshot['user_email'],
      user_photo: snapshot['user_photo'],
      user_matricNo : snapshot['user_matricNo'],
      user_HPno : snapshot['user_HPno'],
      user_gender : snapshot['user_gender'],
      user_dob : snapshot['user_dob'],
      user_addStreet1 : snapshot['user_addStreet1'],
      user_addStreet2 : snapshot['user_addStreet2'],
      user_addPostcode : snapshot['user_addPostcode'],
      user_addCity : snapshot['user_addCity'],
      user_addState : snapshot['user_addState']
    );
  }

  //get brews stream
  // Stream<List<Brew>> get brews {
  //   return brewCollection.snapshots().map(_brewListFromSnapshot);
  // }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future uploadImage(File? image, BuildContext context) async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(uid! + '/images')
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
