import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FarmerRegisterScreen extends StatefulWidget {
  FarmerRegisterScreen({Key key}) : super(key: key);

  @override
  _FarmerRegisterScreenState createState() => _FarmerRegisterScreenState();
}

class _FarmerRegisterScreenState extends State<FarmerRegisterScreen> {
  Map<String, dynamic> temp;

  final _formKey = GlobalKey<FormState>();

  //to get the data from the fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController mailIdController = TextEditingController();

  //Used to pass the value to upload function
  Map<String, String> farmerMap = new Map<String, String>();

  var _hubSelected;
  bool _isHidden = true;
  bool _isLoading = false;
  bool _timeout = false;

  // To store the file provided by the image_picker
  File _imageFile;
  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
  }

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
                    '/farmerdashboardscreen', (Route<dynamic> route) => false);
              },
              child: Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ]),
    );
    showDialog(context: context, builder: (_) => successDialog);
    Timer(new Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/farmerdashboardscreen', (Route<dynamic> route) => false);
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

    showDialog(context: context, builder: (_) => failedDialog);
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  http.Response result;
  Response response;
  List data;

  //To store the token in share preference or local disk
  Future<void> _storeToken(String token, String url, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('url', url.substring(32,url.length));
    prefs.setString('user_type', userType);
  }

  //To upload details and image to the REST API
  _registerButton(File imageFile, Map<String, String> map) async {
    this.setState(() {
      _isLoading = true;
    });
    FormData formData;
    if (imageFile != null) {
      formData = FormData.fromMap({
        "first_name": map["first_name"],
        "last_name": map["last_name"],
        "email": map["email"],
        "username": map["username"],
        "phone": map["phone"],
        "password": map["password"],
        "hub": map["hub"],
        "profile_pic": await MultipartFile.fromFile(imageFile.path,
            filename: map['phone'] + ".jpg"),
      });
    } else {
      formData = FormData.fromMap({
        "first_name": map["first_name"],
        "last_name": map["last_name"],
        "email": map["email"],
        "username": map["username"],
        "phone": map["phone"],
        "password": map["password"],
        "hub": map["hub"],
      });
    }

    try {
      response = await Dio().post(globals.headurl + '/hubs/merch/create/', data: formData);
      if (response.statusCode == 201) {
        this.setState(() {
          temp = json.decode(response.toString());
          _storeToken(temp['token'], temp['url'], 'farmer');
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

  //To Get the list of Hubs in drop down list for Registration Process
  Future<void> _getData() async {
    try {
      result = await http.get(Uri.encodeFull(globals.headurl + '/hubs/'),
          headers: {
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

  @override
  void initState() {
    this.setState(() {
      _isLoading = true;
    });
    this._getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Colors.greenAccent[700],
              Color(0xff4AC483),
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Material(
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0))),
                            color: Colors.white,
                            child: Builder(builder: (BuildContext context) {
                              
                              if (_isLoading) {
                                return Container(
                                height: MediaQuery.of(context).copyWith().size.height*0.9,
                                child:Center(
                                    child:  SpinKitFoldingCube(color: Colors.greenAccent[700])));
                              }

                              if (_timeout) {
                                return Container(
                                height: MediaQuery.of(context).copyWith().size.height*0.9,
                                child:Center(
                                    child: Text(
                                  'Check Network Connection ❗',
                                  style: TextStyle(fontSize: 18.0),
                                )));
                              }

                              return Container(
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
                                                    onTap: () =>
                                                        _openImagePickerModal(
                                                            context),
                                                    child: Icon(
                                                        Icons.account_circle,
                                                        color: Colors.grey,
                                                        size: 150.0))
                                                : GestureDetector(
                                                    onTap: () =>
                                                        _openImagePickerModal(
                                                            context),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                360.0),
                                                        child: Image.file(
                                                            _imageFile,
                                                            fit: BoxFit.cover,
                                                            height: 150.0,
                                                            alignment: Alignment
                                                                .topCenter,
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
                                              farmerMap['first_name'] =
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
                                              farmerMap['last_name'] =
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
                                              farmerMap['phone'] =
                                                  phoneNumberController.text;
                                              farmerMap['username'] =
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
                                              farmerMap['email'] =
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
                                          Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(80.0)),
                                              ),
                                              child: Row(children: <Widget>[
                                                SizedBox(width: 10.0),
                                                Icon(Icons.location_on,
                                                    color: Colors
                                                        .greenAccent[700]),
                                                Container(
                                                    width: 260,
                                                    child: DropdownButtonHideUnderline(
                                                        child: ButtonTheme(
                                                            alignedDropdown: true,
                                                            child: DropdownButton(
                                                                hint: Text('Hub'),
                                                                items: data.map((value) {
                                                                  return DropdownMenuItem(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value[
                                                                            'area']),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    _hubSelected =
                                                                        value;
                                                                    farmerMap[
                                                                            'hub'] =
                                                                        _hubSelected[
                                                                            'url'];
                                                                  });
                                                                },
                                                                value: _hubSelected))))
                                              ])),
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
                                              farmerMap['password'] =
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
                                                  top: 25.0, bottom: 10.0),
                                              child: RaisedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      _registerButton(
                                                          _imageFile,
                                                          farmerMap);
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
                                        ],
                                      )));
                            }))),
                  ],
                ))));
  }
}
