import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/shitpost.dart';
import 'package:fluttertest/variables.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AniDay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryBlack,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
            onPrimary: Colors.white,
            onSurface: Colors.grey,
            elevation: 50,
          ),
        ),
      ),
      home: MyHomePage(title: 'AniDay'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Shitpost> responseData;

  @override
  void initState() {
    super.initState();
    responseData = fetchData();
  }

  Future<Shitpost> fetchData() async {
    final response = await http.get(Uri.http('www.animetodayme.me', 'today'),
        headers: {
          'Access-Control-Allow-Origin': "*",
          "Access-Control-Allow-Headers": "*"
        });

    if (response.statusCode == 200) {
      return Shitpost.fromJson(response.body);
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Padding appBarButton(String text) {
    return Padding(
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("This is an alert")));
        },
        child: Text(text),
      ),
      padding: EdgeInsets.all(10.0),
    );
  }

  Widget imageCard(Shitpost shitpost) {
    return Card(
        elevation: 20,
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.network(shitpost.url),
              ),
              Text(shitpost.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
              Text("Rating: " + shitpost.score,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(shitpost.episodes.toString() + " Episodes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(shitpost.description,
                      style: TextStyle(fontSize: 13))),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Wrap(
                    children: shitpost.genre
                        .map((e) => Chip(label: Text(e)))
                        .toList(),
                  )),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.api_sharp),
          title: Text(widget.title),
          actions: menuOptions.map((text) => appBarButton(text)).toList()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Here are today\'s anime image(s):',
            ),
            FutureBuilder<Shitpost>(
              future: responseData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return imageCard(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
