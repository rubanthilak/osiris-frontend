import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Register_Screen.dart';

class CustomerLoginScreen extends StatefulWidget {
  CustomerLoginScreen({Key key}) : super(key: key);

  @override
  _CustomerLoginScreenState createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {

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
          .post(globals.headurl + '/cust/login/',
          data: {
            'username' : phoneNumberController.text
            }
        );
      if (response.statusCode == 200) {
        this.setState(() {
          var temp = json.decode(response.toString());
          _storeToken(temp['token'], temp['url'], 'customer');
          Navigator.of(context).pushNamedAndRemoveUntil(
                    '/customerdashboardscreen', (Route<dynamic> route) => false);
          phoneNumberController.text = '';
          passwordController.text = '';
          _isLoading = false;
        });
      }
    } 
    catch (e) {
      this.setState(() {
        _timeout = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.greenAccent[700],
        appBar: AppBar(
          leading: new IconButton(
              padding: EdgeInsets.all(0.0),
              icon: new Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body:  Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)
                  )
                ),
        child:Builder(builder: (BuildContext context) {
          
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
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
                  padding: EdgeInsets.all(20.0),
                  child: Material(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                         
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
                           Image.asset(
                            'assets/images/customer.jpg',
                            width: MediaQuery.of(context).copyWith().size.width,
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.3,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 20.0),
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: phoneNumberController,
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
                                    cursorColor: Colors.greenAccent[700],
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height *
                                                0.02),
                                        hintText: "Phone Number",
                                        prefixIcon: Icon(Icons.person,
                                            color: Colors.greenAccent[700]),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.greenAccent[700]),
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.greenAccent[700]),
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.greenAccent[700],
                                                width: 3.0),
                                            borderRadius:
                                                BorderRadius.circular(80.0))),
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
                                            onPressed: _toggleVisibility,
                                            icon: _isHidden
                                                ? Icon(Icons.visibility_off,
                                                    color: Colors.grey)
                                                : Icon(Icons.visibility,
                                                    color: Colors.red[300])),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.greenAccent[700]),
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.greenAccent[700]),
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.greenAccent[700],
                                                width: 3.0),
                                            borderRadius:
                                                BorderRadius.circular(80.0))),
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
                                      child: Text('Forgot Password ?',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
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
                                      onPressed: () => _loginButton(),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      color: Colors.greenAccent[700],
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .width *
                                              0.8,
                                          height: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height *
                                              0.06,
                                          child: Center(
                                              child: Text(
                                            'Login',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height *
                                                    0.025,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          )))),
                                          SizedBox(
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height *
                                        0.025,
                                  ),
                                  FlatButton(
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerRegisterScreen())),
                                      padding: EdgeInsets.all(0),
                                      child: Text('New User ? Register',
                                          style: TextStyle(
                                            color: Colors.greenAccent[700],
                                              fontSize: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height *
                                                  0.02))),
                                ],
                              ))
                        ],
                      ))),
            )
          ],
        );
        })
        ));
        
    }
}
