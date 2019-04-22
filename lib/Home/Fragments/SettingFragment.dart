import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Words.dart' as words;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingFragmentState();
  }
}

class _SettingFragmentState extends State<SettingFragment> {
  List _time = ["5 phút", "10 phút", "15 phút"];
  List _repeat = ["Không lặp", "2 lần", "5 lần"];
  List<DropdownMenuItem<String>> _timeDropdownItems, _repeatDropdownItems;
  String _currentTime, _currentRepeat;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    _timeDropdownItems = getDropDownItems(_time);
    _repeatDropdownItems = getDropDownItems(_repeat);
    _currentTime = _timeDropdownItems[0].value;
    _currentRepeat = _repeatDropdownItems[0].value;
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification:onSelecNofitication);
  }

  List<DropdownMenuItem<String>> getDropDownItems(List type) {
    List<DropdownMenuItem<String>> items = new List();
    for (String time in type) {
      items.add(new DropdownMenuItem(
        child: Text(time),
        value: time,
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text(words.Word.BNB_Setting),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blueAccent,
            ),
            preferredSize: Size.fromHeight(30.0)),
        body: Container(
          decoration: BoxDecoration(color: Colors.white10),
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Báo trước",
                          style: TextStyle(color: Colors.blue, fontSize: 20.0),
                        ),
                        DropdownButton(
                          value: _currentTime,
                          items: _timeDropdownItems,
                          onChanged: changeDropdownItems,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 5.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Lặp lại",
                          style: TextStyle(color: Colors.blue, fontSize: 20.0),
                        ),
                        DropdownButton(
                          value: _currentRepeat,
                          items: _repeatDropdownItems,
                          onChanged: changeDropdownItemsRepeat,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }


  void changeDropdownItems(String value) {
    setState(() {
      _currentTime = value;
    });
      _showNotificationWithoutSound();

  }

  void changeDropdownItemsRepeat(String value) {
    setState(() {
      _currentRepeat = value;
    });
  }

  Future onSelecNofitication(String payload) async {
    showDialog(context: context,
      builder: (_)=>AlertDialog(
        title: const Text("Nhắc nhở"),
        content: Text("Hãy đến phòng khám: $payload"),
      )
    );
  }
  Future _showNotificationWithoutSound() async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(minutes: 1));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'umc_notification', 'UMC Notification', '',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    int minutesIncrement = 1;
    var dateTimeNow = DateTime.now().toLocal();

    for(int i=1;i<=12;i++){
      var scheduledNotificationDateTime = dateTimeNow.add(new Duration(minutes: minutesIncrement));
      await flutterLocalNotificationsPlugin.schedule(
          i,
          'scheduled title $i',
          'scheduled: $scheduledNotificationDateTime',
          scheduledNotificationDateTime,
          platformChannelSpecifics);
      minutesIncrement= minutesIncrement+1;
    }
    /*await flutterLocalNotificationsPlugin.schedule(
      0,
      'Thông báo',
      'Đã đến giờ giám, nhấp vào để xem chi tiết!',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: 'tên phòng',
    );*/
  }
}
