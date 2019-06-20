import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Home/Home.dart';
import 'package:flutter_app/Nurse/NurseState.dart';
import 'package:flutter_app/Utils/Words.dart' as words;
import 'package:http/http.dart' as http;

///author: nhatlq

class Login extends StatefulWidget {
  static String result = "";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<dynamic> fetchClinic(String barcodeResult) async {
    if (barcodeResult != "") {
      final String url =
          words.Word.ip + "/clinic/thongtinkhambenh/" + barcodeResult;
      final String url2 = words.Word.ip + "/clinic/thuki/" + barcodeResult;
      final response = await http.get(url);
      final response2 = await http.get(url2);
      //Neu thong tin tra ve la dung
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
      else if (response2.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NurseState()));
      } else {
        AlertDialog alertDialog = new AlertDialog(
            title: new Text("Lỗi"),
            content: new Text("Không tìm thấy bệnh nhân"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Đóng"),
                onPressed: () {
                  Navigator.of(this.context).pop();
                },
              )
            ]);
        showDialog(context: this.context, child: alertDialog);
      }
    }
  }

  ///Scan barcode
  Future _scanBarcode() async {
    try {
      String barcodeResult = await BarcodeScanner.scan();
      setState(() {
        Login.result = barcodeResult;
      });
      fetchClinic(barcodeResult);
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          Login.result = words.Word.Login_Camera_Denied;
        });
      } else {
        Login.result = words.Word.Login_Unknow_Error + " $ex";
      }
    } on FormatException {
      setState(() {
        Login.result = words.Word.Login_Press_Back_Button;
      });
    } catch (ex) {
      setState(() {
        Login.result = words.Word.Login_Unknow_Error + " $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/LOGIN 1.jpg'), fit: BoxFit.fill)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 450,
              ),
              Text(words.Word.Login_Guide,
                  style: new TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(
                height: 30,
              ),
              /* FloatingActionButton.extended(
                  onPressed: _scanBarcode,
                  icon: Icon(Icons.camera),
                  label: Text(words.Word.Login_Scan))*/
              GestureDetector(
                onTap: _scanBarcode,
                child: Image.asset('images/barcode.png',
                    height: 120,
                    width: 120,
                    alignment: new Alignment(-1.0, -1.5)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
