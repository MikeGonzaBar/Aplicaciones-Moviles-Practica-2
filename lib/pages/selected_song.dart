// ignore_for_file: avoid_print, must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica1/providers/favorite_song_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedSong extends StatelessWidget {
  final dynamic songData;
  bool isFavorite;
  SelectedSong({super.key, required this.songData, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Here you go'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Eliminar de favoritos',
            onPressed: () {
              if (isFavorite) {
                addAlert(context);
              } else {
                context.read<FavoriteProvider>().addNewSong(songData);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
                "${songData["spotify"]["album"]["images"][0]["url"]}"),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                "${songData["title"]}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "${songData["album"]}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            subText("${songData["artist"]}"),
            subText("${songData["release_date"]}"),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                height: 20,
                indent: 20,
                endIndent: 0,
                color: Colors.black,
              ),
            ),
            const Text(
              "Abrir con:",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                platformButton(
                    "${songData["spotify"]["external_urls"]["spotify"]}",
                    FaIcon(FontAwesomeIcons.spotify)),
                platformButton("${songData["deezer"]["link"]}",
                    FaIcon(FontAwesomeIcons.deezer)),
                platformButton("${songData["apple_music"]["url"]}",
                    FaIcon(FontAwesomeIcons.apple)),
              ],
            )
          ],
        ),
      ),
    );
  }

  IconButton platformButton(String url, FaIcon icon) {
    return IconButton(
      onPressed: () {
        _launchURL(url);
      },
      icon: icon,
    );
  }

  Text subText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  Future<String?> addAlert(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Eliminar de favoritos'),
        content: const Text(
            'El elemento será eliminado de tus favoritos ¿Quieres continuar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancelar');
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Eliminar');
              print('DELETE $songData to favorites');
              context.read<FavoriteProvider>().deleteSong(songData);
              isFavorite = true;
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launch(url)) throw 'No se pudo acceder a: $url';
  }
}
