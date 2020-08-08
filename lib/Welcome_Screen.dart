import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  Animation animation;
  AnimationController animationController;

  @override
  void initState(){
    super.initState();
    animationController = AnimationController(duration:Duration(seconds: 2),vsync:this);
    animation = Tween(begin:1.0,end:0.0).animate(CurvedAnimation(
      parent: animationController, curve:Curves.fastOutSlowIn
    ));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () => _showExitAlert(),
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Color(0xff14CB3F),
                  Color(0xff14CB3F),
                  Color(0xff4AC483),
                ])),
            child: AnimatedBuilder(
              animation: animationController, 
              builder: (BuildContext context,Widget child){
                  return Transform(
                    transform: Matrix4.translationValues(0.0,animation.value*height, 0.0),
                    child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    height:
                        MediaQuery.of(context).copyWith().size.height * 0.45,
                   color: Colors.transparent,
                    child: Material(
                        color: Colors.white,
                        elevation: 100.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50.0),
                                topRight: Radius.circular(50.0))),
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Choose',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height *
                                              0.05,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'Product Sans'),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Who you are ?',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height *
                                              0.015,
                                          color: Colors.black,
                                          fontFamily: 'Product Sans'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/farmerwelcomescreen'),
                                          child: Card(
                                              elevation: 10.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0)),
                                              color: Colors.white,
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
                                                    0.2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Image.asset(
                                                        'assets/images/farm.jpg',
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.14,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .width *
                                                            0.35),
                                                    Text('Farmer',
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          fontFamily:
                                                              'Product Sans',
                                                          color: Colors.black,
                                                        )),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/customerloginscreen'),
                                          child: Card(
                                              elevation: 10.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0)),
                                              color: Colors.white,
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Image.asset(
                                                        'assets/images/customer.jpg',
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.14,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .width *
                                                            0.35),
                                                    Text('Customer',
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .copyWith()
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                            fontWeight:
                                                                FontWeight.w100,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Product Sans')),
                                                  ],
                                                ),
                                              )),
                                        )
                                      ],
                                    ))
                              ]),
                        ))),
              ],
            ))
                  );
              }
              )
            ));
  }

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
}
