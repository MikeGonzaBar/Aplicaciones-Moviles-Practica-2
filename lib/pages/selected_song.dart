// ignore_for_file: avoid_print, must_be_immutable, deprecated_member_use, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica1/providers/favorite_song_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedSong extends StatefulWidget {
  final dynamic songData;
  bool isFavorite;
  SelectedSong({super.key, required this.songData, required this.isFavorite});

  @override
  State<SelectedSong> createState() => _SelectedSongState();
}

class _SelectedSongState extends State<SelectedSong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Here you go'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: widget.isFavorite
                ? 'Eliminar de favoritos'
                : 'Agregar a favoritos',
            onPressed: () async {
              if (widget.isFavorite) {
                addAlert(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    snackBarProcess(context, 'Agregando a favoritos...'));

                await _addSong(widget.songData);

                ScaffoldMessenger.of(context).showSnackBar(
                    snackBarProcess(context, 'Agregado a favoritos'));
              }
              widget.isFavorite = !widget.isFavorite;
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network("${widget.songData["cover_url"]}"),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                "${widget.songData["title"]}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "${widget.songData["album"]}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            subText("${widget.songData["artist"]}"),
            subText("${widget.songData["release_date"]}"),
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
                platformButton("${widget.songData["spotify_url"]}",
                    const FaIcon(FontAwesomeIcons.spotify)),
                platformButton("${widget.songData["deezer_url"]}",
                    const FaIcon(FontAwesomeIcons.deezer)),
                platformButton("${widget.songData["apple_music_url"]}",
                    const FaIcon(FontAwesomeIcons.apple)),
                platformButton("${widget.songData["other_urls"]}",
                    const FaIcon(FontAwesomeIcons.music)),
              ],
            )
          ],
        ),
      ),
    );
  }

  SnackBar snackBarProcess(BuildContext context, String text) {
    return SnackBar(
      content: Text(text),
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
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                  snackBarProcess(context, 'Eliminando de favoritos...'));

              await _deleteSong(widget.songData);
              ScaffoldMessenger.of(context).showSnackBar(
                  snackBarProcess(context, 'Eliminado de favoritos'));
              Navigator.pop(context, 'Eliminar');
              log(widget.isFavorite.toString());
              setState(() {
                widget.isFavorite = false;
              });
              log(widget.isFavorite.toString());
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _addSong(sonData) async {
    await context.read<FavoriteProvider>().addNewSong(widget.songData);
  }

  Future<void> _deleteSong(songData) async {
    await context.read<FavoriteProvider>().deleteSong(widget.songData);
  }
}
