import 'dart:async';
import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/Request/Confirm.dart';
import 'package:flutter_app/Request/ConfirmNurse.dart';
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
        if (!mounted) return;
        setState(() {
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
              borderRadius: new BorderRadius.circular(10.0)),
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
        (nurseRequest.isXetNghiem
            ? Container()
            : Container(
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
              )),
        myFloatingButton(nurseRequest.danhSachBan[index], index)
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
            "isXetNghiem": _nurseRequest.isXetNghiem,
            "caKham":_nurseRequest.caKham
          }
        : {
            "idPhong": _nurseRequest.idPhong,
            "idBanKham": _nurseRequest.danhSachBan[index].IDBan,
            "caKham":_nurseRequest.caKham
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
            "isXetNghiem": _nurseRequest.isXetNghiem,
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

  ListConfirmNurse confirmRequest;

  fetchRequest(ClinicTable ban) async {
    final String url = words.Word.ip +
        (_nurseRequest.isCLS
            ? "/clinic/danhSachYeuCauCanLamSang/?idPhong=" +
                _nurseRequest.idPhong +
                "&caKham=" +
                _nurseRequest.caKham
            : "/clinic/danhSachYeuCauLamSang/?idBan=" +
                ban.IDBan +
                "&idPhong=" +
                _nurseRequest.idPhong +
                "&caKham=" +
                _nurseRequest.caKham);
    final response = await http.get(url);

    //Neu thong tin tra ve la dung
    if (response.statusCode == 200) {
      print(response.body);

      return confirmRequest =
          ListConfirmNurse.fromJson(json.decode(response.body));

      ;
      //});
    } else
      throw Exception('Fail');
  }

  Widget buildRequest(context, ClinicTable ban,banIndex) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                ban.soBan != "null"
                    ? "Danh sách yêu cầu bàn " + ban.soBan
                    : "Danh sách yêu cầu",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: confirmRequest.list.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        confirmRequest.list[index].STT,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        confirmRequest.list[index].iDPhieuKham,
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          color: Colors.green,
                          icon: Icon(Icons.check_circle),
                          onPressed: (){acceptSubmit(index,banIndex);},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.cancel),
                          onPressed: (){declineSubmit(index,banIndex);},
                        ),
                      )
                    ]);
              }),
        ],
      ),
    );
  }

  _onClicked(ClinicTable ban,banIndex) {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: FutureBuilder(
                      future: fetchRequest(ban),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return buildRequest(context, ban,banIndex);
                        } else {
                          return new Center(
                            child: new CircularProgressIndicator(),
                          );
                        }
                      })));
        });
  }

  acceptSubmit(index,banIndex) {
    confirmAttendence(index,banIndex);
    Navigator.of(this.context).pop();
  }

  declineSubmit(index,banIndex) {
    declineAttendence(index,banIndex);
    Navigator.of(this.context).pop();
  }

  Future<dynamic> confirmAttendence(index,banIndex) async {
    Map<String, dynamic> match = _nurseRequest.isCLS?{
      "stt": confirmRequest.list[index].STT,
      "idPhieuKham": confirmRequest.list[index].iDPhieuKham,
      "idPhong": _nurseRequest.idPhong,
      "caKham":_nurseRequest.caKham
    }:{
      "stt": confirmRequest.list[index].STT,
      "idPhieuKham": confirmRequest.list[index].iDPhieuKham,
      "idPhong": _nurseRequest.idPhong,
      "idBan":_nurseRequest.danhSachBan[banIndex].IDBan,
      "caKham":_nurseRequest.caKham
    };
    var headers = {'Content-Type': 'application/json'};
    String jsonString = json.encode(match);
    Uri uri = Uri.parse(words.Word.ip + (_nurseRequest.isCLS?'/clinic/acceptYeuCauCanLamSang':'/clinic/acceptYeuCauLamSang'));
    Response response = await http.post(uri,
        body: jsonString,
        encoding: Encoding.getByName("utf-8"),
        headers: headers);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    if (statusCode == 200) {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              content: Text("Đã xác nhận thành công"),
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
      return response;
    } else {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              content: Text("Không thể xác nhận"),
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

  Future<dynamic>  declineAttendence(index,banIndex) async {
    Map<String, dynamic> match = _nurseRequest.isCLS?{
      "stt": confirmRequest.list[index].STT,
      "idPhieuKham": confirmRequest.list[index].iDPhieuKham,
      "idPhong": _nurseRequest.idPhong,
      "caKham":_nurseRequest.caKham
    }:{
      "stt": confirmRequest.list[index].STT,
      "idPhieuKham": confirmRequest.list[index].iDPhieuKham,
      "idPhong": _nurseRequest.idPhong,
      "idBan":_nurseRequest.danhSachBan[banIndex].IDBan,
      "caKham":_nurseRequest.caKham
    };
    print(index);
    print(_nurseRequest.danhSachBan);
    var headers = {'Content-Type': 'application/json'};
    String jsonString = json.encode(match);
    Uri uri = Uri.parse(words.Word.ip + (_nurseRequest.isCLS?'/clinic/declineYeuCauCanLamSang':'/clinic/declineYeuCauLamSang'));
    Response response = await http.post(uri,
        body: jsonString,
        encoding: Encoding.getByName("utf-8"),
        headers: headers);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    if (statusCode == 200) {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              content: Text("Đã xóa thành công"),
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
      return response;
    } else {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              content: Text("Không thể xóa"),
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

  Widget myFloatingButton(ClinicTable ban, int banIndex) {
    return Stack(
      children: <Widget>[
        FloatingActionButton(
          onPressed: () {
            _onClicked(ban,banIndex);
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.apps),
        ),
        Container(
          width: 20.0,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          child: Center(
              child: Text(
            _nurseRequest.danhSachBan[banIndex].SoLuongRequest,
            style: TextStyle(color: Colors.white),
          )),
        ),
      ],
      alignment: Alignment.topRight,
    );
  }
}