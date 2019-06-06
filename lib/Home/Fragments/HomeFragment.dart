import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/Request/Clinic.dart';
import 'package:flutter_app/Utils/Words.dart' as words;
import 'package:flutter_app/Utils/mSharedPreferencesTest.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

///author: nhatlq & vinhhnq

class HomeFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeFragmentState();
  }
}


class _HomeFragmentState extends State<HomeFragment> {
  mSharedPreferencesTest prefs;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  String barcode = Login.result;
  static Clinic _clinic;
  static Timer timer;
  static Timer timer2;
  DateTime now = new DateTime.now();
  int userNotiTime = 10;
  StreamSubscription<Clinic> dataSub;

  @override
  void initState() {
    super.initState();
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/umc_logo');
    var ios = new IOSInitializationSettings();
    var initSetting = new InitializationSettings(android, ios);
    Future onSelectNotification(String payload) async {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }

    _flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: onSelectNotification);
    fetchClinic();
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
    //userNotiTime = await prefs.getTime();
    final String url = words.Word.ip + "/clinic/thongtinkhambenh/" + barcode;
    final response = await http.get(url);

    //Neu thong tin tra ve la dung
    if (response.statusCode == 200) {
      //setState(() {
      _clinic = Clinic.fromJson(json.decode(response.body));

      //});
      return _clinic;
    } else
      throw Exception('Fail');
  }

  Future _showNotificationWithDefaultSound(
      int channel_ID, String title, String content, int duration) async {
    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: duration));
    var vibrationPattern = new Int64List(5);

    vibrationPattern[0] = 0;

    vibrationPattern[1] = 1000;

    vibrationPattern[2] = 5000;

    vibrationPattern[3] = 2000;

    vibrationPattern[4] = 3000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      icon: "umc_logo",
      playSound: true,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.schedule(
      channel_ID,
      title,
      content,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
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

  Color colorByState(Clinical data1) {
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


  void buildNotification(){
    int channel_id_for_all = 0;
    _clinic.lamSang.forEach((clinical) {
      int tmp = clinical.sttHienTai - clinical.stt;
      int notiTime;
      int displayTime;
      if (tmp >= 0 && tmp <= 2) {
        notiTime = 0;
        displayTime = ((int.parse(clinical.thoiGianDuKien.split(':')[0]) *
            3600 +
            int.parse(clinical.thoiGianDuKien.split(':')[1]) * 60) -
            (now.hour * 3600 + now.minute * 60)) -
            userNotiTime * 60;
      } else {
        notiTime = ((int.parse(clinical.thoiGianDuKien.split(':')[0]) * 3600 +
            int.parse(clinical.thoiGianDuKien.split(':')[1]) * 60) -
            (now.hour * 3600 + now.minute * 60)) -
            userNotiTime * 60;
        displayTime = ((int.parse(clinical.thoiGianDuKien.split(':')[0]) *
            3600 +
            int.parse(clinical.thoiGianDuKien.split(':')[1]) * 60) -
            (now.hour * 3600 + now.minute * 60)) -
            userNotiTime * 60;
      }
      _showNotificationWithDefaultSound(
          channel_id_for_all,
          (displayTime >= 0 ? displayTime.toString()+" phút tới giờ hẹn phòng khám "  :"Đã đến giờ khám " ) +
              clinical.tenChuyenKhoa,
          "Hãy đến " +
              clinical.maPhong +
              " tại " +
              clinical.tenKhu +
              " Lầu " +
              clinical.tenLau,
          notiTime);
      channel_id_for_all++;
    });

    _clinic.canLamSang.forEach((subClinical) {
      int tmp = (int.parse(subClinical.sttHienTai) - subClinical.stt);
      int notiTime;
      int displayTime;
      if (tmp >= 0 && tmp <= 2) {
        notiTime = 0;
        displayTime = ((int.parse(subClinical.thoiGianDuKien.split(':')[0]) *
            3600 +
            int.parse(subClinical.thoiGianDuKien.split(':')[1]) * 60) -
            (now.hour * 3600 + now.minute * 60)) -
            userNotiTime * 60;
      } else {
        notiTime = ((int.parse(subClinical.thoiGianDuKien.split(':')[0]) *
            3600 +
            int.parse(subClinical.thoiGianDuKien.split(':')[1]) * 60) -
            (now.hour * 3600 + now.minute * 60)) -
            userNotiTime * 60;
        displayTime = ((int.parse(subClinical.thoiGianDuKien.split(':')[0]) *
            3600 +
            int.parse(subClinical.thoiGianDuKien.split(':')[1]) * 60) -
            (now.hour * 3600 + now.minute * 60)) -
            userNotiTime * 60;
      }
      _showNotificationWithDefaultSound(
          channel_id_for_all,
          (displayTime >= 0 ? displayTime.toString()+" phút tới giờ hẹn cận lâm sàng "  :"Đã đến giờ thực hiện " ) +
              subClinical.tenPhong,
          "Hãy đến " +
              subClinical.maPhongCls +
              " tại " +
              subClinical.tenKhu +
              " Lầu " +
              subClinical.tenLau,
          notiTime);
      channel_id_for_all++;
    });
  }
  ///Man hinh kham benh
  Widget homeWidget(BuildContext context) {
    buildNotification();
    List<Clinical> clinicalData = _HomeFragmentState._clinic.lamSang;
    List<Subclinical> data = _HomeFragmentState._clinic.canLamSang;
    return Scaffold(
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: clinicalData.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpandableNotifier(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ExpandablePanel(
                    header: Container(
                        decoration: BoxDecoration(
                            color: colorByState(clinicalData[index]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0))),
                        child: Card(
                            elevation: 5.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35),
                                        child: Wrap(
                                            alignment: WrapAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                clinicalData[index]
                                                    .tenChuyenKhoa,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ])),
                                    Text(
                                      clinicalData[index].maPhong,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Lầu " + clinicalData[index].tenLau,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      clinicalData[index].tenKhu,
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      clinicalData[index].thoiGianDuKien,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(countingTime(clinicalData[index]))
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      clinicalData[index].maPhieuKham,
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
                                      clinicalData[index]
                                                  .sttHienTai
                                                  .toString() ==
                                              'null'
                                          ? '0'
                                          : clinicalData[index]
                                              .sttHienTai
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 25),
                                    ),
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 25.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:colorByState(clinicalData[index]),
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "Số của bạn",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                Text(
                                                  clinicalData[index]
                                                      .stt
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: colorByState(clinicalData[index]),
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
                        /* SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child:*/
                        GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: data.length,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                child: new ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: colorSubByState(data[index]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.0))),
                                      child: Card(
                                        elevation: 2.0,
                                        child: new Container(
                                            padding: new EdgeInsets.symmetric(
                                                vertical: 1.0, horizontal: 5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  data[index].tenPhong == 'null'
                                                      ? 'Xét nghiệm'
                                                      : data[index].tenPhong,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueAccent,
                                                      fontSize: 18),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Container(
                                                  padding:
                                                      new EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 0.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        "Phòng",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        data[index].maPhongCls ==
                                                                'null'
                                                            ? 'Xét nghiệm'
                                                            : data[index]
                                                                .maPhongCls,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      new EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 0.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        "Lầu " +
                                                            data[index].tenLau,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        data[index].tenKhu,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      new EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 0.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        "Thời gian",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        data[index]
                                                            .thoiGianDuKien,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.right,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      new EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 0.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        "Số hiện tại",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        data[index].sttXetNghiem ==
                                                                'null'
                                                            ? data[index].sttHienTai
                                                            : data[index]
                                                                .sttXetNghiem,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .lightBlue,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.right,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    padding: new EdgeInsets
                                                            .symmetric(
                                                        vertical: 5,
                                                        horizontal: 0.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          "Số của bạn",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        Text(
                                                          data[index]
                                                              .stt
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: colorSubByState(data[index]),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
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
                            }) /*)*/,
                    tapHeaderToExpand: true,
                    hasIcon: false,
                  )
                ],
              ));
            }));
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
        future: fetchClinic(),
        builder: (context, snapshot) {
          // Truong hop da co du lieu
          if (snapshot.hasData) {
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
