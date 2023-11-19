import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/user_post_model.dart';
import 'package:flutter_application_ecommerce/ViewModel/controller.dart';
import 'package:password_field_validator/password_field_validator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../Model/Widget/widget.dart';
import '../ProfileScreen/AuthenticationScreen/authentication_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void dispose() {
    super.dispose();
  }

  final CustomColors colors = Get.find<DuplicateController>().colors;
  final CustomTextStyle textStyle = Get.find<DuplicateController>().textStyle;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  UserController userController = UserController();

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

  bool isValidEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isValidPhone(String value) {
    String pattern = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isValidPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Sign up'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            TextFormField(
              controller: fullnameController,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Fullname",
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
              controller: emailController,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Email",
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
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: phoneController,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Phone",
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
              controller: usernameController,
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
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(0),
              child: PasswordFieldValidator(
                minLength: 8,
                uppercaseCharCount: 1,
                lowercaseCharCount: 1,
                numericCharCount: 1,
                specialCharCount: 1,
                defaultColor: Colors.black,
                successColor: Colors.green,
                failureColor: Colors.red,
                controller: passwordController,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () async {
                if (fullnameController.text == "") {
                  return snackBar(
                      title: "Error!",
                      message: "Please input some text for Fullname",
                      textStyle: textStyle,
                      colors: colors);
                } else if (emailController.text == "") {
                  return snackBar(
                      title: "Error!",
                      message: "Please input some text for Email",
                      textStyle: textStyle,
                      colors: colors);
                } else if (phoneController.text == "") {
                  return snackBar(
                      title: "Error!",
                      message: "Please input some text for Phone",
                      textStyle: textStyle,
                      colors: colors);
                } else if (usernameController.text == "") {
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
                } else if (isValidEmail(emailController.text) == false) {
                  return snackBar(
                      title: "Error!",
                      message: "Invalid Email format",
                      textStyle: textStyle,
                      colors: colors);
                } else if (isValidPhone(phoneController.text) == false) {
                  return snackBar(
                      title: "Error!",
                      message: "Phone numbers must contain 10 digits",
                      textStyle: textStyle,
                      colors: colors);
                } else if (isValidPassword(passwordController.text) == false) {
                  return snackBar(
                      title: "Error!",
                      message: "Invalid Password format",
                      textStyle: textStyle,
                      colors: colors);
                }

                await userController
                    .createAccount(
                        username: usernameController.text.toString(),
                        fullname: fullnameController.text.toString(),
                        email: emailController.text.toString(),
                        phone: int.parse(phoneController.text),
                        password: passwordController.text.toString())
                    .then((response) => {
                          if (response is UserPostModel)
                            {
                              showAlertDialog(context,
                                  "Your account has been successful created in ENPT")
                            }
                          else if (response == "user exits")
                            {
                              {
                                snackBar(
                                    title: "Error!",
                                    message:
                                        "User existed, please choose another one",
                                    textStyle: textStyle,
                                    colors: colors)
                              }
                            }
                          else
                            {
                              snackBar(
                                  title: "Error!",
                                  message: "Something wrong happen",
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
                  child: Text('Sign up',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String info) {
  // set up the buttons
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffCC9D76),
    ),
    child: const Text("Continue", style: TextStyle(color: Colors.white)),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Success!"),
    content: Text(info, style: const TextStyle(color: Colors.black)),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
