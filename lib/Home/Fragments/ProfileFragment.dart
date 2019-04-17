import 'package:flutter/material.dart';

class ProfileFragment extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileFragment();
  }
}

class _ProfileFragment extends State<ProfileFragment>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text("Hồ sơ"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blueAccent,
          ),
          preferredSize: Size.fromHeight(30.0)),
    );
  }
}
//
//Widget profile(){
//  return
//}