import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:uzhavar_mart/globals.dart' as globals;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRegisterScreen extends StatefulWidget {
  CustomerRegisterScreen({Key key}) : super(key: key);

  @override
  _CustomerRegisterScreenState createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  bool _isHidden = true;
  bool _isLoading = false;
  bool _timeout = false;
  final _formKey = GlobalKey<FormState>();
  Map<String,dynamic> userMap = new Map<String,dynamic>();

   //to get the data from the fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController mailIdController = TextEditingController();
  TextEditingController addressController = TextEditingController();

   //To display result in alert box
  void _showSuccessDialog() {
    AlertDialog successDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Success ✔')),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Colors.greenAccent[700],
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/customerdashboardscreen', (Route<dynamic> route) => false);
              },
              child: Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ]),
    );
    showDialog(context: context, builder: (_) => successDialog);
    Timer(new Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/customerdashboardscreen', (Route<dynamic> route) => false);
    });
  }

  void _showFailedDialog() {
    AlertDialog failedDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Center(child: Text('Failed ❗')),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text('Phone Number already exist')]),
    );
  }

  // To store the file provided by the image_picker
  File _imageFile;
  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
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

   //To store the token in share preference or local disk
 _storeToken(String token, String url, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('url', url.substring(32,url.length));
    prefs.setString('user_type', userType);
  }

  _registerButton() async {
    this.setState(() {
      _isLoading = true;
    });
    FormData formData;
    if (_imageFile != null) {
      formData = FormData.fromMap({
        "first_name": userMap["first_name"],
        "last_name": userMap["last_name"],
        "email": userMap["email"],
        "username": userMap["username"],
        "phone": userMap["phone"],
        "password": userMap["password"],
        "address": userMap["address"],
        "profile_pic": await MultipartFile.fromFile(_imageFile.path,
            filename: userMap['phone'] + ".jpg"),
      });
    } else {
      formData = FormData.fromMap({
        "first_name": userMap["first_name"],
        "last_name": userMap["last_name"],
        "email": userMap["email"],
        "username": userMap["username"],
        "phone": userMap["phone"],
        "password": userMap["password"],
        "address": userMap["address"],
      });
    }

    try {
      Response response = await Dio()
          .post(globals.headurl + '/cust/register/', data: formData);
          
      if (response.statusCode == 201) {
        this.setState(() {
           Map<String, dynamic> temp = json.decode(response.toString());
          _storeToken(temp['token'], temp['url'], 'user');
          _isLoading = false;
          _showSuccessDialog();
        });
      }
    } catch (e) {
      this.setState(() {
        _isLoading = false;
        _showFailedDialog();
      });
    }
  }
  
  
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
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
          title: Text('Register'),
        ),
        body:  Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)
                  )
                ),
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
          
          return Form(
                key: _formKey,
                child:Padding(
                padding: EdgeInsets.only(left:25.0,right:25.0,top:10.0),
                child:ListView(
          children: <Widget>[
               Container(
                  child: Center(
                    child: _imageFile == null
                        ? GestureDetector(
                            onTap: () =>_openImagePickerModal(context),
                            child: Icon(
                                Icons.account_circle,
                                color: Colors.grey,
                                size: 150.0))
                        : GestureDetector(
                            onTap: () =>_openImagePickerModal(context),
                            child: ClipRRect(
                                borderRadius:BorderRadius.circular(360.0),
                                child: Image.file(
                                    _imageFile,
                                    fit: BoxFit.cover,
                                    height: 150.0,
                                    alignment: Alignment.topCenter,
                                    width: 150.0))),
                  )),
                  SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return '*Required Field';
                                              }
                                              return null;
                                            },
                                            controller: firstNameController,
                                            onChanged: (value) {
                                              userMap['first_name'] =
                                                  firstNameController.text;
                                            },
                                            obscureText: false,
                                            cursorColor:
                                                Colors.greenAccent[700],
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.02),
                                                hintText: "First Name",
                                                prefixIcon: Icon(Icons.person,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .greenAccent[700],
                                                        width: 3.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0))),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          TextFormField(
                                            controller: lastNameController,
                                            onChanged: (value) {
                                              userMap['last_name'] =
                                                  lastNameController.text;
                                            },
                                            obscureText: false,
                                            cursorColor:
                                                Colors.greenAccent[700],
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.02),
                                                hintText: "Last Name",
                                                prefixIcon: Icon(Icons.person,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .greenAccent[700],
                                                        width: 3.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0))),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return '*Required Field';
                                              }
                                              return null;
                                            },
                                            controller: phoneNumberController,
                                            onChanged: (value) {
                                              userMap['phone'] =
                                                  phoneNumberController.text;
                                              userMap['username'] =
                                                  phoneNumberController.text;
                                            },
                                            obscureText: false,
                                            cursorColor:
                                                Colors.greenAccent[700],
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.02),
                                                hintText: "Phone Number",
                                                prefixIcon: Icon(Icons.phone,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .greenAccent[700],
                                                        width: 3.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0))),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return '*Required Field';
                                              }
                                              return null;
                                            },
                                            controller: mailIdController,
                                            onChanged: (value) {
                                              userMap['email'] =
                                                  mailIdController.text;
                                            },
                                            obscureText: false,
                                            cursorColor:
                                                Colors.greenAccent[700],
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.02),
                                                hintText: "Mail ID",
                                                prefixIcon: Icon(Icons.mail,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .greenAccent[700],
                                                        width: 3.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0))),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return '*Required Field';
                                              }
                                              return null;
                                            },
                                            controller: addressController,
                                            onChanged: (value) {
                                              userMap['address'] =
                                                  addressController.text;
                                            },
                                            obscureText: false,
                                            cursorColor:
                                                Colors.greenAccent[700],
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.02),
                                                hintText: "Address",
                                                prefixIcon: Icon(Icons.home,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .greenAccent[700],
                                                        width: 3.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0))),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return '*Required Field';
                                              }
                                              return null;
                                            },
                                            controller: passwordController,
                                            onChanged: (value) {
                                              userMap['password'] =
                                                  passwordController.text;
                                            },
                                            obscureText: _isHidden,
                                            cursorColor:
                                                Colors.greenAccent[700],
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: MediaQuery.of(context)
                                                            .copyWith()
                                                            .size
                                                            .height *
                                                        0.02),
                                                hintText: "Password",
                                                prefixIcon: Icon(Icons.lock,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                suffixIcon: IconButton(
                                                    onPressed:
                                                        _toggleVisibility,
                                                    icon: _isHidden
                                                        ? Icon(Icons.visibility_off,
                                                            color: Colors.grey)
                                                        : Icon(Icons.visibility,
                                                            color: Colors
                                                                .red[300])),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(color: Colors.greenAccent[700], width: 3.0),
                                                    borderRadius: BorderRadius.circular(80.0))),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return '*Required Field';
                                              }
                                              return null;
                                            },
                                            controller: cPasswordController,
                                            obscureText: _isHidden,
                                            cursorColor:
                                                Colors.greenAccent[700],
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height *
                                                            0.02),
                                                hintText: "Confirm Password",
                                                prefixIcon: Icon(Icons.lock,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .greenAccent[700],
                                                        width: 3.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0))),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 30.0, bottom: 30.0),
                                              child: RaisedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                          _registerButton();
                                                    }
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0)),
                                                  color:
                                                      Colors.greenAccent[700],
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .copyWith()
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                      child: Center(
                                                          child: Text(
                                                        'Register',
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .copyWith()
                                                                    .size
                                                                    .height *
                                                                0.025,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ))))),
            ]
           ))
          );
        }
      )
    ));
  }
}

  