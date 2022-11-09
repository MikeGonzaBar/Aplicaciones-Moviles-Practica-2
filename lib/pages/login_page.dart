// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica1/Auth/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/sound-waves.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const CircleAvatar(
              radius: 140, // Image radius
              backgroundImage: AssetImage(
                'assets/images/listening.gif',
              ),
            ),
            const SizedBox(height: 200),
            MaterialButton(
              color: Colors.blue.withOpacity(0.5),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(FontAwesomeIcons.google),
                  Text("\t    Iniciar con Google"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
