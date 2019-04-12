import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget{
  // BottomNavigation ({Key key} : super(key: key));
  _BottomNavigationState createState() => _BottomNavigationState(); 
}

class _BottomNavigationState extends State<BottomNavigation>{
  int _selectedIndex = 1;
  // final _widgetOptions = [
  //   Text('Index 0: Home'),
  //   Text('Index 1: Orders'),
  //   Text('Index 2: Profile'),
  // ];
  
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_turned_in),
          title: Text('Orders')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile')
        ),
      ],

      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index){
    setState(() {
     _selectedIndex = index; 
     print("$_selectedIndex");
    });
  } 
}