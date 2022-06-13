class thisUser {
  final String? uid;

  thisUser({this.uid});
}

class UserData {
  final String? user_ID;
  final String? user_name;
  final String? user_lastName;
  final String? user_email;
  final String? user_photo;

  final String? user_matricNo;
  final String? user_HPno;
  final String? user_gender;
  final String? user_dob;
  final String? user_addStreet1;
  final String? user_addStreet2;
  final String? user_addPostcode;
  final String? user_addCity;
  final String? user_addState;

  UserData(
      {this.user_ID,
      this.user_name,
      this.user_lastName,
      this.user_email,
      this.user_photo,
      this.user_matricNo,
      this.user_HPno,
      this.user_gender,
      this.user_dob,
      this.user_addStreet1,
      this.user_addStreet2,
      this.user_addPostcode,
      this.user_addCity,
      this.user_addState});

  Map<String, dynamic> toMap() {
    return {
      'user_name': user_name,
      'user_lastName': user_lastName,
      'user_email': user_email,
      'user_photo': user_photo,
      'user_matricNo': user_matricNo,
      'user_HPno': user_HPno,
      'user_gender': user_gender,
      'user_dob': user_dob,
      'user_addStreet1': user_addStreet1,
      'user_addStreet2': user_addStreet2,
      'user_addPostcode': user_addPostcode,
      'user_addCity': user_addCity,
      'user_addState': user_addState
    };
  }

  factory UserData.fromMap(map) {
    return UserData(
        user_name: map['user_name'],
        user_lastName: map['user_lastName'],
        user_email: map['user_email'],
        user_photo: map['user_photo'],
        user_matricNo: map['user_matricNo'],
        user_HPno: map['user_HPno'],
        user_gender: map['user_gender'],
        user_dob: map['user_dob'],
        user_addStreet1: map['user_addStreet1'],
        user_addStreet2: map['user_addStreet2'],
        user_addPostcode: map['user_addPostcode'],
        user_addCity: map['user_addCity'],
        user_addState: map['user_addState']);
  }
}
