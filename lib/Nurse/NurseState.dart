import 'dart:async';
import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/Request/NurseRequest.dart';
import 'package:flutter_app/Utils/Words.dart' as words;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class NurseState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NurseState();
  }
}

class _NurseState extends State<NurseState> {
  String barcode = Login.result;
  static Timer _timer;
  static NurseRequest _nurseRequest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ///Lay thong tin kham benh
  Future<NurseRequest> fetchNurseClinic() async {
    final String url = words.Word.ip + "/clinic/thuki/" + barcode;

    final response = await http.get(url);

    //Neu thong tin tra ve la dung
    if (response.statusCode == 200) {
      _nurseRequest = NurseRequest.fromJson(json.decode(response.body));

      return _nurseRequest;
      //});
    } else
      throw Exception('Fail');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: fetchNurseClinic(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_nurseRequest.isCLS == false)
              return buildClinicalWidget(_nurseRequest, context);
          } else {
            return Scaffold(
                body: new Center(
              child: new CircularProgressIndicator(),
            ));
          }
        });
  }

  //Hai nút bấm
  Widget skipButtonWidget(
      NurseRequest nurseRequest, BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            doSomeThing(index);
            AlertDialog alertDialog= new AlertDialog(
                title: new Text("Đã qua số"),
                content: new Text("Alert Dialog body"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(this.context).pop();
                    },
                  )
                ]);
            showDialog(context: this.context,child: alertDialog);
          },
          padding: const EdgeInsets.all(0.0),
          child: Container(
            alignment: Alignment.center,
            width: 150.0,
            height: 68.0,
            decoration: const BoxDecoration(color: Colors.blue),
            padding: const EdgeInsets.all(10.0),
            child: const Text('Qua Số',
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.green),
          margin: const EdgeInsets.fromLTRB(50.0, 25.0, 0.0, 25.0),
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Xác nhận",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Checkbox(
                    value: nurseRequest.danhSachBan[index].checkVal,
                    onChanged: (bool value) {
                      setState(() {
                        nurseRequest.danhSachBan[index].checkVal = value;
                      });
                      //onCheckBoxChange(index);
                    })
              ]),
        )
      ],
    );
  }

  PreferredSizeWidget mAppBar(NurseRequest nurseRequest) {
    return PreferredSize(
        child: Column(
          children: <Widget>[
            PreferredSize(
                child: AppBar(
                  title: Text(nurseRequest.tenThuKi),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.blueAccent,
                ),
                preferredSize: Size.fromHeight(15.0)),
            Card(
                elevation: 5.0,
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              nurseRequest.tenChuyenKhoa,
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              nurseRequest.tenKhuVuc,
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              nurseRequest.soPhong,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Lầu " + nurseRequest.Lau,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ))),
          ],
        ),
        preferredSize: Size.fromHeight(170.0));
  }

  Widget buildClinicalWidget(NurseRequest nurseRequest, BuildContext context) {
    return Scaffold(
        appBar: mAppBar(nurseRequest),
        body: SafeArea(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: nurseRequest.danhSachBan.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpandableNotifier(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        ExpandablePanel(
                          header: tableWidget(nurseRequest, index),
                          expanded:
                              skipButtonWidget(nurseRequest, context, index),
                          tapHeaderToExpand: true,
                          hasIcon: false,
                        )
                      ]));
                })));
  }

  //Đại hiện cho một bàn
  Widget tableWidget(NurseRequest nurseRequest, int index) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(3.0))),
        child: Card(
            elevation: 5.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  leftColumnWidget(nurseRequest, index),
                  rightColumnWidget(nurseRequest, index)
                ])));
  }

  Widget leftColumnWidget(NurseRequest nurseRequest, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Số hiện tại:",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        Text(
          nurseRequest.STTHienTai,
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
        Text(
          "Bệnh nhân:",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        Text(
          nurseRequest.danhSachBan[index].BenhNhan == null
              ? 'Chưa có bệnh nhân'
              : nurseRequest.danhSachBan[index].BenhNhan,
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  Widget rightColumnWidget(NurseRequest nurseRequest, int index) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Bàn ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Text(
            nurseRequest.danhSachBan[index].soBan,
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
            ),
          ),
          Text(
            "Ca khám ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Text(
            nurseRequest.caKham,
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
            ),
          ),
        ]);
  }





  doSomeThing(int index) async {
    var match = _nurseRequest.isCLS
        ? {
            "idPhong": _nurseRequest.idPhong,
          }
        : {
            "idPhong": _nurseRequest.idPhong,
            "idBanKham": _nurseRequest.danhSachBan[index].IDBan,
          };
    var response = await http.post(
        Uri.parse(words.Word.ip +
            (_nurseRequest.isCLS
                ? '/clinic/soKeTiepCanLamSang'
                : '/clinic/soKeTiepLamSang')),
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8"));
  }

  Future onCheckBoxChange(int index) async {
    var match = _nurseRequest.isCLS
        ? {
            "idPhongKham": _nurseRequest.idPhong,
            "idBanKham": _nurseRequest.danhSachBan[index].IDBan,
            "CaKham": int.parse(_nurseRequest.caKham),
            "stt": int.parse(_nurseRequest.STTHienTai)
          }
        : {
            "idPhongKham": _nurseRequest.idPhong,
            "CaKham": int.parse(_nurseRequest.caKham),
            "stt": int.parse(_nurseRequest.STTHienTai)
          };
    var response = await http.post(
        Uri.parse(words.Word.ip +
            (_nurseRequest.isCLS
                ? '/clinic/checkBenhNhanDangKhamCls'
                : '/clinic/checkBenhNhanDangKham')),
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8"));
  }
}
