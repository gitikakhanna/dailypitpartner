import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';
import 'test_order_screen.dart';
import 'my_account_screen.dart';
class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DashBoardScreen(),
    MyOrderScreen(),
    MyAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dailypit Partner'),
      ),
      backgroundColor: Colors.blueGrey[50],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
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