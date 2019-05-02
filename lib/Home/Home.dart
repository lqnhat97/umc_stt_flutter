import 'package:flutter/material.dart';
import 'package:flutter_app/History/HistoryFragment.dart';
import 'package:flutter_app/Home/Fragments/HomeFragment.dart';
import 'package:flutter_app/Home/Fragments/ProfileFragment.dart';
import 'package:flutter_app/Home/Fragments/ScanSearchedPatientHolder.dart';
import 'package:flutter_app/Home/Fragments/SettingFragment.dart';
import 'package:flutter_app/Utils/Words.dart' as words;

///author:nhatlq, vinhhnq

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 2;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        TabController(length: _children.length, vsync: this, initialIndex: 2);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  //Moi lan nhan qua icon khac
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _tabController.animateTo(_currentIndex);
  }


  final List<Widget> _children = [
    ScanSearchedPatientHolder(),
    History(),
    HomeFragment(),
    ProfileFragment(),
    SettingFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _children.length,
        child: TabBarView(
          children: _children,
          controller: _tabController,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.search,
                color: Colors.blueAccent,
              ),
              title: Text(
                words.Word.BNB_Search,
                style: TextStyle(color: Colors.blueAccent),
              )),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.history,
                color: Colors.blueAccent,
              ),
              title: Text(
                words.Word.BNB_History,
                style: TextStyle(color: Colors.blueAccent),
              )),
          BottomNavigationBarItem(
              icon: new Icon(Icons.home, color: Colors.blueAccent),
              title: Text(
                words.Word.BNB_Home,
                style: TextStyle(color: Colors.blueAccent),
              )),
          BottomNavigationBarItem(
              icon: new Icon(Icons.person, color: Colors.blueAccent),
              title: Text(
                words.Word.BNB_Profile,
                style: TextStyle(color: Colors.blueAccent),
              )),
          BottomNavigationBarItem(
              icon: new Icon(Icons.settings, color: Colors.blueAccent),
              title: Text(
                words.Word.BNB_Setting,
                style: TextStyle(color: Colors.blueAccent),
              )),
        ],
        onTap: onTabTapped,
      ),
    );
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }
}

