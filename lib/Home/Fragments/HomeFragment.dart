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
import 'package:flutter_app/Widget/BlinkAnimation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  _getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.userNotiTime = prefs.getInt('time') ?? 15;
  }

  @override
  void initState() {
    super.initState();
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSetting = new InitializationSettings(android, ios);
    Future onSelectNotification(String payload) async {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }

    _flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: onSelectNotification);
    fetchClinic();
    _getTime();
    // defines a timer

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      dataSub = fetchClinic().asStream().listen((Clinic data) {
        if (!mounted) return;
        buildNotification();
        setState(() {
          _clinic = data;
        });
      });
    });

    timer2 = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (!mounted) return;
      setState(() {
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

    vibrationPattern[0] = 1000;

    vibrationPattern[1] = 1000;

    vibrationPattern[2] = 1000;

    vibrationPattern[3] = 1000;

    vibrationPattern[4] = 1000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      largeIcon: "@mipmap/ic_launcher",
      icon: "@mipmap/ic_launcher",
      color: Colors.blueAccent,
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

  //Màu sắc
  Color colorByState(Clinical data1) {
    if (data1.tinhTrang == 'Đang khám') {
      return Colors.grey;
    }
    if (data1.tinhTrang == 'Đã khám') {
      return Color.fromARGB(255, 43, 182, 115);
    }
    int tmp = ((int.parse(data1.thoiGianDuKien.split(':')[0]) * 3600 +
            int.parse(data1.thoiGianDuKien.split(':')[1]) * 60) -
        (now.hour * 3600 + now.minute * 60 + now.second));
    int tmp2 = data1.sttHienTai - data1.stt;
    if (data1.sttHienTai == data1.stt) {
      return Color.fromARGB(255, 43, 182, 115);
    }
    if ((tmp2 >= 0)) {
      return Color.fromARGB(255, 191, 0, 0);
    }
    if ((tmp <= userNotiTime * 60)) {
      return Colors.grey;
    } else {
      return Colors.grey;
    }
  }

  Color colorSubByState(Subclinical data1) {
    if (data1.tinhTrang == 'Đang khám') {
      return Colors.grey;
    }
    if (data1.tinhTrang == 'Đã khám') {
      return Color.fromARGB(255, 43, 182, 115);
    }
    int tmp = ((int.parse(data1.thoiGianDuKien.split(':')[0]) * 3600 +
            int.parse(data1.thoiGianDuKien.split(':')[1]) * 60) -
        (now.hour * 3600 + now.minute * 60 + now.second));
    int tmp2 = int.parse(data1.sttHienTai) - data1.stt;
    if (int.parse(data1.sttHienTai) == data1.stt) {
      return Color.fromARGB(255, 43, 182, 115);
    }
    if ((tmp2 > 0)) {
      return Color.fromARGB(255, 191, 0, 0);
    }
    if ((tmp <= userNotiTime * 60)) {
      return Colors.grey;
    } else {
      return Colors.grey;
    }
  }

  //Icon
  Widget IconByState(Clinical data1) {
    if (data1.tinhTrang == 'Đang khám') {
      return Container();
    }
    if (data1.tinhTrang == 'Đã khám') {
      return Icon(Icons.check_circle, size: 50.0, color: colorByState(data1));
    }
    int tmp = ((int.parse(data1.thoiGianDuKien.split(':')[0]) * 3600 +
            int.parse(data1.thoiGianDuKien.split(':')[1]) * 60) -
        (now.hour * 3600 + now.minute * 60 + now.second));
    int tmp2 = data1.sttHienTai - data1.stt;
    if (data1.sttHienTai == data1.stt) {
      return Container();
    }
    if ((tmp2 >= 0)) {
      return IconButton(
          padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.13,
              bottom: MediaQuery.of(context).size.height * 0.07),
          icon: Icon(
            Icons.cancel,
            size: 75.0,
            color: colorByState(data1),
          ),onPressed: (){yeuCauKhamLamSang(data1);},);
    }
    if ((tmp <= userNotiTime * 60)) {
      return Container();
    } else {
      return Container();
    }
  }

  Future<dynamic> yeuCauKhamLamSang(Clinical data) async {
    Map<String, dynamic> match = {
      "stt":data.stt,
      "idPhieuKham": data.maPhieuKham,
      "idPhong": data.idPhong,
      "idBan":data.idBan,
      "caKham":data.caKham
    };
    var headers = {'Content-Type': 'application/json'};
    String jsonString = json.encode(match);
    Uri uri = Uri.parse(words.Word.ip + '/clinic/yeuCauKhamLaiLamSang');
    final response = await http.post(uri,
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
              content: Text("Đã gửi yêu cầu thành công hãy đến phòng khám"),
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
              content: Text("Gửi yêu cầu thất bại"),
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

  Widget IconByStateSub(Subclinical data1) {
    if (data1.tinhTrang == 'Đang khám') {
      return Container();
    }
    if (data1.tinhTrang == 'Đã khám') {
      return Icon(Icons.check_circle,
          size: 50.0, color: colorSubByState(data1));
    }
    int tmp = ((int.parse(data1.thoiGianDuKien.split(':')[0]) * 3600 +
            int.parse(data1.thoiGianDuKien.split(':')[1]) * 60) -
        (now.hour * 3600 + now.minute * 60 + now.second));
    int tmp2 = int.parse(data1.sttHienTai) - data1.stt;
    if (int.parse(data1.sttHienTai) == data1.stt) {
      return Container();
    }
    if ((tmp2 >= 0)) {
      return data1.sttXetNghiem=="null"?  IconButton(padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.07,
          bottom: MediaQuery.of(context).size.height * 0.038),icon:Icon(
        Icons.cancel,
        size: 50.0,
        color: colorSubByState(data1),
      ),onPressed: (){
        yeuCauKhamCanLamSang(data1);
      },):Icon(
        Icons.cancel,
        size: 50.0,
        color: colorSubByState(data1),
      );
    }
    if ((tmp <= userNotiTime * 60)) {
      return Container();
    } else {
      return Container();
    }
  }


  Future<dynamic> yeuCauKhamCanLamSang(Subclinical data) async {
    Map<String, dynamic> match = {
      "stt":data.stt,
      "idPhieuKham": data.maPhieuKham,
      "idPhong": data.idPhong,
      "caKham":data.caKham
    };
    var headers = {'Content-Type': 'application/json'};
    String jsonString = json.encode(match);
    Uri uri = Uri.parse(words.Word.ip + '/clinic/yeuCauKhamLaiCanLamSang');
    final response = await http.post(uri,
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
              content: Text("Đã gửi yêu cầu thành công hãy đến phòng khám"),
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
              content: Text("Gửi yêu cầu thất bại"),
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
//Tình trạng
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
      if (data.sttXetNghiem != "null") {
        if (data.stt <= int.parse(data.sttXetNghiem.split("->")[1])) ;
        {
          return data.stt.toString();
        }
      }
      return data.stt.toString();
    }
  }

  //Tạo ra notification
  void buildNotification() {
    int channel_id_for_all = 0;
    _clinic.lamSang.forEach((clinical) {
      if (clinical.tinhTrang != 'Đã khám' &&
          clinical.tinhTrang != 'Đang khám') {
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
            (displayTime >= 0 && displayTime < userNotiTime * 60
                    ? displayTime.toString() + " phút tới giờ hẹn phòng khám "
                    : "Đã đến giờ khám ") +
                clinical.tenChuyenKhoa,
            "Hãy đến " +
                clinical.maPhong +
                " tại " +
                clinical.tenKhu +
                " Lầu " +
                clinical.tenLau,
            notiTime);
        channel_id_for_all++;
      }
    });

    _clinic.canLamSang.forEach((subClinical) {
      if (subClinical.tinhTrang != 'Đang khám' &&
          subClinical.tinhTrang != 'Đã khám') {
        int tmp = (int.parse(subClinical.sttHienTai) - subClinical.stt);
        int notiTime; //notification time
        int displayTime;
        if (tmp >= 0 && tmp <= 2) {
          notiTime = 0;
          displayTime =
              ((int.parse(subClinical.thoiGianDuKien.split(':')[0]) * 3600 +
                          int.parse(subClinical.thoiGianDuKien.split(':')[1]) *
                              60) -
                      (now.hour * 3600 + now.minute * 60)) -
                  userNotiTime * 60;
        } else {
          notiTime =
              ((int.parse(subClinical.thoiGianDuKien.split(':')[0]) * 3600 +
                          int.parse(subClinical.thoiGianDuKien.split(':')[1]) *
                              60) -
                      (now.hour * 3600 + now.minute * 60)) -
                  userNotiTime * 60;

          displayTime =
              ((int.parse(subClinical.thoiGianDuKien.split(':')[0]) * 3600 +
                          int.parse(subClinical.thoiGianDuKien.split(':')[1]) *
                              60) -
                      (now.hour * 3600 + now.minute * 60)) -
                  userNotiTime * 60;
        }
        _showNotificationWithDefaultSound(
            channel_id_for_all,
            (displayTime >= 0 && displayTime < userNotiTime * 60
                    ? displayTime.toString() + " phút tới giờ hẹn cận lâm sàng "
                    : "Đã đến giờ thực hiện ") +
                subClinical.tenPhong,
            "Hãy đến " +
                subClinical.maPhongCls +
                " tại " +
                subClinical.tenKhu +
                " Lầu " +
                subClinical.tenLau,
            notiTime);
        channel_id_for_all++;
      }
    });
  }

  ///Man hinh kham benh
  Widget homeWidget(BuildContext context) {
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
                    header: Stack(children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              color: colorByState(clinicalData[index]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          child: Card(
                            elevation: 5.0,
                            child: Column(
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                        color:
                                            colorByState(clinicalData[index])),
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 0.0, 0.0, 0.0),
                                    child: Center(
                                      child: Text(
                                        clinicalData[index].tenChuyenKhoa,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          clinicalData[index].maPhong,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Bàn " + clinicalData[index].ban,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Lầu " +
                                                  clinicalData[index].tenLau,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Text(
                                              clinicalData[index].tenKhu,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
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
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          countingTime(clinicalData[index]),
                                          style: TextStyle(
                                              color: colorByState(
                                                  clinicalData[index])),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
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
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Số của bạn",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 25.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: colorByState(
                                                          clinicalData[index]),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    Flexible(
                                                        child: Text(
                                                      sttTheoTinhTrangClinical(
                                                          clinicalData[index]),
                                                      style: TextStyle(
                                                          color: colorByState(
                                                              clinicalData[
                                                                  index]),
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
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
                                )
                              ],
                            ),
                          )),
                      IconByState(clinicalData[index])
                    ], alignment: Alignment.bottomRight),

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
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(2.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  colorSubByState(data[index]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0))),
                                          child: Card(
                                            elevation: 2.0,
                                            child: new Container(
                                                padding:
                                                    new EdgeInsets.symmetric(
                                                        vertical: 1.0,
                                                        horizontal: 5.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      data[index].tenPhong ==
                                                              'null'
                                                          ? 'Xét nghiệm'
                                                          : data[index]
                                                              .tenPhong,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.blue[800],
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                            data[index].maPhongCls ==
                                                                    'null'
                                                                ? 'Xét nghiệm'
                                                                : data[index]
                                                                    .maPhongCls,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
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
                                                            "Lầu " +
                                                                data[index]
                                                                    .tenLau,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          Text(
                                                            data[index].tenKhu,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontSize: 15),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
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
                                                            "Thời gian",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          Text(
                                                            data[index]
                                                                .thoiGianDuKien,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black38,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
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
                                                            "Số hiện tại",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                                ? data[index]
                                                                    .sttHienTai
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
                                                    Flexible(
                                                      child: Container(
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
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                              Text(
                                                                sttTheoTinhTrangSubclinical(
                                                                    data[
                                                                        index]),
                                                                style: TextStyle(
                                                                    color: colorSubByState(
                                                                        data[
                                                                            index]),
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ],
                                                )),
                                          )),
                                      IconByStateSub(data[index])
                                    ],
                                    alignment: Alignment.bottomRight,
                                  ));
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
    timer?.cancel();
    dataSub?.cancel();
    timer2?.cancel();
    super.dispose();
  }


}
