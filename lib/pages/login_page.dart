import 'package:flutter/material.dart';
import 'package:practica1/Auth/form_body_firebase.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBodyFirebase(),
    );
  }
}
