import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Booking/Booking.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/Request/Profile.dart';
import 'package:http/http.dart' as http;

class ProfileFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileFragment();
  }
}

class _ProfileFragment extends State<ProfileFragment> {
  String barcode = Login.result;
  static Profile _profile;
  String data1 = "TestData1";
  String data2 = "TestData2";
  String data3 = "TestData3";
  Future<Profile> fetchProfileRequest() async {
    final String urlHistory = "http://192.168.1.7:8088/patient/" + barcode;
    final responseHistory = await http.get(urlHistory);

    if (responseHistory.statusCode == 200) {
      //setState(() {
      _profile = Profile.fromJson(json.decode(responseHistory.body));
      data1 = _profile.lastName + _profile.middleName +_profile.firstName;
      data2 = _profile.birthDay;
      data3 = _profile.homeTowm;
      //});
      return _profile;
    } else
      throw Exception('Fail');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder(
        future: fetchProfileRequest(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Scaffold(
                appBar: PreferredSize(
                    child: AppBar(
                      title: Text("Hồ sơ"),
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.blueAccent,
                    ),
                    preferredSize: Size.fromHeight(30.0)),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Họ và tên",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 25),
                              ),
                              Text(
                                data1,
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 25),
                              )
                            ],
                          ),
                        )),

                    //Card birthday
                    Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Ngày Sinh",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 25),
                              ),
                              Text(
                                data2,
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 25),
                              )
                            ],
                          ),
                        )),
                    //Card gender
                    Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Giới tính",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                _profile.gender,
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 25),
                              )
                            ],
                          ),
                        )),

                    Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Địa chỉ",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                _profile.address,
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 25),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Booking()));
                      },
                      textColor: Colors.white,
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          "ĐẶT LỊCH KHÁM NGAY",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    //Image(image: )
                  ],
                ));
          else
            return Scaffold(
                appBar: PreferredSize(
                    child: AppBar(
                      title: Text("Hồ sơ"),
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.blueAccent,
                    ),
                    preferredSize: Size.fromHeight(30.0)),
                body: new CircularProgressIndicator());
        });
  }
}
//
//Widget profile(){
//  return
//}
