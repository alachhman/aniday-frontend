import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Shitpost {
  final String id;
  final String day;
  final String url;
  final String title;
  final String description;
  final String score;
  final List<dynamic> genre;
  final int episodes;
  final String hash;
  final String method;

  Shitpost(
      {required this.id,
      required this.day,
      required this.url,
      required this.title,
      required this.description,
      required this.score,
      required this.genre,
      required this.episodes,
      required this.hash,
      required this.method});

  factory Shitpost.fromJson(String data) {
    List<dynamic> list = jsonDecode(data);
    var json = list[0];
    return Shitpost(
        id: json['_id'],
        day: json['day'],
        url: json['url'],
        title: json['title'],
        description: json['description'],
        score: json['score'],
        genre: json['genre'],
        episodes: json['episodes'],
        hash: json['hash'],
        method: json['method']);
  }
}
