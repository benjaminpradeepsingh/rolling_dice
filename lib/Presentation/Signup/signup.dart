import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:rolling_dice/Application/authentication.dart';
import 'package:rolling_dice/Presentation/Component/background.dart';
import 'package:rolling_dice/Presentation/Login/login.dart';
import 'package:rolling_dice/Presentation/shared/button.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        headerHeight: 200,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "REGISTER",
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
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Name is empty';
                    }
                    return null;
                  },
                  controller: nameTextController,
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
                  obscureText: true,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Password is empty';
                    }
                    return null;
                  },
                  controller: passwordTextController,
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: DiceButton(
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        final result =
                            await context.read<AuthenticationService>().signUp(
                                  email: emailTextController.text.trim(),
                                  password: passwordTextController.text.trim(),
                                  name: nameTextController.text.trim(),
                                );

                        showSnackbar(context, result!);
                        if (result == "Signed up") {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/auth'));
                        }
                      }
                    },
                    buttonName: 'SIGN UP',
                    width: size.width * 0.5,
                  )),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()))
                  },
                  child: Text(
                    "Already Have an Account? Sign in",
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
