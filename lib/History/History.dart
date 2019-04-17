import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/Request/History.dart';
import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HistoryState();
  }
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(subtitle1), Text(subtitle2)],
      ),
    );

class _HistoryState extends State<History> {
  String barcode = Login.result;
  static HistoryRequestList historyRequest;

  Future<HistoryRequestList> fetchHistoryRequest() async {
    final String urlHistory =
        "https://fit-umc-stt.azurewebsites.net/history/" + barcode;
    final responseHistory = await http.get(urlHistory);

    if (responseHistory.statusCode == 200) {
      //setState(() {
        historyRequest =
            HistoryRequestList.fromJson(json.decode(responseHistory.body));
      //});
      return historyRequest;
    } else
      throw Exception('Fail');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Lịch sử tìm kiếm"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
        ),
        body: FutureBuilder(
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
        ));
  }

  Widget thisWidget(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    HistoryRequestList data = _HistoryState.historyRequest;
    return Scaffold(
      body: ListView.builder(
        itemCount: data.list.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 2.0, child: _tile(data.list[index].idHistory,data.list[index].hoTen , data.list[index].tuoi.toString()));
        },
      ),
    );
  }
}
