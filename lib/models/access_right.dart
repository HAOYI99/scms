class accessRight {
  String? access_ID;
  String? function_ID;
  String? position_ID;
  String? access_right_code;

  accessRight(
      {this.access_ID,
      this.function_ID,
      this.position_ID,
      this.access_right_code});
}

class function {
  String? function_ID;
  String? function_name;
  String? access_right_code;

  function({this.function_ID, this.function_name, this.access_right_code});

  Map toJson() => {
        'function_ID': function_ID,
        'function_name': function_name,
        'access_right_code': access_right_code,
      };
}

class accessLimit {
  String? function_name;
  String? access_right_code;

  accessLimit({this.function_name, this.access_right_code});
}
