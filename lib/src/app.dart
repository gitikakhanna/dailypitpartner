import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'blocs/login_provider.dart';
import 'blocs/register_provider.dart';
import 'screens/current_order_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/new_orders_screen.dart';
import 'screens/register_layout_screen.dart';
import 'utils/constants.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _messaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    initFirebaseMessaging();
  }

  initFirebaseMessaging() {
    _messaging.configure(
      onMessage: (Map<String, dynamic> map) async {
        if (map['data']['id'] == '1')
          showRequestNotification(map);
        else if (map['data']['id'] == '2') showAssignedNotification(map);
      },
      onResume: (Map<String, dynamic> map) async {
        if (map['data']['id'] == '1')
          showRequestNotification(map);
        else if (map['data']['id'] == '2') showAssignedNotification(map);
      },
      onLaunch: (Map<String, dynamic> map) async {
        if (map['data']['id'] == '1')
          showRequestNotification(map);
        else if (map['data']['id'] == '2') showAssignedNotification(map);
      },
    );
  }

  showAssignedNotification(Map<String, dynamic> map) {
    showOverlayNotification(
      (context) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: SizedBox.fromSize(
                      size: const Size(40, 40),
                      child: ClipOval(
                          child: Container(
                        color: Colors.black,
                      ))),
                  title: Text('Dailypit'),
                  subtitle: Text('We have assigned you an order'),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    },
                  ),
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CurrentOrderScreen(
                                    orderId: map['data']['orderId'],
                                  )),
                        );
                        OverlaySupportEntry.of(context).dismiss();
                      },
                      child: Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      duration: Duration(
        milliseconds: 10000,
      ),
    );
  }

  showRequestNotification(Map<String, dynamic> map) {
    showOverlayNotification(
      (context) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: SizedBox.fromSize(
                      size: const Size(40, 40),
                      child: ClipOval(
                          child: Container(
                        color: Colors.black,
                      ))),
                  title: Text('Dailypit'),
                  subtitle: Text('There is a service Request for you'),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    },
                  ),
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewOrderScreen(
                                    orderId: map['data']['orderId'],
                                  )),
                        );
                        OverlaySupportEntry.of(context).dismiss();
                      },
                      child: Text('View Details'),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        acceptRequest(map['data']['orderId']);
                        OverlaySupportEntry.of(context).dismiss();
                      },
                      child: Text('Accept'),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        toast('declined');
                        OverlaySupportEntry.of(context).dismiss();
                      },
                      child: Text('Decline'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      duration: Duration(
        milliseconds: 10000,
      ),
    );
  }

  acceptRequest(String orderId) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      Firestore.instance.document('orders/$orderId').updateData({
        //'status': 'accepted',
        'list': FieldValue.arrayUnion(<String>[user.uid])
      });
    });
  }

  Widget build(BuildContext context) {
    //wrapping material app with provider ... everything insider material app can reach the provider

    return LoginProvider(
      child: RegisterProvider(
        child: OverlaySupport(
          child: MaterialApp(
            title: 'Login form with BLOC',
            onGenerateRoute: routes,
            home: Constants.prefs.getBool(Constants.pref_logged_in) == true
                ? MainScreen()
                : LoginScreen(),
          ),
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
          orderId: id,
        );
      });
    } else if (settings.name.contains('/n')) {
      return MaterialPageRoute(builder: (context) {
        final id = settings.name.replaceFirst('/n', '');
        return NewOrderScreen(
          orderId: id,
        );
      });
    }
  }
}
