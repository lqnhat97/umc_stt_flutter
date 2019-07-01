import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Login/Login.dart';
import 'package:flutter_app/SearchedPatient/SearchedPatient.dart';
import 'package:flutter_app/Utils/Words.dart' as words;
import 'package:http/http.dart' as http;

class ScanSearchedPatientHolder extends StatefulWidget {
  static String searchedPatientResult = "";

  @override
  State<StatefulWidget> createState() => ScanSearchedPatientHolderState();
}

class ScanSearchedPatientHolderState extends State<StatefulWidget> {
  Future<dynamic> fetchClinic(String barcodeResult) async {
    final String url =
        words.Word.ip + "/clinic/thongtinkhambenh/" + barcodeResult;
    final response = await http.get(url);
    //Neu thong tin tra ve la dung
    if (response.statusCode == 200) {
      http.post(words.Word.ip +
          '/history?idBn=' +
          Login.result +
          "&idBnSearch=" +
          barcodeResult);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SearchedPatient(barcodeResult)));
    } else
      throw Exception('Fail');
  }

  ///Scan barcode
  Future _scanBarcode() async {
    try {
      String barcodeResult = await BarcodeScanner.scan();
      //setState(() {
      ScanSearchedPatientHolder.searchedPatientResult = barcodeResult;
      //});

      fetchClinic(ScanSearchedPatientHolder.searchedPatientResult);
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          ScanSearchedPatientHolder.searchedPatientResult =
              words.Word.Login_Camera_Denied;
        });
      } else {
        ScanSearchedPatientHolder.searchedPatientResult =
            words.Word.Login_Unknow_Error + " $ex";
      }
    } on FormatException {
      setState(() {
        ScanSearchedPatientHolder.searchedPatientResult =
            words.Word.Login_Press_Back_Button;
      });
    } catch (ex) {
      setState(() {
        ScanSearchedPatientHolder.searchedPatientResult =
            words.Word.Login_Unknow_Error + " $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text("Tìm kiếm"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blueAccent,
          ),
          preferredSize: Size.fromHeight(30.0)),
      body: Center(
        child: FlatButton(
            onPressed: _onPressed, child: Text("Bấm vào đây để Scan")),
      ),
    );
  }

  void _onPressed() {
    _scanBarcode();
  }
}
