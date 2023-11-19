class UserModel {
  UserModel({
    String? id,
    String? email,
    int? phone,
    String? fullname,
    String? username,
  }){
    _id = id;
    _fullname = fullname;
    _username = username;
    _email = email;
    _phone = phone;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _fullname = json['fullname'];
    _username = json['username'];
    _email = json['email'];
    _phone = json['phone'];
  }
  String? _id;
  String? _fullname;
  String? _username;
  String? _email;
  int? _phone;

  String? get id => _id;
  String? get fullname => _fullname;
  String? get username => _username;
  String? get email => _email;
  int? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['fullname'] = _fullname;
    map['username'] = _username;
    map['email'] = _email;
    map['phone'] = _phone;
    return map;
  }

}



