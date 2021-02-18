import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final myController = TextEditingController();
  String seciliSehir;
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("HATA !"),
          content: new Text("Lütfen Geçerli Bir Şehir Giriniz"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/search.jpg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                      hintText: "Şehir Seçiniz",
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              FlatButton(
                onPressed: () async {
                  var response = await http.get(
                      "https://www.metaweather.com/api/location/search/?query=${myController.text}");

                  (myController.text.isEmpty ||
                          jsonDecode(response.body).isEmpty)
                      ? _showDialog()
                      : myController.text == null
                          ? Navigator.of(context)
                          : Navigator.pop(context, myController.text);
                },
                child: Text("Şehri Seç"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
