import 'package:flutter/material.dart';
import '../screens/location_screen.dart';
import '../widgets/searchlocation_widget.dart';

class App extends StatelessWidget{
  Widget build(context){
    return MaterialApp(
      title:'Dailypit Partner',
      routes: {
        "/":(_) => SearchLocation(),
      },
      // home: GetLocation(),
    );
  }
}