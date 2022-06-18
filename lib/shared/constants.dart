import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Container loadingIndicator() {
  return Container(
    color: Colors.white,
    child: const Center(
      child: SpinKitHourGlass(
        color: Colors.blue,
        size: 50.0,
      ),
    ),
  );
}

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    centerTitle: true,
    title: Text(title,
        style: const TextStyle(
            color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.0)),
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back, color: Colors.blue),
    ),
  );
}

showNormalSnackBar(String snacktext, BuildContext context) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.white, size: 20.0),
        const SizedBox(width: 10.0),
        Flexible(
            child: Text(snacktext,
                style: const TextStyle(fontSize: 18.0, color: Colors.white)))
      ],
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.blue,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showSuccessSnackBar(String snacktext, BuildContext context) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.white, size: 20.0),
        const SizedBox(width: 10.0),
        Flexible(
            child: Text(snacktext,
                style: const TextStyle(fontSize: 18.0, color: Colors.white)))
      ],
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.green,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showFailedSnackBar(String snacktext, BuildContext context) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.white, size: 20.0),
        const SizedBox(width: 10.0),
        Flexible(
            child: Text(snacktext,
                style: const TextStyle(fontSize: 18.0, color: Colors.white)))
      ],
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.red,
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
    return 'Please enter the email';
  }
  //reg expression for email validation
  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
    return 'Please Enter a valid email';
  }
  return null;
}

String? passwordValidator(value) {
  RegExp regex = RegExp(r'^.{6,}$');
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

String? matricNoValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your matric card number';
  }
  if (value!.length == 6) {
    if (value[0] == 'S' || value[0] == 's') {
      return null;
    } else {
      return "Matric Number Must Start With 'S' or 's'";
    }
  }
  return null;
}

String? phoneNoValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your phone number';
  }
  if (value!.length == 11 || value!.length == 12) {
    return null;
  } else {
    return 'Please enter a valid phone number !';
  }
}

String? streetValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your street address';
  }
  return null;
}

String? cityValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your city';
  }
  return null;
}

String? postcodeValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your postcode';
  }
  if (value!.length == 5) {
    return null;
  } else {
    return 'Please enter a valid postcode';
  }
}

String? clubNameValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter the club name';
  }
  if (value!.length < 3) {
    return 'club name is required at least 3 characters';
  }
  return null;
}

String? clubDescValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell something about the club';
  }else{
    return '';
  }
}

DecoratedBox buildGradientLine(Color leftColor, Color rightColor) {
  return DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [leftColor, rightColor]),
    ),
    child: Container(
      margin: const EdgeInsets.all(1),
    ),
  );
}
