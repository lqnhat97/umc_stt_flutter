import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Request/Clinic.dart';

class SearchedPatient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchedPatientState();
  }
}

class _SearchedPatientState extends State<SearchedPatient> {
  static Clinic _clinic;

  @override
  Widget build(BuildContext context) {
    /*List<Clinical> clinicalData = _clinic.lamSang;
    List<Subclinical> data = _clinic.canLamSang;*/
    String data1 = "testData1";
    String data2 = "testData2";
    String data3 = "testData3";
    // Xây dựng view thông tin của bệnh nhân
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text("Bệnh nhân khác"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blueAccent,
          ),
          preferredSize: Size.fromHeight(30.0)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
              elevation: 5.0,
              child: Padding(padding:EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), child: Column(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

          //Xây dựng view Cân lâm sàng và lâm sàng của bệnh nhân khác
          /*ListView.builder(
              itemCount: clinicalData.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpandableNotifier(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExpandablePanel(
                      header: Card(
                          elevation: 5.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Phòng khám",
                                    style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    clinicalData[index].maPhong,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
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
                                  Text("còn ... h ... phút")
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Số hiện tại",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    clinicalData[index].sttHienTai.toString(),
                                    style: TextStyle(
                                        color: Colors.blueAccent, fontSize: 25),
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 25.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blue[700],
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
                                                  color: Colors.blue[700],
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
                      expanded: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: GridView.builder(
                              itemCount: data.length,
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      data[index].maPhongCls,
                                                      style: TextStyle(
                                                          color: Colors.black45,
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
                                                      "Thời gian",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      data[index]
                                                          .thoiGianDuKien,
                                                      style: TextStyle(
                                                          color: Colors.black45,
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
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      data[index]
                                                          .sttHienTai
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.lightBlue,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                        "Số của bạn",
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
                                                        data[index]
                                                            .stt
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.right,
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
                                        content:
                                            new Text("Selected Item $index"),
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
                              })),
                      tapHeaderToExpand: true,
                      hasIcon: false,
                    )
                  ],
                ));
              })*/
        ],
      ),
    );
  }
}
