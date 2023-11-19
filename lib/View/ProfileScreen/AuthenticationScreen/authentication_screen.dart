import 'dart:async';
import 'package:flutter_application_ecommerce/View/SignupScreen/signup.dart';
import 'package:flutter_application_ecommerce/ViewModel/controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AuthenticationScreen/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/profile_screen.dart';
import 'package:password_field_validator/password_field_validator.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthenticationBloc? authenticationBloc;
  StreamSubscription? subscription;
  UserController userController = UserController();

  // owner
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> nameKey = GlobalKey();
  final GlobalKey<FormState> userNameKey = GlobalKey();
  final GlobalKey<FormState> passwordKey = GlobalKey();
  final CustomColors colors = Get.find<DuplicateController>().colors;
  final CustomTextStyle textStyle = Get.find<DuplicateController>().textStyle;

  @override
  void dispose() {
    authenticationBloc?.close();
    subscription?.cancel();
    super.dispose();
  }

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Sign in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: userNameController,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Username",
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscured,
              focusNode: textFieldFocusNode,
              controller: passwordController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Password",
                filled: true,
                isDense: true,
                // Reduces height a bit
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: GestureDetector(
                    onTap: _toggleObscured,
                    child: Icon(
                      _obscured
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () async {
                if (userNameController.text == "") {
                  return snackBar(
                      title: "Error!",
                      message: "Please input some text for Username",
                      textStyle: textStyle,
                      colors: colors);
                } else if (passwordController.text == "") {
                  return snackBar(
                      title: "Error!",
                      message: "Please input some text for Password",
                      textStyle: textStyle,
                      colors: colors);
                }

                await userController
                    .login(
                        username: userNameController.text.toString(),
                        password: passwordController.text.toString())
                    .then((response) async => {
                          if (response != null)
                            {Navigator.pop(context, response)}
                          else
                            {
                              snackBar(
                                  title: "Error!",
                                  message: "Incorrect username or password!",
                                  textStyle: textStyle,
                                  colors: colors)
                            }
                        });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xffCC9D76),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text('Sign in', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupPage(),
                  )),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xcccc9d76),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text('Sign up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
