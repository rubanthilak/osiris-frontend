import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerOrderDispatchedScreen extends StatefulWidget {
  CustomerOrderDispatchedScreen({Key key}) : super(key: key);

  @override
  _CustomerOrderDispatchedScreenState createState() => _CustomerOrderDispatchedScreenState();
}

class _CustomerOrderDispatchedScreenState extends State<CustomerOrderDispatchedScreen> {

   List data;
   bool _isLoading = false , _timeout = false;
   List<Map<String,dynamic>> orderList = new List<Map<String,dynamic>>();

   _getOrderList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState((){
      _isLoading = true;
    });
    try {
      http.Response result = await http.get(globals.headurl + '/cust/order-detail/',
             headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json",
              });
      if(result.statusCode == 200)
      {
      data = json.decode(result.body);
      for (var item in data) {
          http.Response _result = await http.get(item['item'].toString());
          if (_result.statusCode == 200 && item['processed'] == true) {
            Map<String, dynamic> temp = json.decode(_result.body);
            temp['quantity'] = item['quantity'];
            temp['detail_url'] = item['url'];
            temp['processed'] = item['processed'];
            this.setState(() {
              orderList.add(temp);
            });
          }
        }
      this.setState((){
      _isLoading = false;
      });
      }
    } 
    catch (e) {
      this.setState((){
          _isLoading = false;
          _timeout = true;
        });
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
        body: Material(
          shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)
                    )),
          child:Builder(builder: (BuildContext context) {

          if (_isLoading) {
                return Center(
                    child:  SpinKitFoldingCube(color: Colors.greenAccent[700]));
              }

          if (_timeout) {
            return Center(
                child: Text(
              'Check Network Connection ❗',
              style: TextStyle(fontSize: 18.0),
            ));
          }

          return ListView.separated(
         separatorBuilder: (BuildContext context, int index) => Divider(height: 0.0, color: Colors.transparent),
        itemCount: orderList == null ? 0 : orderList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    child: GestureDetector(
                      child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15.0)),
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
                                              orderList[index]['processed'] == true 
                                              ? Text(
                                               'Dispatched',
                                                style: TextStyle(
                                                            color:Colors.greenAccent[700],
                                                            fontFamily:'Product Sans',
                                                            fontWeight:FontWeight.w500,
                                                            fontSize:14.0)
                                              )
                                              : Text(
                                                'Processing',
                                                style: TextStyle(
                                                            color:Colors.red,
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
                                          Text('Price',
                                              style: TextStyle(
                                                  fontFamily:'Product Sans',
                                                  color: Colors.grey)),
                                          Text('₹' + _getPrice(orderList[index]['rate'],orderList[index]['quantity'])
                                                      .substring(0,_getPrice(orderList[index]['rate'], orderList[index]['quantity']).indexOf('.') +2),
                                              style: TextStyle(
                                                  fontFamily:'Product Sans',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0)
                                                )
                                        ],
                                      )
                                    ],
                                  )
                          ))
                    )
          );
        }
        );
  })));
  }
  String _getPrice(String rate, String quantity) {
    var price;
    price = num.parse(rate) * num.parse(quantity);
    return price.toString();
  }

}

