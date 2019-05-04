import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'blocs/login_provider.dart';
import 'screens/register_layout_screen.dart';
import 'screens/new_orders_screen.dart';
//import 'screens/login_screen.dart';
import 'blocs/register_provider.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Widget build(BuildContext context) {
    //wrapping material app with provider ... everything insider material app can reach the provider

    return LoginProvider(
      child: RegisterProvider(
        child: MaterialApp(
          title: 'Login form with BLOC',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) {
        return LoginScreen();
      });
    } else if (settings.name == '/r') {
      return MaterialPageRoute(builder: (context) {
        return RegisterLayoutScreen();
      });
    } else {
      return MaterialPageRoute(builder: (context) {
        return NewOrderScreen();
      });
    }
  }
}
