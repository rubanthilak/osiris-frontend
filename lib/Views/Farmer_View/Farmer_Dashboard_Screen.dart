import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Add_Product..dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_List_Product.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Order_Screen.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Profile_Screen.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Stock_View.dart';



class FarmerDashboardScreen extends StatefulWidget {
  @override
  _FarmerDashboardScreenState createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  List<Map<String, dynamic>> data = new List<Map<String, dynamic>>();

  void _showLogoutFailed() {
    AlertDialog failedDialog = AlertDialog(
      shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Failed ❗')),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text('Check Internet.')]),
    );
    showDialog(context: context, builder: (_) => failedDialog);
  }


  //To delete the local Token and send request to delete server token
  _deleteToken() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
       
    try {
      Response _response = await Dio()
          .post(globals.headurl + '/hubs/rest-auth/logout/',
              options: Options(headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json"
              }));
      if (_response.statusCode == 200) {
        prefs.remove("token");
        prefs.remove("url");
        prefs.remove("user_type");
        Navigator.of(context).pushNamedAndRemoveUntil(
              '/welcomescreen', (Route<dynamic> route) => false);
      }
    } catch (e) {
      this.setState(() {
         Navigator.pop(context);
        _showLogoutFailed();
      });
    }
  }

  _generateListMap() {
    List imgLocation = [
      'assets/images/farm.jpg',
      'assets/images/delivery.jpg',
      'assets/images/subscription.jpg',
      'assets/images/customer.jpg',
    ];

    List imgName = ['Products', 'Delivery','Orders','Profile'];

    List widgets = [FarmerListProduct(), FarmerStockView(), FarmerOrderScreen(),FarmerProfileScreen()];

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
    this._generateListMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _showExitAlert(),
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => FarmerAddProduct())),
              backgroundColor: Colors.greenAccent[700],
              child: Icon(Icons.add, color: Colors.white),
            ),
            body: Builder(builder: (BuildContext context) {

              return Column(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.15,
                  width: MediaQuery.of(context).copyWith().size.width,
                  color: Colors.greenAccent[700],
                  child: Material(
                      color: Colors.transparent,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height *
                                  0.05,
                              left:
                                  MediaQuery.of(context).copyWith().size.width *
                                      0.05,
                              right:
                                  MediaQuery.of(context).copyWith().size.width *
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
                                      'Made With Love',
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
                Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.85,
                    color: Colors.greenAccent[700],
                    child: Material(
                         color: Colors.grey[100],
                         elevation: 0.5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0))),
                        child: Padding(
                        padding: EdgeInsets.only(top:5.0),
                        child:GridView.count(
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
                                            builder: (context) =>
                                                value['widget']));
                                  },
                                  child: Card(
                                      elevation: 0.1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
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
                                                fontFamily: 'Product Sans',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0),
                                            textAlign: TextAlign.left,
                                          )
                                        ],
                                      )));
                            }).toList()))))
              ]);
            })));
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
}
