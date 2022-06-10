import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Container loadingIndicator() {
  return Container(
    color: Colors.white,
    child: Center(
      child: SpinKitHourGlass(
        color: Colors.blue,
        size: 50.0,
      ),
    ),
  );
}

showSnackBar(
    String snacktext, Color colors, Color bgColors, BuildContext context) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(Icons.info_outline, color: colors, size: 20.0),
        const SizedBox(width: 10.0),
        Text(snacktext, style: TextStyle(fontSize: 18.0, color: colors))
      ],
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: bgColors,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

var textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
);

String? emailValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your email';
  }
  //reg expression for email validation
  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
    return 'Please Enter a valid email';
  }
  return null;
}

String? passwordValidator(value) {
  RegExp regex = new RegExp(r'^.{6,}$');
  if (value!.isEmpty) {
    return 'Password is required';
  }
  if (!regex.hasMatch(value)) {
    return 'Please enter valid password (Min. 6 character)';
  }
  return null;
}

String? firstNameValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your first name';
  }
  if (value!.length < 2) {
    return 'First name is required at least 2 characters';
  }
  return null;
}

String? lastNameValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your last name';
  }
  if (value!.length < 2) {
    return 'last name is required at least 2 characters';
  }
  return null;
}
