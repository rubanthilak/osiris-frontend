import 'package:flutter/material.dart';
import 'package:uzhavar_mart/Views/Customer_View/Customer_Order_Dispatched_Screen.dart';
import 'package:uzhavar_mart/globals.dart' as globals;
import 'package:uzhavar_mart/Views/Customer_View/Customer_Order_Processing_Screen.dart';

class CustomerOrderScreen extends StatefulWidget {
  CustomerOrderScreen({Key key}) : super(key: key);

  @override
  _CustomerOrderScreenState createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;

   @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.greenAccent[700],
        appBar: new AppBar(
        leading: new IconButton(
              padding: EdgeInsets.all(0.0),
              icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          title: Text('Orders'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w100,fontFamily: 'Product Sans',fontSize:12.0),
          labelColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Product Sans',fontSize:16.0),
          tabs: [
          new Tab(text: 'Processing',),
          new Tab(text: 'Dispatched'),
        ],
        controller: _tabController,
        indicatorColor: Colors.greenAccent[700]
        ),
        bottomOpacity: 1,
      ),
       body: TabBarView(
          children: [
            CustomerOrderProcessingScreen(),
            CustomerOrderDispatchedScreen()
      ],
      controller: _tabController,)
    );
  }
}