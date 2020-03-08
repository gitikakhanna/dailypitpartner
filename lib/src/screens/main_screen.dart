import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailypitpartner/src/resources/dailypit_api_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../order_status/index.dart';
import '../target/index.dart';
import 'my_account_screen.dart';
import 'new_dashboard_screen.dart';
import 'test_order_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _messaging = FirebaseMessaging();

  int _currentIndex = 0;
  final List<Widget> _children = [
    NewDashboardScreen(),
    MyOrderScreen(),
    MyAccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    initMessagingToken();
  }

  //TODO: Update Token to PHP , remove Firebase
  initMessagingToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    _messaging.getToken().then((token) {
      DailypitApiProvider().updateFCMToken(user.uid, token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Dailypit Partner'),
      //   elevation: 2.0,
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      backgroundColor: Colors.blueGrey[50],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          OrderStatusBloc().dispatch(LoadOrderStatusEvent());
          TargetBloc().dispatch(LoadTargetEvent());

          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text(
                'Home',
                style:
                    TextStyle(fontFamily: 'ProductSans', color: Colors.black),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text(
                'My Orders',
                style:
                    TextStyle(fontFamily: 'ProductSans', color: Colors.black),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                  color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text(
                'My Account',
                style:
                    TextStyle(fontFamily: 'ProductSans', color: Colors.black),
              )),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
