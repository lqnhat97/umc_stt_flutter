import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/Request/History.dart';
import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

ListTile _tile(String title, String subtitle1, String subtitle2) => ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ))
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text(subtitle1), Text(subtitle2)],
      ),
    );

class _HistoryState extends State<History> {
  String barcode = Login.result;

  Future<HistoryRequest> fetchHistoryRequest() async {
    final String url =
        "https://fit-umc-stt.azurewebsites.net/history/" +
            barcode;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return HistoryRequest.fromJson(json.decode(response.body));
    } else
      throw Exception('Fail');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: fetchHistoryRequest(),
      builder: (context, snapshot) {
        // Truong hop da co du lieu
        if (snapshot.hasData) {
          return thisWidget(context, snapshot);
        }
        // Neu khong co du lieu thi hien man hinh loading
        else {
          return Scaffold(
              body: new Center(
                child: new CircularProgressIndicator(),
              ));
        }
      },
    );
  }

  Widget thisWidget(BuildContext context, AsyncSnapshot<dynamic> snapshot){
    Scaffold(
      appBar: AppBar(
        title: Text("Lịch sử tìm kiếm"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: <Widget>[
          _tile("Hello world", "AAA", "BBB"),
        ],
      ),
    );
  }
}
