import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:uzhavar_mart/globals.dart' as globals;

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Cart_Screen.dart';

class CustomerProductDetails extends StatefulWidget {
  final String url;
  CustomerProductDetails(this.url);

  @override
  _CustomerProductDetailsState createState() => _CustomerProductDetailsState();
}

class _CustomerProductDetailsState extends State<CustomerProductDetails> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  bool _isLoading = false;
  bool _timeout = false;
  http.Response result;
  Map<String, dynamic> data;
  TextEditingController quantityController = new TextEditingController();

  Future<void> getData() async {
    this.setState(() {
      _isLoading = true;
    });

    try {
      result = await http.get(Uri.encodeFull(widget.url), headers: {
        "Accept": "application/json"
      });

      if (result.statusCode == 200) {
        this.setState(() {
          data = json.decode(result.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      _isLoading = false;
      _timeout = true;
    }
  }

  @override
  void initState() {
    this.getData();
    super.initState();
    animationController = AnimationController(duration:Duration(seconds: 1),vsync:this);
    animation = Tween(begin:1.0,end:0.0).animate(CurvedAnimation(
    parent: animationController, curve:Curves.fastOutSlowIn
    ));
    animationController.forward();
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
          actions: <Widget>[
            GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerCartScreen() )),
                child: Icon(Icons.shopping_cart, color: Colors.white)),
            SizedBox(width: 20.0)
          ],
        ),
        body: Material(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0))),
            color: Colors.white,
            child: Builder(builder: (BuildContext context) {
              
             if (_isLoading) {
                return Container(
                height: MediaQuery.of(context).copyWith().size.height*0.9,
                child:Center(
                    child:  SpinKitFoldingCube(color: Colors.greenAccent[700])));
              }

              if (_timeout) {
                return Container(
                height: MediaQuery.of(context).copyWith().size.height*0.9,
                child:Center(
                    child: Text(
                  'Check Network Connection ❗',
                  style: TextStyle(fontSize: 18.0),
                )));
              }

              return Column(
                children: <Widget>[
                  Expanded(
                    child:Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height:
                                MediaQuery.of(context).copyWith().size.height * 0.025,
                          ),
                          //Product Image
                          Container(
                              child: Center(
                                  child: ClipRRect(
                                      borderRadius:BorderRadius.circular(360.0),
                                      child: Image.network(data['image'],
                                          height: 250.0,
                                          alignment: Alignment.topCenter,
                                          fit: BoxFit.cover,
                                          width: 250.0)))),
                          SizedBox(
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.025,
                          ),
                          //Product & Family Name
                          Column(
                            children: <Widget>[
                              Text(data['name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 42.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Product Sans'),
                                      textAlign: TextAlign.center,),
                              Text(data['family'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18.0)),
                            ],
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.025,
                          ),
                          //Price & Quantity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Container(
                                      width: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .width *
                                          0.4,
                                      height: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height *
                                          0.12,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Price',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0)),
                                          Text(
                                              '₹' +
                                                  data['rate'].substring(
                                                      0,
                                                      data['rate']
                                                          .indexOf('.')),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Product Sans'))
                                        ],
                                      ))),
                              Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Container(
                                      height: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height *
                                          0.12,
                                      width: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .width *
                                          0.4,
                                      child: data['avail_quantity']
                                                  .substring(0, 3) ==
                                              '0.0'
                                          ? Center(
                                              child: Text('OUT OF STOCK',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'Product Sans')))
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Available',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 12.0)),
                                                Text(
                                                    data['avail_quantity'].substring(
                                                            0,
                                                            data['avail_quantity']
                                                                    .indexOf(
                                                                        '.') +
                                                                2) +
                                                        ' Kg',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 24.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'Product Sans'))
                                              ],
                                            )))
                            ],
                          ),
                        ],
                      ))),
                 
            AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return Transform(
                  transform: Matrix4.translationValues(0.0, animation.value * MediaQuery.of(context).size.height, 0.0),
                  child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                          child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                    Colors.greenAccent[700],
                                    Color(0xff14CB3F),
                                    Color(0xff4AC483),
                                  ])),
                              width:MediaQuery.of(context).copyWith().size.width,
                              height:MediaQuery.of(context).copyWith().size.height*0.18,
                              child: Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50.0),
                                        topRight: Radius.circular(50.0))),
                                color: Colors.transparent,
                                child: Center(
                                    child: RaisedButton(
                                      padding: EdgeInsets.symmetric(horizontal:100.0,vertical:10.0),
                                      shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0)),
                                  color: Colors.white,
                                  onPressed: () {
                                    _addCartAlert(context,onLoginPressed: () {
                                       Navigator.pop(context);
                                      _showWaitDialog();
                                      _addCartFn();
                                    });
                                  },
                                  child: Text('Add  to  Cart',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Product Sans')),
                                )),
                              ))
                        ));
                    }
                    )
                ],
              );
            }))
            
            );
  }
  
  _addCartAlert(BuildContext context, {Function onLoginPressed})
  {
    Alert(
      context: context,
      style: AlertStyle(
         isCloseButton: false,
        animationDuration: Duration(milliseconds: 300),
        alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
              color: Colors.grey,
            ),
          ),
        animationType: AnimationType.grow
      ),
      title: "Quantity",
      content: Column(
        children: <Widget>[
          SizedBox(
            height:10.0
          ),
          TextFormField(
            keyboardType:TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return '*Required Field';
              }
              return null;
            },
            controller: quantityController,
            obscureText: false,
            cursorColor:
                Colors.greenAccent[700],
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical:0.0),
                hintText: "  Enter in Kilogram",
                prefixIcon: Icon(Icons.store_mall_directory,color:Colors.greenAccent[700]),
                enabledBorder:OutlineInputBorder(
                  borderSide: new BorderSide(
                      color: Colors.greenAccent[700]),
                  borderRadius:BorderRadius.circular(100.0),
                ),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(
                      color: Colors.greenAccent[700]),
                  borderRadius:BorderRadius.circular(100.0),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.greenAccent[700],
                        width: 3.0
                        ),
                    borderRadius:BorderRadius.circular(100.0))),
              ),
        ],
      ),
      buttons: [
        DialogButton(
          color: Colors.greenAccent[700],
          radius: BorderRadius.circular(100.0),
          onPressed: onLoginPressed,
          child: Text(
            'Add to Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Product Sans')
            )
          )
      ]
    ).show(); 
  }

  _addCartFn() async
  {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
       
    try {
      Response _response = await Dio()
          .post(globals.headurl + '/cust/cart-post/',
              data: {
                'item': data['url'],
                'quantity' : quantityController.text
              },
              options: Options(headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json"
              }))
          ;
      if (_response.statusCode == 201) {
        quantityController.text = '';
         Navigator.pop(context);
         _showSuccessDialog();
      }
    } catch (e) {
      this.setState(() {
         Navigator.pop(context);
         _showFailedDialog();
      });
    }
  }

  _showFailedDialog() {
    AlertDialog failedDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Failed ❗')),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text('Check Network Connection')]),
    );
    showDialog(context: context, builder: (_) => failedDialog);

  }

  _showSuccessDialog() {
    AlertDialog successDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Success ✔')),
    );
    showDialog(context: context, builder: (_) => successDialog);
  }

   _showWaitDialog() {
    AlertDialog successDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Please Wait ...')),
    );
    showDialog(context: context, builder: (_) => successDialog);
  }

}
