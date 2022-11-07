import 'package:flutter/material.dart';
import 'package:practica1/items/favorite_item.dart';
import 'package:practica1/providers/favorite_song_provider.dart';
import 'package:provider/provider.dart';

class Favorites extends StatelessWidget {
  const Favorites({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: context.watch<FavoriteProvider>().getFavsList.length,
        itemBuilder: (BuildContext context, int index) {
          return FavoritesItem(
            songData: context.watch<FavoriteProvider>().getFavsList[index],
          );
        },
      ),
    );
  }
}
