class thisUser {
  final String? uid;

  thisUser({this.uid});
}

class UserData {
  final String? user_ID;
  final String? user_name;
  final String? user_lastName;
  final String? user_email;

  UserData({this.user_ID, this.user_name, this.user_lastName, this.user_email});

  Map<String, dynamic> toMap() {
    return {
      'user_name': user_name,
      'user_lastName': user_lastName,
      'user_email': user_email,
    };
  }
}
