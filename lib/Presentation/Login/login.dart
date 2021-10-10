import 'package:flutter/material.dart';
import 'package:rolling_dice/Application/authentication.dart';
import 'package:rolling_dice/Presentation/Component/background.dart';
import 'package:rolling_dice/Presentation/Signup/signup.dart';
import 'package:rolling_dice/Presentation/shared/button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 36),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: emailTextController,
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email",
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  controller: passwordTextController,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Password is empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  obscureText: true,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: DiceButton(
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<AuthenticationService>()
                            .signIn(
                              email: emailTextController.text.trim(),
                              password: passwordTextController.text.trim(),
                            )
                            .then((result) => showSnackbar(context, result!));
                      }
                    },
                    buttonName: 'LOGIN',
                    width: size.width * 0.5,
                  )),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()))
                  },
                  child: Text(
                    "Don't Have an Account? Sign up",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showSnackbar(BuildContext context, String message) {
  if (message == "Signed in") {
    Navigator.popUntil(context, ModalRoute.withName('/auth'));
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(milliseconds: 1200),
  ));
}
