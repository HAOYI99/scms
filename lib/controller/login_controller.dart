import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scms/model/user_detail.dart';

class LoginController with ChangeNotifier {
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;

  googleLogin() async {
    this.googleSignInAccount = await _googleSignIn.signIn();
    this.userDetails = new UserDetails(
        displayName: this.googleSignInAccount!.displayName,
        email: this.googleSignInAccount!.email,
        photoURL: this.googleSignInAccount!.photoUrl);
    notifyListeners();
  }

  logout() async {
    this.googleSignInAccount = await _googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    userDetails = null;
    notifyListeners();
  }
}
