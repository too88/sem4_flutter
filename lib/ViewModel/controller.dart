import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter_application_ecommerce/Model/user_model.dart';
import 'package:flutter_application_ecommerce/Model/user_post_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  Future<UserModel?> login({
    required String username,
    required String password,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"username": username, "password": password});
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await post(
        Uri.parse("http://172.17.32.1:8080/api/v1/auth/signin"),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final userEncode = jsonEncode(responseData);
      //Using shared_preferences here to save UserData
      prefs.setString('user', userEncode);

      return UserModel.fromJson(responseData);
    } else {
      return null;
    }
  }

  Future<Object?> createAccount({
    required String email,
    required int phone,
    required String password,
    required String fullname,
    required String username,
  }) async {
    final response = await post(
      Uri.parse("http://172.17.32.1:8080/api/v1/auth/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'phone': phone,
        'password': password,
        'fullname': fullname,
        'username': username,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return UserPostModel.fromJson(responseData);
    } else if (response.statusCode == 409) {
      return "user exits";
    } else {
      return null;
    }
  }
}
