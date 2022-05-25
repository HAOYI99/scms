class UserDetails {
  String? uid;
  String? displayName;
  String? email;
  String? photoURL;

  UserDetails({this.uid, this.displayName, this.email, this.photoURL});

  UserDetails.fromJson(Map<String, dynamic> json){
    displayName = json['displayName'];
    photoURL = json['photoUrl'];
    email = json['email'];
  }
  Map<String, dynamic> toJson(){
    
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['photoUrl'] = this.photoURL;

    return data;
  }
  //receive data from server
  factory UserDetails.fromMap(map) {
    return UserDetails(
      uid: map['user_ID'],
      email: map['user_email'],
      displayName: map['user_name'],
      photoURL: map['user_photo'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'user_ID': uid,
      'email': email,
      'name': displayName,
      'photo': photoURL,
    };
  }
}