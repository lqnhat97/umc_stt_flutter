import 'package:flutter/material.dart';

class ProfileFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileFragment();
  }
}

class _ProfileFragment extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String data1 = "TestData1";
    String data2 = "TestData2";
    String data3 = "TestData3";
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
                  padding:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Họ và tên",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 25),
                      ),
                      Text(
                        data1,
                        style: TextStyle(color: Colors.black45, fontSize: 25),
                      )
                    ],
                  ),
                )),

            //Card birthday
            Card(
                elevation: 2.0,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Ngày Sinh",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 25),
                      ),
                      Text(
                        data2,
                        style: TextStyle(color: Colors.black45, fontSize: 25),
                      )
                    ],
                  ),
                )),
//Card gender
            Card(
                elevation: 2.0,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
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
                        data3,
                        style: TextStyle(color: Colors.black45, fontSize: 25),
                      )
                    ],
                  ),
                )),

            Card(
                elevation: 2.0,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
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
                        data3,
                        style: TextStyle(color: Colors.black45, fontSize: 25),
                      )
                    ],
                  ),
                )),
            const SizedBox(
              height: 10.0,
            ),
            RaisedButton(
                onPressed: null,
                textColor: Colors.white,
                elevation: 5.0,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                padding:  EdgeInsets.all(0.0),
                child: Container(

                  padding:  EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                  decoration:  BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    "ĐẶT LỊCH KHÁM NGAY",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )),

            //Image(image: )
          ],
        ));
  }
}
//
//Widget profile(){
//  return
//}
