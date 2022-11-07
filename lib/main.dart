import 'package:flutter/material.dart';
import 'package:practica1/pages/home_page.dart';
import 'package:practica1/providers/favorite_song_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => FavoriteProvider(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App', theme: ThemeData.dark(), home: const HomePage());
  }
}
