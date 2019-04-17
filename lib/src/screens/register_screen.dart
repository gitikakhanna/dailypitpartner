import 'package:flutter/material.dart';
import 'register_layout_screen.dart';
import '../blocs/register_provider.dart';

class RegisterScreen extends StatelessWidget{
  Widget build(context) {
    return RegisterProvider(
      child: MaterialApp(
        title: 'Register Screen',
        home: Scaffold(
          body: RegisterLayoutScreen(),
        ),
      ),
    );
  }
}