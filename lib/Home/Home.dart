import 'package:flutter/material.dart';
import 'package:flutter_app/History/History.dart';
import 'package:flutter_app/Utils/Words.dart';
import 'package:flutter_app/Home/Fragments/HomeFragment.dart';
import 'package:flutter_app/Home/Fragments/SettingFragment.dart';
///author:nhatlq

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final words = new Word();
  int _currentIndex =2;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _children.length, vsync: this,initialIndex: 2);
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
    Text("1"),
    History(),
    HomeFragment(),
    Text("4"),
    SettingFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _children.length,
        child: TabBarView(children: _children,controller: _tabController,),
      )
      ,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          //Mau nen
            canvasColor: Colors.blue,
            //Mau icon active
            primaryColor: Colors.red,
            textTheme: TextTheme(caption: TextStyle(color: Colors.orange))
        ),
        child: BottomNavigationBar(
          fixedColor:Colors.black,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.search), title: Text(Word.BNB_Search)),
            BottomNavigationBarItem(
                icon: const Icon(Icons.history), title: Text(Word.BNB_History)),
            BottomNavigationBarItem(
                icon: new Icon(Icons.home), title: Text(Word.BNB_Home)),
            BottomNavigationBarItem(
                icon: new Icon(Icons.person), title: Text(Word.BNB_Profile)),
            BottomNavigationBarItem(
                icon: new Icon(Icons.settings), title: Text(Word.BNB_Setting)),
          ],
          onTap: onTabTapped,
        ),
      ),
    );
  }


  void _handleTabSelection() {
    setState(() {
      _currentIndex=_tabController.index;
    });
  }
}
