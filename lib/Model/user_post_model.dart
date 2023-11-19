class UserPostModel {
  UserPostModel({
    String? id,
    String? email,
    int? phone,
    String? password,
    String? fullname,
    String? username,
  }){
    _id = id;
    _fullname = fullname;
    _username = username;
    _email = email;
    _phone = phone;
    _password = password;
  }

  UserPostModel.fromJson(dynamic json) {
    _id = json['id'];
    _fullname = json['fullname'];
    _username = json['username'];
    _email = json['email'];
    _phone = json['phone'];
    _password = json['password'];
  }
  String? _id;
  String? _fullname;
  String? _username;
  String? _email;
  int? _phone;
  String? _password;

  String? get id => _id;
  String? get fullname => _fullname;
  String? get username => _username;
  String? get email => _email;
  int? get phone => _phone;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['fullname'] = _fullname;
    map['username'] = _username;
    map['email'] = _email;
    map['phone'] = _phone;
    map['password'] = _password;
    return map;
  }

}



