import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class FarmerOrderScreen extends StatefulWidget {
  FarmerOrderScreen({Key key}) : super(key: key);

  @override
  _FarmerOrderScreenState createState() => _FarmerOrderScreenState();
}

class _FarmerOrderScreenState extends State<FarmerOrderScreen> {

    List data;
    List<Map<String,dynamic>> orderList = new List<Map<String,dynamic>>();

   _getOrderList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      http.Response result = await http.get(globals.headurl + '/hubs/order/list/',
             headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json"
              });
      if(result.statusCode == 200)
      {
      data = json.decode(result.body);
      for (var item in data) {
          http.Response _result = await http.get(item['item'].toString());
          if (_result.statusCode == 200) {
            Map<String, dynamic> temp = json.decode(_result.body);
            temp['quantity'] = item['quantity'];
            temp['detail_url'] = item['url'];
            temp['ordered'] = item['ordered'];
            temp['processed'] = item['processed'];
            this.setState(() {
              orderList.add(temp);
            });
          }
        }
      }       
    } 
    catch (e) {
      print(e);
    }
  }

  @override
  void initState(){
    this._getOrderList();
    super.initState();
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
          title: Text('Orders'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(height: 0.0, color: Colors.transparent),
        itemCount: orderList == null ? 0 : orderList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
                    padding: EdgeInsets.only(
                        top: 1.0, left: 10.0, right: 10.0),
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
                                        Text(orderList[index]['quantity'].substring(0,orderList[index]['quantity'].indexOf('.') + 3) + ' Kg',
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
      ),
    );
  }
}

