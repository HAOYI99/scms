import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scms/models/brew.dart';
import 'package:scms/models/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

      //collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String firstname, String lastname, String email) async {
    return await userCollection
        .doc(uid)
        .set({'user_name':firstname, 'user_lastName':lastname, 'user_email':email});
  }

  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Brew(
            name: doc.get('name') ?? '',
            sugar: doc.get('sugar') ?? '0',
            strength: doc.get('strength') ?? 0);
      }).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      user_ID: uid,
      user_name: snapshot['user_name'],
      user_lastName: snapshot['user_lastName'],
      user_email: snapshot['user_email'],
    );
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
