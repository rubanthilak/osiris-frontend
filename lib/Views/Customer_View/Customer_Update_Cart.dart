import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerUpdateCart extends StatefulWidget {
  final Map<String, dynamic> data;
  CustomerUpdateCart(this.data);

  @override
  _CustomerUpdateCartState createState() => _CustomerUpdateCartState();
}

class _CustomerUpdateCartState extends State<CustomerUpdateCart> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  TextEditingController quantityController = new TextEditingController();
  
    @override
  void initState() {
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
          ),

      body:Material(
      color:Colors.grey[100],
      elevation: 0.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0))),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).copyWith().size.height *
                                    0.025,),
                Container(
                        child: Center(
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(360.0),
                                child: Image.network(widget.data['image'],
                                    fit: BoxFit.cover,
                                    height: 250.0,
                                    alignment: Alignment.topCenter,
                                    width: 250.0)))),
                          SizedBox(
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.02,
                          ),
                          //Product & Family Name
                          Column(
                            children: <Widget>[
                              Text(widget.data['name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 42.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Product Sans'),
                                      textAlign: TextAlign.center,),
                              Text(widget.data['family'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0)),
                            ],
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.03,
                          ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                           Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Rate/Kg',
                                  style:TextStyle(
                                      fontFamily: 'Product Sans',
                                      color:Colors.grey
                                    )),
                                  Text('₹'+widget.data['rate'].substring(0,widget.data['rate'].indexOf('.')+2),
                                  style:TextStyle(
                                      fontFamily: 'Product Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0
                                    )
                                  )
                                ],
                              ),
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Available',
                                  style:TextStyle(
                                      fontFamily: 'Product Sans',
                                      color:Colors.grey
                                    )),
                                  Text(widget.data['avail_quantity'].substring(0,widget.data['avail_quantity'].indexOf('.')+2)+' Kg',
                                  style:TextStyle(
                                      fontFamily: 'Product Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0
                                    )
                                  )
                                ],
                              ),
                               
                              ],
                            ),
                       SizedBox(
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.05,
                          ),
                         
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Price',
                                 style:TextStyle(
                                    fontFamily: 'Product Sans',
                                    color:Colors.grey
                                  )),
                                Text('₹'+_getPrice(widget.data['rate'],widget.data['quantity']).substring(
                                  0,
                                  _getPrice(widget.data['rate'],widget.data['quantity']).indexOf('.')+2),
                                  style:TextStyle(
                                    fontFamily: 'Product Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0
                                  )
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Quantity',
                                  style:TextStyle(
                                      fontFamily: 'Product Sans',
                                      color:Colors.grey
                                    )),
                                  Text(widget.data['quantity'].substring(0,widget.data['quantity'].indexOf('.')+2)+' Kg',
                                  style:TextStyle(
                                      fontFamily: 'Product Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0
                                    )
                                  )
                                ],
                              ),
                           
                              ],
                            ),
              ],
            )
          ),
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
                              height:MediaQuery.of(context).copyWith().size.height*0.14,
                              child: Material(
                                color: Colors.transparent,
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        RaisedButton(
                                                padding: EdgeInsets.symmetric(horizontal:40.0,vertical:10.0),
                                                shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(50.0)),
                                                color: Colors.white,
                                                onPressed: ()  => _addCartAlert(context,onLoginPressed: () => _addCartFn()),
                                                child: Text('Change',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 22.0,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: 'Product Sans')),
                                          ),
                                          RaisedButton(
                                                padding: EdgeInsets.symmetric(horizontal:40.0,vertical:10.0),
                                                shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(50.0)),
                                                color: Colors.white,
                                                onPressed: () => _deleteCartItem(),
                                                child: Text('Remove',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 22.0,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: 'Product Sans')),
                                          )
                                      ],
                                    ) 
                                    ),
                              ))
                        ));
                    })
        ],
      )
      )
    );
  }
   String _getPrice(String rate,String quantity)
  {
    var price;
    price = num.parse(rate) * num.parse(quantity);
    return price.toString();
  }

  _deleteCartItem() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();      
    try {
      http.Response _response = await http.delete(widget.data['cart_url'],
             headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json"
              });
      if (_response.statusCode == 204) {
         Navigator.of(context).pushNamedAndRemoveUntil('/customercartscreen', ModalRoute.withName('/customerdashboardscreen'));
      }
    } catch (e) {
      this.setState(() {
         Navigator.pop(context);
         _showFailedDialog();
      });
    }
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
      Response _response = await Dio().put(widget.data['cart_url'],
              data: {
                'item': widget.data['url'],
                'quantity' : quantityController.text
              },
              options:Options (headers: {
                'Authorization': 'Token ' + prefs.getString('token'),
                "Content-Type": "application/json"
              }));
      if (_response.statusCode == 200) {
        quantityController.text = '';
        Navigator.of(context).pushNamedAndRemoveUntil('/customercartscreen', ModalRoute.withName('/customerdashboardscreen'));
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
  
}