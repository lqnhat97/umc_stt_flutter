import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookingState();
  }
}

class _BookingState extends State<StatefulWidget> {
  String data = "testData";
  String data2 = "testData";
  var _clinic = ["Tai Mũi Họng", "Mắt", "Hô hấp"];
  var _clinicCurrentSelected = "Mắt";
  var _hour = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24"
  ];
  var _hourCurrentSelected = DateTime.now().hour + 1;
  var _minute = [
    "5",
    "10",
    "15",
    "20",
    "25",
    "30",
    "35",
    "40",
    "45",
    "50",
    "55",
    "60"
  ];
  var _minuteCurrentSelected = (DateTime.now().minute % 5 == 0)
      ? DateTime.now().minute
      : DateTime.now().minute + (5 - DateTime.now().minute % 5);

  DateTime _currentDate = DateTime.now();
  String strCurrentDate = "Chọn ngày khám";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text("Đặt lịch khám"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blueAccent,
            ),
            preferredSize: Size.fromHeight(30.0)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Avatar và tên của bệnh nhân
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('images/user_50.png', fit: BoxFit.cover),
                  Text(
                    data2,
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 45.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Row chuyên khoa
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'images/stethoscope_50.png',
                        fit: BoxFit.contain,
                      ),
                      DropdownButton<String>(
                        items: _clinic.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            this._clinicCurrentSelected = newValueSelected;
                          });
                        },
                        value: _clinicCurrentSelected,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Row lịch khám
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'images/calendar_50.png',
                        fit: BoxFit.contain,
                      ),
                      FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _builaCalendar(context));
                        },
                        child: Text(strCurrentDate),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Row giờ khám
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'images/time_50.png',
                        fit: BoxFit.contain,
                      ),
                      Row(
                        children: <Widget>[
                          DropdownButton<String>(
                            items: _hour.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (String newValueSelected) {
                              setState(() {
                                this._hourCurrentSelected =
                                    int.parse(newValueSelected);
                              });
                            },
                            value: _hourCurrentSelected.toString(),
                          ),
                          DropdownButton<String>(
                            items: _minute.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (String newValueSelected) {
                              setState(() {
                                this._minuteCurrentSelected =
                                    int.parse(newValueSelected);
                              });
                            },
                            value: _minuteCurrentSelected.toString(),
                          )
                        ],
                      ),
                    ],
                  ),
                  
                ],
              ),
            )
          ],
        ));
  }

  Widget _builaCalendar(BuildContext context) {
    return Material(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: CalendarCarousel(
              onDayPressed: (DateTime date, List<dynamic> list) => {
                    this.setState(() =>
                        strCurrentDate = DateFormat('dd/MM/yyyy').format(date)),
                    _currentDate = date,
                    Navigator.of(context).pop(),
                  },
              thisMonthDayBorderColor: Colors.grey,
              height: 420.0,
              selectedDateTime: _currentDate,
              daysHaveCircularBorder: true,

              /// null for not rendering any border, true for circular border, false for rectangular border
            )));
  }
}
