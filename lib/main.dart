import 'package:flutter/material.dart';
import 'package:uzhavar_mart/Main_Screen.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Cart_Screen.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Dashboard_Screen.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Login_Screen.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Order_Screen.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Dashboard_Screen.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_List_Product.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Login_Screen.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Register_Screen.dart';
import 'package:uzhavar_mart/Views/Farmer_View/Farmer_Welcome_Screen.dart';
import 'package:uzhavar_mart/Welcome_Screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uzhavar Mart',
      routes: <String, WidgetBuilder>{
        //common view
        '/welcomescreen': (BuildContext context) => new WelcomeScreen(),
        '/mainscreen': (BuildContext context) => new MainScreen(),
        //farmer view
        '/farmerwelcomescreen': (BuildContext context) => new FarmerWelcomeScreen(),
        '/farmerloginscreen': (BuildContext context) => new FarmerLoginScreen(),
        '/farmerregisterscreen': (BuildContext context) => new FarmerRegisterScreen(),
        '/farmerdashboardscreen': (BuildContext context) => new FarmerDashboardScreen(),
        '/farmerlistproduct': (BuildContext context) => new FarmerListProduct(),
        //Customer View
        '/customerdashboardscreen': (BuildContext context) => new CustomerDashboardScreen(),
        '/customerloginscreen': (BuildContext context) => new CustomerLoginScreen(),
        '/customercartscreen': (BuildContext context) => new CustomerCartScreen(),
        '/customerorderscreen': (BuildContext context) => new CustomerOrderScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:MainScreen()
    );
  }
}
