import 'dart:async';
import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/Request/NurseRequest.dart';
import 'package:flutter_app/Utils/Words.dart' as words;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
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
  StreamSubscription<NurseRequest> dataSub;
  List _checkList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNurseClinic().then((result) {
      if (_nurseRequest.danhSachBan != null) {
        _checkList =
            List.generate(_nurseRequest.danhSachBan.length, (i) => false);
      }
    });

    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) async {
      dataSub = fetchNurseClinic().asStream().listen((NurseRequest data) {
        this.setState(() {
          _nurseRequest = data;
        });
      });
    });
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
        Flexible(
            child: RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            doSomeThing(index).then((dynamic) => {});
            fetchNurseClinic().then((data) => {
                  setState(() {
                    _nurseRequest = data;
                  })
                });
            setState(() {
              _checkList[index] = false;
            });
//            AlertDialog alertDialog = new AlertDialog(
//                title: new Text("Đã qua số"),
//                content: new Text(
//                    "Tăng số tại bàn " + nurseRequest.danhSachBan[index].soBan),
//                actions: <Widget>[
//                  // usually buttons at the bottom of the dialog
//                  new FlatButton(
//                    child: new Text("Close"),
//                    onPressed: () {
//                      Navigator.of(this.context).pop();
//                    },
//                  )
//                ]);
//            showDialog(context: this.context, child: alertDialog);
          },
          padding: const EdgeInsets.all(0.0),
          child: Container(
            alignment: Alignment.center,
            width: 150.0,
            height: 68.0,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(10.0),
            child: Text('Qua Số',
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        )),
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
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
                    value: _checkList[index],
                    onChanged: (bool value) {
                      onCheckBoxChange(index);
                      setState(() {
                        _checkList[index] = value;
                      });
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
            Container(
                height: MediaQuery.of(this.context).size.height * 0.2,
                child: Card(
                    elevation: 5.0,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
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
                              ],
                            )
                          ],
                        )))),
          ],
        ),
        preferredSize:
            Size.fromHeight(MediaQuery.of(this.context).size.height * 0.3));
  }

  Widget buildClinicalWidget(NurseRequest nurseRequest, BuildContext context) {
    return Scaffold(
        floatingActionButton: myFloatingButton(),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueAccent,
          child: Container(
            height: MediaQuery.of(this.context).size.height * 0.00,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        appBar: mAppBar(nurseRequest),
        body: SafeArea(
            left: true,
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
                          initialExpanded: true,
                        )
                      ]));
                })));
  }

//Đại hiện cho một bàn
  Widget tableWidget(NurseRequest nurseRequest, int index) {
    return Container(
        width: MediaQuery.of(this.context).size.width,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(3.0))),
        child: Card(
            elevation: 5.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  leftColumnWidget(nurseRequest, index),
                  nurseRequest.isCLS
                      ? Column()
                      : rightColumnWidget(nurseRequest, index)
                ])));
  }

  Widget leftColumnWidget(NurseRequest nurseRequest, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "Số hiện tại: ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              nurseRequest.danhSachBan[index].STTHienTai,
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              "Số lượng bệnh nhân: ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              nurseRequest.danhSachBan[index].STTCuoi,
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
              ),
            ),
          ],
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
    return Flexible(
        child: Column(
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
            "Bác sĩ ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Text(
            nurseRequest.danhSachBan[index].bacSi,
            overflow: TextOverflow.clip,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 15,
            ),
          ),
        ]));
  }

  Future<dynamic> doSomeThing(int index) async {
    Map<String, dynamic> match = _nurseRequest.isCLS
        ? {
            "idPhong": _nurseRequest.idPhong,
          }
        : {
            "idPhong": _nurseRequest.idPhong,
            "idBanKham": _nurseRequest.danhSachBan[index].IDBan,
          };
    var headers = {'Content-Type': 'application/json'};
    String jsonString = json.encode(match);
    var response = await http.post(
        Uri.parse(words.Word.ip +
            (_nurseRequest.isCLS
                ? '/clinic/soKeTiepCanLamSang'
                : '/clinic/soKeTiepLamSang')),
        body: jsonString,
        headers: headers,
        encoding: Encoding.getByName("utf-8"));
    return response;
  }

  Future<dynamic> onCheckBoxChange(int index) async {
    Map<String, dynamic> match = _nurseRequest.isCLS
        ? {
            "idPhongKham": _nurseRequest.idPhong,

            "CaKham": _nurseRequest.caKham,
            "stt": int.parse(_nurseRequest.danhSachBan[index].STTHienTai)
          }
        : {
            "idPhongKham": _nurseRequest.idPhong,
            "idBanKham": _nurseRequest.danhSachBan[index].IDBan,
            "CaKham": _nurseRequest.caKham,
            "stt": int.parse(_nurseRequest.danhSachBan[index].STTHienTai)
          };
    var headers = {'Content-Type': 'application/json'};
    String jsonString = json.encode(match);
    Uri uri = Uri.parse(words.Word.ip +
        (_nurseRequest.isCLS
            ? '/clinic/checkBenhNhanDangKhamCls'
            : '/clinic/checkBenhNhanDangKham'));
    Response response = await http.post(uri,
        body: jsonString,
        encoding: Encoding.getByName("utf-8"),
        headers: headers);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    return response;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    _timer?.cancel();
    dataSub?.cancel();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  _onClicked() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Mã phiếu khám",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(controller: myController),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Xác nhận"),
                      onPressed: inFromSubmit,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  inFromSubmit() {
    ConfirmAttendence();
    Navigator.of(this.context).pop();
  }

  Future<dynamic> ConfirmAttendence() async {
    Map<String, dynamic> match = {
      "isCls": _nurseRequest.isCLS,
      "idPhieuKham": myController.text,
      "idPhong": _nurseRequest.idPhong,
    };
    var headers = {'Content-Type': 'application/json'};
    String jsonString = json.encode(match);
    Uri uri = Uri.parse(words.Word.ip + '/clinic/checkBenhNhanPhieuKham');
    Response response = await http.post(uri,
        body: jsonString,
        encoding: Encoding.getByName("utf-8"),
        headers: headers);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    if (statusCode == 200)
      {return response;}
    else {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              content:  Text("Không thể xác nhận"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Đóng"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  Widget myFloatingButton() {
    return FloatingActionButton(
      onPressed: _onClicked,
      backgroundColor: Colors.red,
      //if you set mini to true then it will make your floating button small
      mini: false,
      child: new Icon(Icons.search),
    );
  }
}
