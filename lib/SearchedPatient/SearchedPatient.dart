import 'dart:convert';
import 'package:flutter_app/Login/Login.dart';


import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Home/Fragments/ScanSearchedPatientHolder.dart';
import 'package:flutter_app/Request/Clinic.dart';
import 'package:flutter_app/Request/Profile.dart';
import 'package:http/http.dart'as http;
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

  List<Subclinical> data;
  String data1 = "testData1";
  String data2 = "testData2";
  String data3 = "testData3";

  /*Future<Profile> fetchProfile() async {
    final String url2 = "http://192.168.1.7:8088/patient/" + barcode;
    final response2 = await http.get(url2);
    //Neu thong tin tra ve la dung
    if (response2.statusCode == 200) {
      searchedPatientProfile = Profile.fromJson(json.decode(response2.body));
      setState(() {
        data1 = searchedPatientProfile.lastName +
            searchedPatientProfile.middleName +
            searchedPatientProfile.firstName;
        data2 = searchedPatientProfile.birthDay;
        data3 = (_clinic.lamSang.length + _clinic.canLamSang.length).toString();
        return searchedPatientProfile;
      });
    } else
      throw Exception('Fail');
  }*/

  ///Lay thong tin kham benh
  Future<Clinic> fetchClinic() async {
    //Client client = http();
    //Client client2 = Client();
    final String url = words.Word.ip + "/clinic/thongtinkhambenh/" + barcode;
    final String url2 = words.Word.ip + "/patient/" + barcode;

    final response = await http.get(url);
    final response2 = await http.get(url2);
    //final response2 = await client2.get(url2);
    //Neu thong tin tra ve la dung
    if (response.statusCode == 200 && response2.statusCode == 200) {//&& response2.statusCode == 200) {
      //setState(() {
        _clinic = Clinic.fromJson(json.decode(response.body));
        http.post(words.Word.ip +'/history?idBn='+Login.result+"&idBnSearch="+barcode);

        searchedPatientProfile = Profile.fromJson(json.decode(response2.body));
        data1 = searchedPatientProfile.lastName +" "+
            (searchedPatientProfile.middleName==""?"": (searchedPatientProfile.middleName+" "))+
            searchedPatientProfile.firstName;
        data2= searchedPatientProfile.birthDay;
        data3 = (_clinic.lamSang.length + _clinic.canLamSang.length).toString();
        return _clinic;
      //});
    } else
      throw Exception('Fail');
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        data2.substring(0,10),
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
                              header: Card(
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
                                            _clinic.lamSang[index].tenChuyenKhoa,
                                            style: TextStyle(
                                                color: Colors.blue[800],
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _clinic.lamSang[index].maPhong,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Lầu " + _clinic.lamSang[index].tenLau,
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _clinic.lamSang[index].thoiGianDuKien,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("còn ... h ... phút")
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
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
                                                .toString()=='null'?'0':_clinic.lamSang[index]
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
                                                        color: Colors.blue[700],
                                                        width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
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
                                                        _clinic.lamSang[index]
                                                            .stt
                                                            .toString(),
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
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
                                  )),
                              // Cận lâm sàng
                              expanded: /*SizedBox(
                                  height: (MediaQuery.of(context).size.height - 100.0),
                                  child: */GridView.builder(
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
                                            child: Card(
                                              elevation: 2.0,
                                              child: new Container(
                                                  padding:
                                                      new EdgeInsets.symmetric(
                                                          vertical: 1.0,
                                                          horizontal: 5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        _clinic.canLamSang[index].tenPhong,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .blueAccent,
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
                                                              "Phòng",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Text(
                                                              _clinic.canLamSang[index]
                                                                  .maPhongCls,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontSize: 15),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: new EdgeInsets.symmetric(
                                                            vertical: 5, horizontal: 0.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "Lầu "+ _clinic.canLamSang[index].tenLau,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 15),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            Text(
                                                              _clinic.canLamSang[index].tenKhu,
                                                              style: TextStyle(
                                                                  color: Colors.black45,
                                                                  fontSize: 15),
                                                              textAlign: TextAlign.right,
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
                                                                  fontSize: 15),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Text(
                                                              _clinic.canLamSang[index]
                                                                  .thoiGianDuKien,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontSize: 15),
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
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Text(
                                                              _clinic.canLamSang[index]
                                                                  .sttHienTai
                                                                  .toString()=='nul'?'0':_clinic.canLamSang[index]
                                                                  .sttHienTai
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .lightBlue,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                                                _clinic.canLamSang[index]
                                                                    .stt
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
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
                                      })/*)*/,
                              tapHeaderToExpand: true,
                              hasIcon: false,
                            )
                          ],
                        ));
                      })


            );
          } else {
            return Scaffold(
                body: new Center(
              child: new CircularProgressIndicator(),
            ));
          }
        });
  }
}
