import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/Request/Clinic.dart';
import 'package:http/http.dart' as http;

///author: nhatlq

class HomeFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeFragmentState();
  }
}

class _HomeFragmentState extends State<HomeFragment> {
  String barcode = Login.result;
  static Clinic _clinic;

  ///Lay thong tin kham benh
  Future<Clinic> fetchClinc() async {
    final String url =
        "https://fit-umc-stt.azurewebsites.net/clinic/thongtinkhambenh/" +
            barcode;
    final response = await http.get(url);

    //Neu thong tin tra ve la dung
    if (response.statusCode == 200) {
      setState(() {
        _clinic = Clinic.fromJson(json.decode(response.body));
      });
      return _clinic;
    } else
      throw Exception('Fail');
  }

  ///Man hinh kham benh
  Widget homeWidget(BuildContext context) {
    List<Subclinical> data = _HomeFragmentState._clinic.canLamSang;
    return Scaffold(
      body: GridView.builder(
          itemCount: data.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Card(
                  elevation: 2.0,
                  child: new Container(
                      padding: new EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            data[index].tenPhong,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            padding: new EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Phòng",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  data[index].maPhongCls,
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Thời gian",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  data[index].thoiGianDuKien,
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Số hiện tại",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  data[index].sttHienTai.toString(),
                                  style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            ),
                          ),
                          Container(
                              padding: new EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Số của bạn",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    data[index].stt.toString(),
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  )
                                ],
                              )),
                        ],
                      )),
                ),
              ),
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  child: new CupertinoAlertDialog(
                    title: new Column(
                      children: <Widget>[
                        new Text("GridView"),
                        new Icon(
                          Icons.favorite,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    content: new Text("Selected Item $index"),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("OK"))
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    //return homeWidget(context);
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text("Trang chủ"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blueAccent,
          ),
          preferredSize: Size.fromHeight(30.0)),
      body: FutureBuilder(
        future: fetchClinc(),
        builder: (context, snapshot) {
          // Truong hop da co du lieu
          if (_clinic != null) {
            return homeWidget(context);
          }
          // Neu khong co du lieu thi hien man hinh loading
          else {
            return Scaffold(
                body: new Center(
              child: new CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}
