import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerUpdateProduct extends StatefulWidget {
  final String productURL;
  FarmerUpdateProduct(this.productURL);
  @override
  _FarmerUpdateProductState createState() => _FarmerUpdateProductState();
}

class _FarmerUpdateProductState extends State<FarmerUpdateProduct> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _timeout = false;
  final _formKey = GlobalKey<FormState>();
  String farmerToken;
  Map<String, dynamic> data;
   AnimationController animationController;
  Animation animation;

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Stock Updated')),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Colors.greenAccent[700],
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/farmerlistproduct', ModalRoute.withName('/farmerdashboardscreen'));
              },
              child: Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ]),
    );

    showDialog(context: context, builder: (_) => successDialog);
  }

  void _showFailedDialog() {
    AlertDialog failedDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Failed ❗')),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text('Product could not be added.')]),
    );

    showDialog(context: context, builder: (_) => failedDialog);
  }

  void _showDeleteAlert(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Center(child: Text('Are you Sure ?')),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.red,
                    onPressed: () {
                       _deleteButton();
                    },
                    child: Text('Delete', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20.0),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ));
        });
  }

  _registerButton() async {
    this.setState(() {
      _isLoading = true;
    });
    FormData formData;
    if (_imageFile != null) {
      formData = FormData.fromMap({
        'name': productNameController.text,
        'family': familyNameController.text,
        "avail_quantity": avaQuantityController.text,
        "rate": priceController.text,
        "image": await MultipartFile.fromFile(_imageFile.path,
            filename: farmerToken + productNameController.text + '.jpg'),
      });
    } else {
      formData = FormData.fromMap({
        'name': productNameController.text,
        'family': familyNameController.text,
        "avail_quantity": avaQuantityController.text,
        "rate": priceController.text,
      });
    }

    try {
      Response response = await Dio()
          .put(data['url'],
              data: formData,
              options: Options(headers: {
                'Authorization': 'Token ' + farmerToken,
                "Content-Type": "application/json"
              }))
          ;
      if (response.statusCode == 200) {
        this.setState(() {
          _isLoading = false;
          _showSuccessDialog();
        });
      }
    } catch (e) {
      print(e.toString());
      this.setState(() {
        _isLoading = false;
        _showFailedDialog();
      });
    }
  }

  _deleteButton() async {
    this.setState(() {
      _isLoading = true;
    });
    try {
      Response response = await Dio()
          .delete(data['url'],
              options: Options(headers: {
                'Authorization': 'Token ' + farmerToken,
                "Content-Type": "application/json"
              }))
          ;
      if (response.statusCode == 204) {
        this.setState(() {
          _isLoading = false;
          Navigator.of(context).pushNamedAndRemoveUntil('/farmerlistproduct', ModalRoute.withName('/farmerdashboardscreen'));
        });
      }
    } catch (e) {
      print(e.toString());
      this.setState(() {
        _isLoading = false;
        _showFailedDialog();
      });
    }
  }

  _getProductDetails() async {
    this.setState(() {
      _isLoading = true;
    });
    try {
      http.Response result = await http.get(Uri.encodeFull(widget.productURL),
          headers: {"Accept": "application/json"});
      if (result.statusCode == 200) {
        this.setState(() {
          data = json.decode(result.body);
          productNameController.text = data['name'];
          familyNameController.text = data['family'];
          avaQuantityController.text = data['avail_quantity'];
          priceController.text = data['rate'];
          _isLoading = false;
        });
      }
    } catch (e) {
      _timeout = true;
      _isLoading = false;
    }
  }

  @override
  void initState() {
    this._getProductDetails();
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
          title: Text('Change Details'),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                            child: Center(
                                          child: _imageFile == null
                                              ? GestureDetector(
                                                  onTap: () => _openImagePickerModal(
                                                      context),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360.0),
                                                      child: Image.network(
                                                          data['image'],
                                                          fit: BoxFit.cover,
                                                          height: 200.0,
                                                          alignment: Alignment
                                                              .topCenter,
                                                          width: 200.0)))
                                              : GestureDetector(
                                                  onTap: () =>
                                                      _openImagePickerModal(
                                                          context),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(360.0),
                                                      child: Image.file(_imageFile, fit: BoxFit.cover, height: 200.0, alignment: Alignment.topCenter, width: 200.0))),
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
                                          obscureText: false,
                                          cursorColor: Colors.greenAccent[700],
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical:
                                                          MediaQuery.of(context)
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
                                                      BorderRadius.circular(
                                                          80.0))),
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
                                          obscureText: false,
                                          cursorColor: Colors.greenAccent[700],
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.02),
                                              hintText: "Product Family",
                                              prefixIcon: Icon(
                                                  Icons.donut_small,
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
                                                      BorderRadius.circular(
                                                          80.0))),
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
                                          obscureText: false,
                                          cursorColor: Colors.greenAccent[700],
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.02),
                                              hintText: "Available Quantity",
                                              prefixIcon: Icon(
                                                  Icons.swap_vertical_circle,
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
                                                      BorderRadius.circular(
                                                          80.0))),
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
                                          obscureText: false,
                                          cursorColor: Colors.greenAccent[700],
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.02),
                                              hintText: "Price",
                                              prefixIcon: Icon(
                                                  Icons.blur_circular,
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
                                                      BorderRadius.circular(
                                                          80.0))),
                                        ),
                                      ]))))),
                ],
              ))),
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
                                                onPressed: ()  {
                                                    if (_formKey.currentState.validate()) {
                                                      _registerButton();
                                                    }
                                                },
                                                child: Text('Update',
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
                                                onPressed: () =>  _showDeleteAlert(),
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
            ]);
        })
      ));
  }
}
