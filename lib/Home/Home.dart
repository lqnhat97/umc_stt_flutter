import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Words.dart';
import 'package:flutter_app/Home/Fragments/HomeFragment.dart';
///author:nhatlq

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final words = new Word();
  int _currentIndex = 0;

  //Moi lan nhan qua icon khac
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
    Text("1"),
    Text("2"),
    HomeFragment(),
    Text("4"),
    Text("5"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _children[_currentIndex]
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          //Mau nen
            canvasColor: Colors.blue,
            //Mau icon active
            primaryColor: Colors.blue,
            textTheme: TextTheme(caption: TextStyle(color: Colors.blue))
        ),
        child: BottomNavigationBar(
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
}
