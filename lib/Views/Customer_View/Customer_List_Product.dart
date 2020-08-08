import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uzhavar_mart/globals.dart' as globals;

import 'package:uzhavar_mart/Views/Customer_View/Customer_Product_Details.dart';

class CustomerListProduct extends StatefulWidget {
  final String url;
  CustomerListProduct(this.url);

  @override
  _CustomerListProductState createState() => _CustomerListProductState();
}

class _CustomerListProductState extends State<CustomerListProduct>{

 
  bool _isLoading = false;
  bool _timeout = false;
  http.Response result;
  List data = [];

  _getData() async {
    this.setState(() {
      _isLoading = true;
    });
    try {
      result = await http.get(
          Uri.encodeFull(widget.url +'products/'),
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
          title: Text('Products'),
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProductDetails(value['url']))),
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
  }
}
