class UserModel {
  UserModel({
    String? id,
    String? email,
    int? phone,
    String? fullname,
    String? username,
    String? token,
  }){
    _id = id;
    _fullname = fullname;
    _username = username;
    _email = email;
    _phone = phone;
    _token = token;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _fullname = json['fullname'];
    _username = json['username'];
    _email = json['email'];
    _phone = json['phone'];
    _token = json['token'];
  }
  String? _id;
  String? _fullname;
  String? _username;
  String? _email;
  int? _phone;
  String? _token;

  String? get id => _id;
  String? get fullname => _fullname;
  String? get username => _username;
  String? get email => _email;
  int? get phone => _phone;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['fullname'] = _fullname;
    map['username'] = _username;
    map['email'] = _email;
    map['phone'] = _phone;
    map['token'] = _token;
    return map;
  }

}



