import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:uzhavar_mart/globals.dart' as globals;

import 'package:uzhavar_mart/Views/Customer_View/Customer_List_Product.dart';

class CustomerListFarmer extends StatefulWidget {
  final String url;
  CustomerListFarmer(this.url);

  @override
  _CustomerListFarmerState createState() => _CustomerListFarmerState();
}

class _CustomerListFarmerState extends State<CustomerListFarmer> {
  http.Response result, response;
  List data, productList;
  Map merchdata;
  bool _isLoading = false;
  bool _timeout = false;

  Future<void> getData() async {
    try {
      result = await http.get(Uri.encodeFull(widget.url + 'merch/'), headers: {
        "Accept": "application/json"
      });

      this.setState(() {
        data = json.decode(result.body);
      });

      this.setState(() {
        _isLoading = false;
      });
    } catch (e) {
      this.setState(() {
        _timeout = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    this.setState(() {
      _isLoading = true;
    });
    this.getData();
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
          title: Text('Farmers'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body:  Material(
        shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)
                  )
                ),
        color: Colors.grey[100],
        child:Builder(builder: (BuildContext context) {
          
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_timeout) {
            return Center(
                child: Text(
              'Check Network Connection !',
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
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => CustomerListProduct(value['url'])));
                    },
                    child: Card(
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                           Image.network(value["profile_pic"],width: MediaQuery.of(context).copyWith().size.width*0.2,),
                           Text(
                                value["first_name"] + ' ' + value["last_name"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).copyWith().size.width *
                                      0.04,
                                    fontWeight: FontWeight.w500)),
                          ],
                        )));
              }).toList());
        })));
  }
}