import 'package:firebase_auth/firebase_auth.dart';
import 'package:scms/models/user.dart';
import 'package:scms/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on FirebaseUser
  thisUser? _userFromFirebaseUser(User? user) {
    return user != null ? thisUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<thisUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  // sign in anony
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email
  Future registerWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid)
          .updateUserData(firstName, lastName, email);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // validate password
  Future<bool> validatePassword(String email, String oldPassword) async {
    try {
      User? user = _auth.currentUser;
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      UserCredential result = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      return result.user != null;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // change password
  Future changePassword(String password) async {
    try {
      User? user = _auth.currentUser;
      return await user?.updatePassword(password);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
