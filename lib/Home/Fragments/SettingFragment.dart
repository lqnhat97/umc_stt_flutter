import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Words.dart' as words;

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

  @override
  void initState() {
    _timeDropdownItems = getDropDownItems(_time);
    _repeatDropdownItems = getDropDownItems(_repeat);
    _currentTime = _timeDropdownItems[0].value;
    _currentRepeat = _repeatDropdownItems[0].value;
    // TODO: implement initState
    super.initState();
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
              /*Card(
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
                          "Chuông",
                          style: TextStyle(color: Colors.blue, fontSize: 20.0),
                        ),
                        Text("10 phút")
                      ],
                    ),
                  ),
                ),
              )*/
            ],
          ),
        ));
  }

  void changeDropdownItems(String value) {
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
