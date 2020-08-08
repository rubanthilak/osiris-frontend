import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Cart_Screen.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_List_Hubs.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:uzhavar_mart/Views/Customer_View/Customer_Order_Screen.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Profile_Screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  CustomerDashboardScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  bool _isLoading = false;
  bool _timeout = false;
  List<Map<String, dynamic>> data = new List<Map<String, dynamic>>();

  void generateListMap() {
    List imgLocation = [
      'assets/images/hubs.jpg',
      'assets/images/farm.jpg',
      'assets/images/delivery.jpg',
      'assets/images/subscription.jpg'
    ];

    List imgName = ['Market', 'Cart', 'Orders', 'Profile'];

    List widgets = [
      CustomerListHub(),
      CustomerCartScreen(),
      CustomerOrderScreen(),
      CustomerProfileScreen()
    ];
    for (int i = 0; i < imgLocation.length; i++) {
      Map<String, dynamic> temp = new Map<String, dynamic>();
      temp['img'] = imgLocation[i];
      temp['name'] = imgName[i];
      temp['widget'] = widgets[i];
      data.add(temp);
    }
  }

  @override
  void initState() {
    this.generateListMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _showExitAlert(),
        child: Scaffold(
          backgroundColor:Colors.greenAccent[700],
            body: Column(children: <Widget>[
          Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.15,
            width: MediaQuery.of(context).copyWith().size.width,
            color: Colors.greenAccent[700],
            child: Material(
                color: Colors.transparent,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).copyWith().size.height *
                            0.05,
                        left:
                            MediaQuery.of(context).copyWith().size.width * 0.05,
                        right: MediaQuery.of(context).copyWith().size.width *
                            0.05),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .height *
                                      0.04,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Fresh From Farm',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .height *
                                      0.02,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                         RaisedButton(
                                    elevation: 5.0,
                                    onPressed: () {
                                      _showLogOut();
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    color: Colors.white,
                                    child: Text('Log Out'))
                        ]))),
          ),
          SizedBox(
              height: MediaQuery.of(context).copyWith().size.height * 0.01),
          Expanded(
              child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)
                    )
                  ),
                  color: Colors.grey[100],
                  child: GridView.count(
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      padding: EdgeInsets.all(10.0),
                      crossAxisCount: 2,
                      children: data.map((value) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => value['widget']));
                            },
                            child: Card(
                                elevation: 0.1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image.asset(value["img"],
                                        width: MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .height *
                                            0.2),
                                    Text(
                                      value['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                )));
                      }).toList())))
        ])));
  }

  //Alert Box
  _showExitAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Center(child: Text('Are You Sure ?')),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.white,
                    onPressed: () {
                      exit(0);
                    },
                    child: Text('Close', style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(width: 20.0),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ));
        });
  }

  _showLogOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Center(child: Text('Log out ?')),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.red,
                    onPressed: () {
                      _deleteToken();
                    },
                    child: Text('Yes', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20.0),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ));
        });
  }

  //To delete the local Token and send request to delete server token
  _deleteToken() async {
    this.setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Response _response = await Dio()
          .post(globals.headurl + '/hubs/rest-auth/logout/',
              options: Options(headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json"
              }))
          ;
      if (_response.statusCode == 200) {
        prefs.remove("token");
        prefs.remove("url");
        prefs.remove("user_type");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcomescreen', (Route<dynamic> route) => false);
        this.setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      this.setState(() {
        _timeout = true;
        Navigator.pop(context);
        _isLoading = false;
      });
    }
  }
}
