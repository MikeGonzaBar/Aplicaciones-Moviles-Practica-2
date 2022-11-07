// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:practica1/pages/selected_song.dart';

class FavoritesItem extends StatelessWidget {
  final dynamic songData;
  const FavoritesItem({super.key, required this.songData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 350,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: MaterialButton(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "${songData["spotify"]["album"]["images"][0]["url"]}",
                        scale: 1),
                  ),
                ),
              ),
              // ),
              onPressed: () {
                print(songData);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectedSong(
                      songData: songData,
                      isFavorite: true,
                    ),
                  ),
                );
              },
            ),
          ),
          // Placeholder(fallbackHeight: 104),
          Positioned(
            bottom: 5,
            right: 29,
            left: 29,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(0xEF4169D8),
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(15))),
              child: Column(
                children: [
                  Text(
                    "${songData["title"]}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${songData["artist"]}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 20,
            left: 50,
            child: Icon(Icons.favorite),
          )
        ],
      ),
    );
  }
}
