import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:uzhavar_mart/Views/Customer_View/Customer_Update_Cart.dart';

class CustomerCartScreen extends StatefulWidget {
  CustomerCartScreen({Key key}) : super(key: key);

  @override
  _CustomerCartScreenState createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  List data;
  List<Map<String, dynamic>> cartList = new List<Map<String, dynamic>>();
  bool _isLoading = false;
  bool _timeout = false;

  _getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      this.setState(() {
        _isLoading = true;
      });
      http.Response _response =
          await http.get(globals.headurl + '/cust/cart-list/', headers: {
        'Authorization': 'Token ' + prefs.getString('token'),
        "Content-Type": "application/json"
      });
      if (_response.statusCode == 200) {
        data = json.decode(_response.body);
        for (var item in data) {
          http.Response _result = await http.get(item['item'].toString());
          if (_result.statusCode == 200) {
            Map<String, dynamic> temp = json.decode(_result.body);
            temp['quantity'] = item['quantity'];
            temp['cart_url'] = item['url'];
            this.setState(() {
              cartList.add(temp);
            });
          }
        }
        this.setState(() {
          _isLoading = false;
          _timeout = false;
        });
      }
    } catch (e) {
      this.setState(() {
        _timeout = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    this._getCart();
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
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
          title: Text('Cart'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Material(
            color: Colors.grey[100],
            elevation: 0.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0))),
            child: Builder(builder: (BuildContext context) {

              if (_isLoading) {
                return Center(child: SpinKitFoldingCube(color:Colors.green));
              }

              if (_timeout) {
                return Center(
                    child: Text(
                  'Check Network Connection ❗',
                  style: TextStyle(fontSize: 18.0),
                ));
              }

              return Column(
                children: <Widget>[
                  SizedBox(height: 5.0),
                  Expanded(
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(height: 0.0, color: Colors.transparent),
                          itemCount: cartList == null ? 0 : cartList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: EdgeInsets.only(
                                    top: 1.0, left: 10.0, right: 10.0),
                                child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerUpdateCart(
                                                    cartList[index]))),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Row(
                                              crossAxisAlignment:CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Container(
                                                      child:Center(
                                                        child:ClipRRect(
                                                                borderRadius:BorderRadius.circular(360.0),
                                                                child: Image.network(
                                                                  cartList[index]['image'],
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
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                              cartList[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Product Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.0)),
                                                          _checkStock(
                                                                  cartList[
                                                                          index]
                                                                      [
                                                                      'avail_quantity'],
                                                                  cartList[
                                                                          index]
                                                                      [
                                                                      'quantity'])
                                                              ? Text(
                                                                  'Available',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Product Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                              .greenAccent[
                                                                          700]))
                                                              : Text(
                                                                  'Unavailable',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Product Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .red))
                                                        ],
                                                      ),
                                                    ]),
                                               
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text('Price',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Product Sans',
                                                                color: Colors
                                                                    .grey)),
                                                        Text(
                                                            '₹' +
                                                                _getPrice(
                                                                        cartList[index]
                                                                            [
                                                                            'rate'],
                                                                        cartList[index]
                                                                            [
                                                                            'quantity'])
                                                                    .substring(
                                                                        0,
                                                                        _getPrice(cartList[index]['rate'], cartList[index]['quantity']).indexOf('.') +
                                                                            2),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Product Sans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0))
                                                      ],
                                                    ),
                                                
                                              ])),
                                    )));
                          })),
                  AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        return Transform(
                            transform: Matrix4.translationValues(
                                0.0,
                                animation.value *
                                    MediaQuery.of(context).size.height,
                                0.0),
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
                                    width: MediaQuery.of(context)
                                        .copyWith()
                                        .size
                                        .width,
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height *
                                        0.14,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Center(
                                          child: RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 80.0, vertical: 10.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        color: Colors.white,
                                        onPressed: () {
                                           this.setState(() {
                                              _isLoading = true;
                                            });
                                          _placeOrder();
                                        },
                                        child: Text('Place  Order',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Product Sans')),
                                      )),
                                    ))));
                      })
                ],
              );
            })));
  }

  String _getPrice(String rate, String quantity) {
    var price;
    price = num.parse(rate) * num.parse(quantity);
    return price.toString();
  }

  bool _checkStock(String stock, String quantity) {
    if (num.parse(stock) < num.parse(quantity)) {
      return false;
    }
    return true;
  }

  _placeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(_checkAvailability())
    {
    try {
      Response result = await Dio()
          .get(globals.headurl + '/cust/order/',
              options: Options(headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json"
              }))
          ;
      if (result.statusCode == 200) {
        Navigator.of(context).popAndPushNamed('/customerorderscreen');
      }
    } catch (e) {
      _showDialog('Failed','Chech Network Connection');
    }
  }
  else{
    _showDialog('Stock Unavailable', 'Please Check the given Quantity');
  }
  }
  void _showDialog(String title,String content) {
    AlertDialog dialog = AlertDialog(
      shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text(title)),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(content)]),
    );
    showDialog(context: context, builder: (_) => dialog);
  }
  bool _checkAvailability()
  {
    for(var item in cartList){
      if(num.parse(item['avail_quantity']) < num.parse(item['quantity']))
      {
        return false;
      }
    }
    return true;
  }
}
