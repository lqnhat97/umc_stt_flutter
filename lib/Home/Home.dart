import 'package:flutter/material.dart';
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
    _tabController = TabController(length: _children.length, vsync: this);
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
    Text("2"),
    HomeFragment(),
    Text("4"),
    SettingFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dismissible(
        resizeDuration:null,
        onDismissed: onSwipping,
        key: new ValueKey(_currentIndex),
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


  void onSwipping(DismissDirection direction) {
    setState(() {
      _currentIndex+=direction == DismissDirection.endToStart ? 1 : -1;
    });
    _tabController.animateTo(_currentIndex);
  }
}
