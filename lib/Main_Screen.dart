import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _homeView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Timer(new Duration(seconds: 3), () {
      if (prefs.getString('user_type') == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcomescreen', (Route<dynamic> route) => false);
      } else if (prefs.getString('user_type') == 'farmer') {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/farmerdashboardscreen', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/customerdashboardscreen', (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this._homeView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:Container(
      height: MediaQuery.of(context).copyWith().size.height,
      width: MediaQuery.of(context).copyWith().size.width,
     decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                      Color(0xff14CB3F),
                      Color(0xff14CB3F),
                      Color(0xff4AC483),
                    ])),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitFoldingCube(color: Colors.white),
          SizedBox(height: 30.0),
          Text('Loading ...',
              style: TextStyle(fontFamily: 'Product Sans', fontSize: 12.0,color:Colors.white))
        ],
      )),
    ));
  }
}
