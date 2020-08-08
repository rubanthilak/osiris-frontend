import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Login_Screen.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Register_Screen.dart';

class FarmerWelcomeScreen extends StatefulWidget {
  FarmerWelcomeScreen({Key key}) : super(key: key);

  @override
  _FarmerWelcomeScreenState createState() => _FarmerWelcomeScreenState();
}

class _FarmerWelcomeScreenState extends State<FarmerWelcomeScreen> with SingleTickerProviderStateMixin {
  
  Animation animation;
  AnimationController animationController;

  @override
  void initState(){
    super.initState();
    animationController = AnimationController(duration:Duration(seconds: 1),vsync:this);
    animation = Tween(begin:1.0,end:0.0).animate(CurvedAnimation(
      parent: animationController, curve:Curves.fastOutSlowIn
    ));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
  final double height = MediaQuery.of(context).size.height;
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Colors.greenAccent[700],
              Color(0xff14CB3F),
              Color(0xff4AC483),
            ])),
        child: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return Transform(
                  transform: Matrix4.translationValues(
                      0.0, animation.value * height, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          height:
                              MediaQuery.of(context).copyWith().size.height *
                                  0.9,
                          color: Colors.transparent,
                          child: Material(
                              color: Colors.white,
                              elevation: 100.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50.0),
                                      topRight: Radius.circular(50.0))),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                      height: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height *
                                          0.05),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'Uzhavar Mart',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height *
                                                0.05,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent[700],
                                            fontFamily: 'Product Sans'),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'Fresh From Farm',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height *
                                                0.03,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height *
                                        0.1,
                                  ),
                                  Image.asset('assets/images/hubs.jpg',
                                      height: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height *
                                          0.35),
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height *
                                        0.1,
                                  ),
                                  RaisedButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FarmerLoginScreen())),
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
                                  RaisedButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FarmerRegisterScreen())),
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
                                            'Register',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height *
                                                    0.025,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ))))
                                ],
                              ))),
                    ],
                  ));
            }));
  }
}
