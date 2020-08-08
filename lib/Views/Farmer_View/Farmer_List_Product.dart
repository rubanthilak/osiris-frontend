import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uzhavar_mart/globals.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Update_Product_Details.dart';

class FarmerListProduct extends StatefulWidget {
  FarmerListProduct({Key key}) : super(key: key);

  @override
  _FarmerListProductState createState() => _FarmerListProductState();
}

class _FarmerListProductState extends State<FarmerListProduct> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  bool _isLoading = false;
  bool _timeout = false;
  http.Response result;
  List data;

  _getData() async {
    this.setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("url"));
    try {
      result = await http.get(
          Uri.encodeFull(globals.headurl +
              prefs.getString("url") +
              'products/'),
          headers: {
            "Accept": "application/json"
          });
      if (result.statusCode == 200) {
        this.setState(() {
          data = json.decode(result.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      this.setState(() {
        _timeout = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    this._getData();
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
    return Scaffold(
        backgroundColor: Colors.greenAccent[700],
        appBar: AppBar(
          leading: new IconButton(
                padding: EdgeInsets.all(0.0),
                icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop()),
          title: Text('Products'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          ),
        body: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return Transform(
                  transform: Matrix4.translationValues(
                      0.0, animation.value * height, 0.0),
                  child: Material(
          color: Colors.grey[100],
                         elevation: 0.5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0))),
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

          return GridView.count(
              padding: EdgeInsets.all(10.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: data.map((value) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  FarmerUpdateProduct(value['url'])));
                    },
                    child: Card(
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                child: Center(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(360.0),
                                        child: Image.network(
                                          value["image"],
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          height: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .width *
                                              0.3,
                                          width: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .width *
                                              0.3,
                                        )))),
                            Text(value["name"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .width *
                                        0.04,
                                    fontWeight: FontWeight.w500)),
                            Text(value["family"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .width *
                                        0.03,
                                    fontWeight: FontWeight.w300)),
                          ],
                        )));
              }).toList());
        })));
        }));
  }
}
