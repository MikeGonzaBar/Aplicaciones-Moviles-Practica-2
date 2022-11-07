// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../credentials/credentials.dart' as credentials;

class FavoriteProvider with ChangeNotifier {
  final List<dynamic> _favsList = [];
  List<dynamic> get getFavsList => _favsList;

  void addNewSong(dynamic songObj) {
    _favsList.add(songObj);
    notifyListeners();
  }

  void deleteSong(dynamic songObj) {
    _favsList.remove(songObj);

    notifyListeners();
  }

  Future<dynamic> searchSong(String songPath) async {
    File songFile = File(songPath);
    String songString = _fileConvert(songFile);
    dynamic response = await _sendToAPI(songString);
    dynamic songObject = response["result"];
    if (songObject != null) {
      if (songObject["title"] == null) {
        songObject["spotify"] = "N/A";
      }
      if (songObject["album"] == null) {
        songObject["album"] = "N/A";
      }
      if (songObject["artist"] == null) {
        songObject["artist"] = "N/A";
      }
      if (songObject["release_date"] == null) {
        songObject["artist"] = "N/A";
      }
      if (songObject["spotify"] == null) {
        songObject["spotify"] = {
          "external_urls": {"spotify": "${songObject["song_link"]}"},
          "album": {
            "images": [
              {
                "url":
                    "https://bazarama.com/assets/imgs/Image-not-available.png",
              },
            ],
          },
        };
      }
      if (songObject["deezer"] == null) {
        songObject["deezer"] = {"link": "${songObject["song_link"]}"};
      }
      addNewSong(songObject);
      notifyListeners();
    }
    return songObject;
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
      'api_token': credentials.API_KEY,
      // 'api_token': dotenv.env['API_KEY'],
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
}
