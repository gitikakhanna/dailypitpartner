import 'package:dailypitpartner/src/screens/current_order_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'blocs/login_provider.dart';
import 'screens/register_layout_screen.dart';
import 'screens/new_orders_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/main_screen.dart';
import 'blocs/register_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        return MainScreen();
      });
    } else if (settings.name == '/r') {
      return MaterialPageRoute(builder: (context) {
        return RegisterLayoutScreen();
      });
    } else if (settings.name == '/l') {
      return MaterialPageRoute(builder: (context) {
        return LoginScreen();
      });
    } else if (settings.name.contains('/c')) {
      return MaterialPageRoute(builder: (context) {
        final id = settings.name.replaceFirst('/c', '');
        return CurrentOrderScreen(
          orderId:id,
        );
      });
    }
     else if (settings.name.contains('/n')) {
      return MaterialPageRoute(builder: (context) {
        final id = settings.name.replaceFirst('/n', '');
        return NewOrderScreen(
          orderId: id,
        );
      });
    }
  }
}
