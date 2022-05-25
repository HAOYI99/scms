import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:scms/controller/login_controller.dart';
import 'package:scms/view/login_page.dart';
import 'package:scms/view/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginController(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: CheckAuth(),
      ),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    User? _user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    if (_user != null) {
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: _user.uid)
          .get();
      final List<DocumentSnapshot> _documentSnapshot = resultQuery.docs;

      if (_documentSnapshot.isEmpty) {
        FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
          'user_ID': _user.uid,
          'user_name': _user.displayName,
          'user_email': _user.email,
          'user_photo': _user.photoURL,
          'user_type': "student",
          'user_HPno': _user.phoneNumber ?? 'unknown',
          'user_IC': "unknown",
          'user_gender': "unknown",
          'user_DOB': "unknown",
          'user_address': "unknown"
        });
      }
    }
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  checkUserIsAuthenticated() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        signInWithGoogle().then(
          (value) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return MainPage();
              },
            ));
          },
        );
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return MainPage();
          },
        ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserIsAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }
}
