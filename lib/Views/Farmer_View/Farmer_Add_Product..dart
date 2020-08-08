import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerAddProduct extends StatefulWidget {
  
  @override
  _FarmerAddProductState createState() => _FarmerAddProductState();
}

class _FarmerAddProductState extends State<FarmerAddProduct> with SingleTickerProviderStateMixin{

  bool _isLoading = false;
  bool _timeout = false;
  final _formKey = GlobalKey<FormState>();
  String farmerToken;
   AnimationController animationController;
    Animation animation;
  Map<String,dynamic> productMap = new Map<String,dynamic>();

  //to get the data from the fields
  TextEditingController productNameController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  TextEditingController avaQuantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // To store the file provided by the image_picker locally 
  File _imageFile;
  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    farmerToken = prefs.getString("token");
  }

  //Opens bottom  panel to select the camera or gallery
  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Select Profile Picture',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
      }

  //To display result in alert box
  void _showSuccessDialog() {
    AlertDialog successDialog = AlertDialog(
      shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Product Added')),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Colors.greenAccent[700],
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ]),
    );

    showDialog(context: context, builder: (_) => successDialog);
     
  }

  void _showFailedDialog() {
    AlertDialog failedDialog = AlertDialog(
      shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Failed ❗')),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text('Product could not be added.')]),
    );
    showDialog(context: context, builder: (_) => failedDialog);
  }


  _registerButton(File image,Map<String,dynamic> map) async{
    this.setState(() {
      _isLoading = true;
    });
    FormData formData;
    if (image != null) {
         formData = FormData.fromMap({
            'name': map['productName'],
            'family': map['familyName'],
            "avail_quantity": map['quantity'],
            "rate": map['price'],
            "image": await MultipartFile.fromFile(image.path,filename: farmerToken + map['productName'] + '.jpg'),
         });   
    }
    else
    {
        formData = FormData.fromMap({
                    'name': map['productName'],
                    'family': map['familyName'],
                    "avail_quantity": map['quantity'],
                    "rate": map['price'],
                }); 
    }

    try{
      Response response = await Dio().post(
        globals.headurl + '/hubs/products/create/',
        data:formData,
         options:
              Options(
              headers: {
                'Authorization': 'Token ' + farmerToken,
                "Content-Type": "application/json"
              })
      );
       if (response.statusCode == 201) {
        this.setState(() {
          _isLoading = false;
          _showSuccessDialog();
        });
      }
    }
    catch(e)
    {
      print(e.toString());
      this.setState(() {
        _isLoading = false;
        _showFailedDialog();
      });
    }
  }

  @override
  void initState() {
    this._getToken();
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
          title: Text('Add Product'),
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
            return Center(child: CircularProgressIndicator());
          }

          if (_timeout) {
            return Center(
                child: Text(
              'Check Network Connection ❗',
              style: TextStyle(fontSize: 18.0),
            ));
          }

          return Column(
            children:<Widget>[
            Form(
            key: _formKey,
            child: Expanded(
              child:ListView(
              children: <Widget>[
                Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        color: Colors.transparent,
                        child: Container(
                          child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 20.0,
                                    bottom: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                        child: Center(
                                      child: _imageFile == null
                                          ? GestureDetector(
                                              onTap: () =>
                                                  _openImagePickerModal(
                                                      context),
                                              child: Icon(Icons.add_circle,
                                                  color: Colors.grey,
                                                  size: 200.0))
                                          : GestureDetector(
                                              onTap: () =>
                                                  _openImagePickerModal(
                                                      context),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360.0),
                                                  child: Image.file(_imageFile,
                                                      fit: BoxFit.cover,
                                                      height: 200.0,
                                                      alignment:
                                                          Alignment.topCenter,
                                                      width: 200.0))),
                                    )),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter Product Name';
                                        }
                                        return null;
                                      },
                                      controller: productNameController,
                                      onChanged: (value) {
                                        productMap['productName'] = productNameController.text;
                                      },
                                      obscureText: false,
                                      cursorColor: Colors.greenAccent[700],
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height *
                                                  0.02),
                                          hintText: "Product Name",
                                          prefixIcon: Icon(Icons.restaurant,
                                              color: Colors.greenAccent[700]),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.greenAccent[700]),
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.greenAccent[700]),
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.greenAccent[700],
                                                  width: 3.0),
                                              borderRadius:
                                                  BorderRadius.circular(80.0))),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter Family Name';
                                        }
                                        return null;
                                      },
                                      controller: familyNameController,
                                      onChanged: (value) {
                                        productMap['familyName'] = familyNameController.text;
                                      },
                                      obscureText: false,
                                      cursorColor: Colors.greenAccent[700],
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height *
                                                  0.02),
                                          hintText: "Product Family",
                                          prefixIcon: Icon(Icons.donut_small,
                                              color: Colors.greenAccent[700]),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.greenAccent[700]),
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.greenAccent[700]),
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.greenAccent[700],
                                                  width: 3.0),
                                              borderRadius:
                                                  BorderRadius.circular(80.0))),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter Available Quantity';
                                        }
                                        return null;
                                      },
                                      controller: avaQuantityController,
                                      onChanged: (value) {
                                        productMap['quantity'] = avaQuantityController.text;
                                      },
                                      obscureText: false,
                                      cursorColor: Colors.greenAccent[700],
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height *
                                                  0.02),
                                          hintText: "Available Quantity",
                                          prefixIcon: Icon(Icons.swap_vertical_circle,
                                              color: Colors.greenAccent[700]),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.greenAccent[700]),
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.greenAccent[700]),
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.greenAccent[700],
                                                  width: 3.0),
                                              borderRadius:
                                                  BorderRadius.circular(80.0))),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please Enter Price';
                                        }
                                        return null;
                                      },
                                      controller: priceController,
                                      onChanged: (value) {
                                        productMap['price'] = priceController.text;
                                      },
                                      obscureText: false,
                                      cursorColor: Colors.greenAccent[700],
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height *
                                                  0.02),
                                          hintText: "Price",
                                          prefixIcon: Icon(Icons.blur_circular,
                                              color: Colors.greenAccent[700]),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.greenAccent[700]),
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.greenAccent[700]),
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.greenAccent[700],
                                                  width: 3.0),
                                              borderRadius:
                                                  BorderRadius.circular(80.0))),
                                    ),
                                  ]))
                        )
                        )),
              ],
            )
          )),
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
                              height:MediaQuery.of(context).copyWith().size.height*0.14,
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
                                     if (_formKey.currentState.validate()) {
                                    _registerButton(_imageFile,productMap);
                                  }
                                  },
                                  child: Text('Add  Product',
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
      })
    ));
  }
}