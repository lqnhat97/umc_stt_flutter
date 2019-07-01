import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Words.dart' as words;
import 'package:flutter_app/Utils/mSharedPreferencesTest.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingFragmentState();
  }
}

class _SettingFragmentState extends State<SettingFragment> {
  List _time = ["15 phút", "20 phút", "30 phút"];
  List _repeat = ["Không lặp", "2 lần", "5 lần"];
  List<DropdownMenuItem<String>> _timeDropdownItems, _repeatDropdownItems;
  String _currentTime, _currentRepeat;

  FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get notifications => _notifications;

  //init Nofitication
//  Future init() async{
//    notifications.initialize(InitializationSettings(AndroidInitializationSettings('@mipmap/ic_launcher'), IOSInitializationSettings()));
//  }

  _setTime(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('time', int.parse(data));
  }

  _setAllowsNotifications(bool data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('allowNotifications', data);
  }

 _getTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int tmp =  prefs.getInt('time') ?? 15;
    if(!mounted) return;
    setState(() {
      _currentTime = tmp.toString()+" phút";
    });
    _setTime(_currentTime.split(' ')[0]);
  }

  @override
  void initState()   {
    _timeDropdownItems = getDropDownItems(_time);
    _repeatDropdownItems = getDropDownItems(_repeat);
     _getTime();
    _setAllowsNotifications(true);
    // TODO: implement initState
    super.initState();
    _notifications = new FlutterLocalNotificationsPlugin();
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
    _getTime();
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

              Card(child:Container(
                height: MediaQuery.of(context).size.height *
                    0.6,
                decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/huong_dan.png'), fit: BoxFit.fill)),
              ),)
            ],
          ),
        ));
  }

  void changeDropdownItems(String value) {
    _setTime(value.split(" ")[0]);
    setState(() {
      _currentTime = value;
    });
  }

  void changeDropdownItemsRepeat(String value) {
    setState(() {
      _currentRepeat = value;
    });
  }

}
