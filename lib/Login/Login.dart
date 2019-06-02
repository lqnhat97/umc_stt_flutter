import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Home/Home.dart';
import 'package:flutter_app/Utils/Words.dart' as words;
import 'package:http/http.dart' as http;

///author: nhatlq

class Login extends StatefulWidget {
  static String result = "";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<dynamic> fetchClinc(String barcodeResult) async {
    if (barcodeResult != "") {
      final String url =
          words.Word.ip + "/clinic/thongtinkhambenh/" + barcodeResult;
      final response = await http.get(url);
      //Neu thong tin tra ve la dung
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else
        throw Exception('Fail');
    }
  }

  ///Scan barcode
  Future _scanBarcode() async {
    try {
      String barcodeResult = await BarcodeScanner.scan();
      setState(() {
        Login.result = barcodeResult;
      });
      fetchClinc(barcodeResult);
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
                    image: AssetImage('images/LOGIN 1.jpg'),fit: BoxFit.fill)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
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
                    height: 120,width: 120, alignment: new Alignment(-1.0, -1.5)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
