// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../credentials/credentials.dart' as credentials;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteProvider with ChangeNotifier {
  List<dynamic> _favsList = [];
  List<dynamic> get getFavsList => _favsList;

  Future<bool> addNewSong(dynamic songObj) async {
    try {
      var mySongs = await FirebaseFirestore.instance
          .collection('musicfindapp')
          .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      log(mySongs.toString());
      log(mySongs.size.toString());
      if (mySongs.size == 0) {
        var postId =
            await FirebaseFirestore.instance.collection('musicfindapp').add(
                  ({
                    'songs': [songObj],
                    'user_id': FirebaseAuth.instance.currentUser!.uid,
                  }),
                );
        log(postId.toString());
      } else {
        // log(mySongs.docs.toString());
        // log(mySongs.docs.first.toString());
        // log(mySongs.docs.first.id);
        // log(mySongs.docs.first.data().toString());
        var newSongs = mySongs.docs.first.data()['songs'];
        log(newSongs.toString());
        var songList = await FirebaseFirestore.instance
            .collection('musicfindapp')
            .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('songs', arrayContains: songObj)
            .get();
        log(songList.docs.toString());

        if (songList.size > 0) {
          log('IT EXISTS');
        } else {
          // log(newSongs.toString());
          log('NOT EXISTS');
          newSongs.add(songObj);
          await FirebaseFirestore.instance
              .collection('musicfindapp')
              .doc(mySongs.docs.first.id)
              .update({'songs': newSongs})
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));
        }
      }
      getSongsList();

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> deleteSong(dynamic songObj) async {
    var mySongs = await FirebaseFirestore.instance
        .collection('musicfindapp')
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    var songList = mySongs.docs.first.data()['songs'];
    log(songList.toString());
    List<dynamic> newSongList = [];
    for (var song in songList) {
      log(song.toString());
      if (song['title'] != songObj['title']) {
        log('DIS NOT IT');
        newSongList.add(song);
      }
    }
    log(newSongList.toString());
    await FirebaseFirestore.instance
        .collection('musicfindapp')
        .doc(mySongs.docs.first.id)
        .update({'songs': newSongList})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    getSongsList();

    // notifyListeners();
  }

  Future<dynamic> searchSong(String songPath) async {
    File songFile = File(songPath);
    String songString = _fileConvert(songFile);
    dynamic response = await _sendToAPI(songString);
    dynamic songObject = response["result"];
    dynamic newSongFb;
    if (songObject != null) {
      newSongFb = {
        'album':
            (songObject["album"] == null) ? 'N/A' : '${songObject["album"]}',
        'apple_music_url': (songObject["apple_music"] == null)
            ? '${songObject["song_link"]}'
            : '${songObject["apple_music"]["url"]}',
        'artist':
            (songObject["artist"] == null) ? 'N/A' : '${songObject["artist"]}',
        'cover_url': (songObject["spotify"] == null)
            ? 'https://bazarama.com/assets/imgs/Image-not-available.png'
            : '${songObject["spotify"]["album"]["images"][0]["url"]}',
        'deezer_url': (songObject["deezer"] == null)
            ? '${songObject["song_link"]}'
            : '${songObject["deezer"]["link"]}',
        'other_urls': "${songObject["song_link"]}",
        'release_date': (songObject["release_date"] == null)
            ? 'N/A'
            : '${songObject["release_date"]}',
        'spotify_url': (songObject["spotify"] == null)
            ? '${songObject["song_link"]}'
            : '${songObject["spotify"]["external_urls"]["spotify"]}',
        'title':
            (songObject["title"] == null) ? 'N/A' : '${songObject["title"]}',
      };

      notifyListeners();
      log(newSongFb.toString());
    }
    return newSongFb;
  }

  String _fileConvert(File file) {
    Uint8List fileBytes = file.readAsBytesSync();
    String base64String = base64Encode(fileBytes);
    return base64String;
  }

  Future<dynamic> _sendToAPI(String file) async {
    print("Sending file: $file");
    var url = Uri.parse('https://api.audd.io/');
    var response = await http.post(url, body: {
      'api_token': credentials.apiKey,
      'return': 'apple_music,spotify,deezer',
      'audio': file,
      'method': 'recognize',
    });
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load json');
    }
  }

  getSongsList() async {
    var myCollection = await FirebaseFirestore.instance
        .collection('musicfindapp')
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    var mySongs = myCollection.docs.first.data()['songs'];
    log(mySongs.toString());
    _favsList = mySongs;
    notifyListeners();
    return;
  }
}
