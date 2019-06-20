import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/Login/Login.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Home/Fragments/ScanSearchedPatientHolder.dart';
import 'package:flutter_app/Request/Clinic.dart';
import 'package:flutter_app/Request/Profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/Utils/Words.dart' as words;

class SearchedPatient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchedPatientState();
  }
}

class _SearchedPatientState extends State<SearchedPatient> {
  String barcode = ScanSearchedPatientHolder.searchedPatientResult;
  static Clinic _clinic;
  static Profile searchedPatientProfile;
  List<Clinical> clinicalData;
  static Timer timer;
  static Timer timer2;
  DateTime now = new DateTime.now();
  int userNotiTime = 10;
  List<Subclinical> data;
  StreamSubscription<Clinic> dataSub;
  String data1 = "testData1";
  String data2 = "testData2";
  String data3 = "testData3";

  @override
  void initState() {
    super.initState();
    // defines a timer
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) async {
      dataSub = fetchClinic().asStream().listen((Clinic data) {
        this.setState(() {
          _clinic = data;
        });
      });
    });

    timer2 = Timer.periodic(Duration(seconds: 1), (Timer t) {
      this.setState(() {
        now = DateTime.now();
      });
    });
  }

  ///Lay thong tin kham benh
  Future<Clinic> fetchClinic() async {
    final String url = words.Word.ip + "/clinic/thongtinkhambenh/" + barcode;
    final String url2 = words.Word.ip + "/patient/" + barcode;

    final response = await http.get(url);
    final response2 = await http.get(url2);

    //Neu thong tin tra ve la dung
    if (response.statusCode == 200 && response2.statusCode == 200) {
      _clinic = Clinic.fromJson(json.decode(response.body));
      http.post(words.Word.ip +
          '/history?idBn=' +
          Login.result +
          "&idBnSearch=" +
          barcode);

      searchedPatientProfile = Profile.fromJson(json.decode(response2.body));
      data1 = searchedPatientProfile.lastName +
          " " +
          (searchedPatientProfile.middleName == ""
              ? ""
              : (searchedPatientProfile.middleName + " ")) +
          searchedPatientProfile.firstName;
      data2 = (DateTime.now().year -
                  int.parse(searchedPatientProfile.birthDay.split('-')[0]))
              .toString() +
          " tuổi";
      data3 = (_clinic.lamSang.length + _clinic.canLamSang.length).toString();
      return _clinic;
      //});
    } else
      throw Exception('Fail');
  }

  Color colorByState(Clinical data1) {
    if (data1.tinhTrang == 'Đã khám' || data1.tinhTrang == 'Đang khám') {
      return Colors.grey;
    }
    int tmp = ((int.parse(data1.thoiGianDuKien.split(':')[0]) * 3600 +
            int.parse(data1.thoiGianDuKien.split(':')[1]) * 60) -
        (now.hour * 3600 + now.minute * 60 + now.second));
    int tmp2 = data1.sttHienTai - data1.stt;
    if (data1.sttHienTai == data1.stt) {
      return Colors.green;
    }
    if ((tmp2 >= 0)) {
      return Colors.red;
    }
    if ((tmp <= userNotiTime * 60)) {
      return Colors.orange;
    } else {
      return Colors.blueAccent;
    }
  }

  Color colorSubByState(Subclinical data1) {
    if (data1.tinhTrang == 'Đã khám' || data1.tinhTrang == 'Đang khám') {
      return Colors.grey;
    }
    int tmp = ((int.parse(data1.thoiGianDuKien.split(':')[0]) * 3600 +
            int.parse(data1.thoiGianDuKien.split(':')[1]) * 60) -
        (now.hour * 3600 + now.minute * 60 + now.second));
    int tmp2 = int.parse(data1.sttHienTai) - data1.stt;
    if (int.parse(data1.sttHienTai) == data1.stt) {
      return Colors.green;
    }
    if ((tmp2 > 0)) {
      return Colors.red;
    }
    if ((tmp <= userNotiTime * 60)) {
      return Colors.orange;
    } else {
      return Colors.blueAccent;
    }
  }

  String sttTheoTinhTrangClinical(Clinical data) {
    if (data.tinhTrang == 'Đã khám' || data.tinhTrang == 'Đang khám') {
      return data.tinhTrang;
    } else {
      return data.stt.toString();
    }
  }

  String sttTheoTinhTrangSubclinical(Subclinical data) {
    if (data.tinhTrang == 'Đã khám' || data.tinhTrang == 'Đang khám') {
      return data.tinhTrang;
    } else {
      return data.stt.toString();
    }
  }

  String countingTime(Clinical data1) {
    int tmp = ((int.parse(data1.thoiGianDuKien.split(':')[0]) * 3600 +
            int.parse(data1.thoiGianDuKien.split(':')[1]) * 60) -
        (now.hour * 3600 + now.minute * 60 + now.second));
    if (tmp > 0) {
      return "Còn " +
          (tmp ~/ 3600).toString() +
          " giờ " +
          ((tmp % 3600) ~/ 60).toString() +
          " phút " +
          ((tmp % 3600) % 60).toString() +
          " giây ";
    } else {
      return "Đã tới giờ khám";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Xây dựng view thông tin của bệnh nhân
    return FutureBuilder(
        future: fetchClinic(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: PreferredSize(
                    child: Column(
                      children: <Widget>[
                        PreferredSize(
                            child: AppBar(
                              title: Text("Bệnh nhân khác"),
                              centerTitle: true,
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.blueAccent,
                            ),
                            preferredSize: Size.fromHeight(15.0)),
                        Card(
                            elevation: 5.0,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Bệnh nhân",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          data1,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          data2,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "đang có " + data3 + " cuộc hẹn",
                                      style: TextStyle(color: Colors.grey[300]),
                                    )
                                  ],
                                ))),
                      ],
                    ),
                    preferredSize: Size.fromHeight(152.0)),
                body:
                    //Xây dựng view Cân lâm sàng và lâm sàng của bệnh nhân khác
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _clinic.lamSang.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ExpandableNotifier(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ExpandablePanel(
                                header: Container(
                                    decoration: BoxDecoration(
                                        color: colorByState(
                                            _clinic.lamSang[index]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0))),
                                    child: Card(
                                        elevation: 5.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  _clinic.lamSang[index]
                                                      .tenChuyenKhoa,
                                                  style: TextStyle(
                                                      color: Colors.blue[800],
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  _clinic
                                                      .lamSang[index].maPhong,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "Lầu " +
                                                      _clinic.lamSang[index]
                                                          .tenLau,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  _clinic.lamSang[index].tenKhu,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  "Thời gian dự kiến",
                                                  style: TextStyle(
                                                      color: Colors.blue[800],
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  _clinic.lamSang[index]
                                                      .thoiGianDuKien,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(countingTime(
                                                    _clinic.lamSang[index]))
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  _clinic.lamSang[index]
                                                      .maPhieuKham,
                                                  style: TextStyle(
                                                    color: Colors.blue[700],
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                Text(
                                                  "Số hiện tại",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                Text(
                                                  _clinic.lamSang[index]
                                                              .sttHienTai
                                                              .toString() ==
                                                          'null'
                                                      ? '0'
                                                      : _clinic.lamSang[index]
                                                          .sttHienTai
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontSize: 25),
                                                ),
                                                IntrinsicHeight(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.0,
                                                                horizontal:
                                                                    25.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: colorByState(
                                                                  _clinic.lamSang[
                                                                      index]),
                                                              width: 2.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(
                                                              "Số của bạn",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25,
                                                              ),
                                                            ),
                                                            Text(
                                                              sttTheoTinhTrangClinical(
                                                                  _clinic.lamSang[
                                                                      index]),
                                                              style: TextStyle(
                                                                color: colorByState(
                                                                    _clinic.lamSang[
                                                                        index]),
                                                                fontSize: 40,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            )
                                          ],
                                        ))),
                                // Cận lâm sàng
                                expanded:
                                    /*SizedBox(
                                  height: (MediaQuery.of(context).size.height - 100.0),
                                  child: */
                                    GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: _clinic.canLamSang.length,
                                        gridDelegate:
                                            new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return new GestureDetector(
                                            child: new ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: colorSubByState(
                                                          _clinic.canLamSang[
                                                              index]),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  3.0))),
                                                  child: Card(
                                                    elevation: 2.0,
                                                    child: new Container(
                                                        padding: new EdgeInsets
                                                                .symmetric(
                                                            vertical: 1.0,
                                                            horizontal: 5.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              _clinic
                                                                  .canLamSang[
                                                                      index]
                                                                  .tenPhong,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontSize: 18),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Container(
                                                              padding: new EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      0.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Phòng",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ),
                                                                  Text(
                                                                    _clinic
                                                                        .canLamSang[
                                                                            index]
                                                                        .maPhongCls,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black45,
                                                                        fontSize:
                                                                            15),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: new EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      0.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Lầu " +
                                                                        _clinic
                                                                            .canLamSang[index]
                                                                            .tenLau,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ),
                                                                  Text(
                                                                    _clinic
                                                                        .canLamSang[
                                                                            index]
                                                                        .tenKhu,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black45,
                                                                        fontSize:
                                                                            15),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: new EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      0.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Thời gian",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ),
                                                                  Text(
                                                                    _clinic
                                                                        .canLamSang[
                                                                            index]
                                                                        .thoiGianDuKien,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black45,
                                                                        fontSize:
                                                                            15),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: new EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      0.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Số hiện tại",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ),
                                                                  Text(
                                                                    _clinic.canLamSang[index].sttXetNghiem ==
                                                                            'null'
                                                                        ? _clinic
                                                                            .canLamSang[
                                                                                index]
                                                                            .sttHienTai
                                                                        : _clinic
                                                                            .canLamSang[index]
                                                                            .sttXetNghiem,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .lightBlue,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                                padding: new EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        0.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "Số của bạn",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                    ),
                                                                    Text(
                                                                      sttTheoTinhTrangSubclinical(
                                                                          _clinic
                                                                              .canLamSang[index]),
                                                                      style: TextStyle(
                                                                          color: colorSubByState(_clinic.canLamSang[
                                                                              index]),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    )
                                                                  ],
                                                                )),
                                                          ],
                                                        )),
                                                  )),
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
                                                  content: new Text(
                                                      "Selected Item $index"),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: new Text("OK"))
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }) /*)*/,
                                tapHeaderToExpand: true,
                                hasIcon: false,
                              )
                            ],
                          ));
                        }));
          } else {
            return Scaffold(
                body: new Center(
              child: new CircularProgressIndicator(),
            ));
          }
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (timer.isActive) {
      timer.cancel();
    }
    dataSub.cancel();
    if (timer2.isActive) {
      timer2.cancel();
    }
    super.dispose();
  }
}
