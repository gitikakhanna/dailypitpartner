import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'blocs/login_provider.dart';
import 'screens/register_layout_screen.dart';
import 'blocs/register_provider.dart';


class App extends StatelessWidget{
  build(context){
    //wrapping material app with provider ... everything insider material app can reach the provider
    return RegisterProvider(
      child: MaterialApp(
      title: 'Login form with BLOC',
      home: Scaffold(
        body: RegisterLayoutScreen(),
        ),
    ) ,
  );
     
  }
}