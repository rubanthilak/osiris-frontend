import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class FarmerProfileScreen extends StatefulWidget {
  FarmerProfileScreen({Key key}) : super(key: key);

  @override
  _FarmerProfileScreenState createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
   bool _isLoading = false;
   bool _timeout = false;
   var data;
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState((){
      _isLoading = true;
    });
    try{
      print(prefs.getString('url'));
     Response result = await Dio().get(globals.headurl + prefs.getString('url'),
     options:Options(headers: {
            "Accept": "application/json"
          }));
      
      data = result.data;
      this.setState((){
        _isLoading = false;
        _timeout = false;
      });
    
    }
    catch(e){
      print(e);
      this.setState((){
        _isLoading = false;
        _timeout = true;
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
          title: Text('Profile'),
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

          if (_timeout) {
            return Center(
              child:Text(
              'Check Network Connection',
              style: TextStyle(fontFamily: 'Product Sans',fontSize: 24.0,color:Colors.black),
            ));
          }

          return ListView(
            children: <Widget>[

              SizedBox(height:25.0),


              Container(
                child:Center(
                  child:ClipRRect(
                      borderRadius: BorderRadius.circular(360.0),
                      child: Image.network(data['profile_pic'],
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 200.0)))),

              SizedBox(height:25.0),
              
              
              Text(
                data['first_name'],
                style:TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                data['last_name'],
                style:TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Product Sans',
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height:25.0),

               Text(
               'Email',
                style:TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                data['email'],
                style:TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Product Sans',
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height:25.0),

              Text(
               'Phone',
                style:TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                data['phone'],
                style:TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Product Sans',
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              )
            ],
          );
        }
        ))
    );
  }
}