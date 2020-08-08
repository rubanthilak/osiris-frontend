import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FarmerStockView extends StatefulWidget {
  FarmerStockView({Key key}) : super(key: key);

  @override
  _FarmerStockViewState createState() => _FarmerStockViewState();
}

class _FarmerStockViewState extends State<FarmerStockView> with SingleTickerProviderStateMixin {
    
    bool _isLoading = false;
    bool _success = false;
    AnimationController animationController;
    Animation animation;
    List data;
    List<Map<String,dynamic>> orderList = new List<Map<String,dynamic>>();
    List<Map<String,dynamic>> temp = new List<Map<String,dynamic>>();
    bool flag = false;

   _getOrderList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState((){
     _isLoading = true;
     });
    try {
      http.Response result = await http.get(globals.headurl + '/hubs/order/list/',
             headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json"
              });
      if(result.statusCode == 200)
      {
      data = json.decode(result.body);
      for(var i in data)
      {
        flag = false;
        for(var j in temp)
        {
          if(i['item'] == j['item'])
          {
            flag=true;
            j['quantity'] = (num.parse(j['quantity'])+num.parse(i['quantity'])).toString();
            break;
          }
        }
        if(flag == false)
        {
          temp.add(i);
        }
      }
      for (var item in temp) {
          http.Response _result = await http.get(item['item'].toString());
          if (_result.statusCode == 200) {
            Map<String, dynamic> map = json.decode(_result.body);
            map['quantity'] = item['quantity'];
            map['processed'] = item['processed'];
            this.setState(() {
              orderList.add(map);
            });
          }
        }
      } 
      this.setState((){
     _isLoading = false;
      });      
    } 
    catch (e) {
      print(e);
    }
  }

  @override
  void initState(){
    this._getOrderList();
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
              icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          title: Text('Delivery'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Material(
        elevation: 0.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0))),
        child:Builder(builder: (BuildContext context) {

          if (_isLoading) {
              return Center(child: SpinKitFoldingCube(color: Colors.greenAccent[700]));
            }

          if (_success) {
            return Center(
              child:Text(
              'Dispatched ✔',
              style: TextStyle(fontFamily: 'Product Sans',fontSize: 24.0,color:Colors.black),
            ));
          }

          if (orderList.length == 0) {
            return Center(
              child:Text(
              'No Orders',
              style: TextStyle(fontFamily: 'Product Sans',fontSize: 24.0,color:Colors.black),
            ));
          }

          return Column(
          children: <Widget>[
            Expanded(
              child:ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0, color: Colors.transparent),
                itemCount: orderList == null ? 0 : orderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: GestureDetector(
                              child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:BorderRadius.circular(15.0)),
                                          color: Colors.white,
                                          child: Padding(
                                              padding: EdgeInsets.only(top:10.0,left:10.0,right:20.0,bottom:10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        child:Center(
                                                          child:ClipRRect(
                                                                  borderRadius:BorderRadius.circular(360.0),
                                                                  child: Image.network(
                                                                    orderList[index]['image'],
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment.topCenter,
                                                                    height: 75.0,
                                                                    width: 75.0,
                                                                  )
                                                                )
                                                              )
                                                            ),
                                                    SizedBox(width:10.0),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          orderList[index]['name'],
                                                          style: TextStyle(
                                                                      fontFamily:'Product Sans',
                                                                      fontWeight:FontWeight.bold,
                                                                      fontSize:18.0)
                                                        ),
                                                        Text(
                                                        orderList[index]['family'],
                                                        style: TextStyle(
                                                                    color:Colors.grey,
                                                                    fontFamily:'Product Sans',
                                                                    fontWeight:FontWeight.w500,
                                                                    fontSize:14.0)
                                                      ),
                                                      ],
                                                    ),
                                                ],
                                              ),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('Quantity',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Product Sans',
                                                            color: Colors
                                                                .grey)),
                                                Text(orderList[index]['quantity'].substring(0,orderList[index]['quantity'].indexOf('.') + 2) + ' Kg',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Product Sans',
                                                        fontWeight:
                                                            FontWeight
                                                                .bold,
                                                        fontSize: 18.0))
                                                ],
                                              )

                                            ],
                                          )
                                  ))
                            )
                  );
                }
              )
          ),
            AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return Transform(
                  transform: Matrix4.translationValues(0.0, animation.value * MediaQuery.of(context).size.height, 0.0),
                  child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0)),
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
                                      padding: EdgeInsets.symmetric(horizontal:80.0,vertical:10.0),
                                      shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0)),
                                  color: Colors.white,
                                  onPressed: () {
                                    _processedButton();
                                  },
                                  child: Text('Ready  for  Delivery',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Product Sans')),
                                )),
                              ))
                        ));
                     }
                    )
         ]);
       }
      )
    ));
  }
  _processedButton() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
   this.setState((){
     _isLoading = true;
   });
   for (var item in data) {
       await Dio().put(item['url'].toString(),
          data:{
            'item':item['item'],
            'url':item['url'],
            'quantity':item['quantity'],
            'ordered':item['ordered'],
            'processed' : 'true'
          },
          options:Options(headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
              }));
    }
   for(var item in orderList)
   {
     await Dio().put(item['url'].toString(),
          data:{
            "name":item['name'],
            "family": item['family'],
            "avail_quantity": (num.parse(item['avail_quantity'])-num.parse(item['quantity'])).toString(),
            "rate": item['rate']
          },
          options:Options(headers: {
              'Authorization': 'Token ' + prefs.getString('token'),
              "Content-Type": "application/json"
            })
     );
   }
   this.setState((){
     _success = true;
     _isLoading = false;
   });
  }
}

