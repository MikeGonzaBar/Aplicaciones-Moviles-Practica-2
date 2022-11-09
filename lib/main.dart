import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/Auth/bloc/auth_bloc.dart';
import 'package:practica1/pages/home_page.dart';
import 'package:practica1/pages/login_page.dart';
import 'package:practica1/providers/favorite_song_provider.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
        create: (context) => AuthBloc()..add(VerifyAuthEvent()),
        child: ChangeNotifierProvider(
          create: (context) => FavoriteProvider(),
          child: const MyApp(),
        )),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData.dark(),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            log('LOGGED IN');
            return const HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            log('LOGGED OUT');
            return const LoginPage();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
