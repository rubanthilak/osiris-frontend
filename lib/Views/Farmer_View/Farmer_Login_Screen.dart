import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerLoginScreen extends StatefulWidget {
  FarmerLoginScreen({Key key}) : super(key: key);

  @override
  _FarmerLoginScreenState createState() => _FarmerLoginScreenState();
}

class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
  bool _isHidden = true;
  bool _isLoading = false;
  bool _timeout = false;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  //To store the token in share preference or local disk
  Future<void> _storeToken(String token, String url, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('url', url);
    prefs.setString('user_type', userType);
  }

  _loginButton() async {
    this.setState(() {
      _isLoading = true;
    });
    try {
      Response response = await Dio()
          .post(globals.headurl + '/hubs/merch/login/', data: {
        'username': phoneNumberController.text
      });
      if (response.statusCode == 200) {
        this.setState(() {
          var temp = json.decode(response.toString());
          _storeToken(temp['token'], temp['url'], 'farmer');
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/farmerdashboardscreen', (Route<dynamic> route) => false);
          phoneNumberController.text = '';
          passwordController.text = '';
          _isLoading = false;
        });
      }
    } catch (e) {
      this.setState(() {
        print(e);
        _timeout = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              // Color(0xff14CB3F),
              Colors.greenAccent[700],
              Color(0xff4AC483),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          Container(
              color: Colors.transparent,
              child: Material(
              color: Colors.transparent,
              child:Row(
                children: <Widget>[
                  SizedBox(width:20.0),
                  IconButton(icon: Icon(Icons.close,color: Colors.white), onPressed: () => Navigator.pop(context))
                ],
              )),
          ),
          Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.9,
              color: Colors.transparent,
              child: Material(
                  color: Colors.white,
                  elevation: 100.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)
                  )),
                  child: Builder(builder: (BuildContext context) {
                    
                    if (_isLoading) {
                      return Center(child: SpinKitFoldingCube(color: Colors.greenAccent[700]),);
                    }

                    if (_timeout) {
                      return Center(
                          child: Text(
                        'Check Network Connection ❗',
                        style: TextStyle(fontSize: 18.0),
                      ));
                    }

                    return ListView(
                      children: <Widget>[
                        Center(
                          child: Padding(
                              padding: EdgeInsets.only(left:20.0,right:20.0),
                              child: Material(
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                       Text('Login',
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize:
                                                MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height *
                                                    0.05,
                                            fontFamily:
                                                'Product Sans')),
                                      SizedBox(height:10.0),
                                      Image.asset(
                                        'assets/images/hubs.jpg',
                                        width: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .width,
                                        height: MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .height *
                                            0.3,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 25.0),
                                          child: Column(
                                            children: <Widget>[
                                             
                                              TextField(
                                                controller:
                                                    phoneNumberController,
                                                keyboardType:
                                                    TextInputType.number,
                                                obscureText: false,
                                                cursorColor: Colors.greenAccent[700],
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: MediaQuery.of(
                                                                        context)
                                                                    .copyWith()
                                                                    .size
                                                                    .height *
                                                                0.02),
                                                    hintText: "Phone Number",
                                                    prefixIcon: Icon(
                                                        Icons.person,
                                                        color: Colors.greenAccent[700]),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color:
                                                                  Colors.greenAccent[700]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color:
                                                                  Colors.greenAccent[700]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .greenAccent[700],
                                                                    width: 3.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80.0))),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height *
                                                    0.03,
                                              ),
                                              TextField(
                                                controller: passwordController,
                                                obscureText: _isHidden,
                                                cursorColor: Colors.greenAccent[700],
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.02),
                                                    hintText: "Password",
                                                    prefixIcon: Icon(Icons.lock,
                                                        color: Colors.greenAccent[700]),
                                                    suffixIcon: IconButton(
                                                        onPressed:
                                                            _toggleVisibility,
                                                        icon: _isHidden
                                                            ? Icon(Icons.visibility_off,
                                                                color:
                                                                    Colors.grey)
                                                            : Icon(Icons.visibility,
                                                                color: Colors
                                                                    .red[300])),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color:
                                                                  Colors.greenAccent[700]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color:
                                                                  Colors.greenAccent[700]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80.0),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide(color: Colors.greenAccent[700], width: 3.0),
                                                        borderRadius: BorderRadius.circular(80.0))),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height *
                                                    0.025,
                                              ),
                                              FlatButton(
                                                  onPressed: () {},
                                                  padding: EdgeInsets.all(0),
                                                  child: Text(
                                                      'Forgot Password ?',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.02))),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              RaisedButton(
                                                  onPressed: () =>
                                                      _loginButton(),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0)),
                                                  color: Colors.greenAccent[700],
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .copyWith()
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                      child: Center(
                                                          child: Text(
                                                        'Login',
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .copyWith()
                                                                    .size
                                                                    .height *
                                                                0.025,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )))),
                                            ],
                                          ))
                                    ],
                                  ))),
                        )
                      ],
                    );
                  })))
        ]));
  }
}
