import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NewOrderScreen extends StatefulWidget {
  NewOrderScreen({Key key}) : super(key: key);

  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {

  final _messaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messaging.configure(
      onMessage: (Map<String,dynamic> map) async{
        print('onMessag: ');
        Navigator.of(context).pushNamed('/n');
      },
      onLaunch: (Map<String,dynamic> map) async{
        print('onLaunch: ');
        Navigator.of(context).pushNamed('/n');
      },
      onResume: (Map<String,dynamic> map) async{
        print('onResume: ');
        Navigator.of(context).pushNamed('/n');
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: <Widget>[
           RaisedButton(
             onPressed: (){},
             child: Text('Accept'),
           ),
           RaisedButton(
             onPressed: (){},
             child: Text('Decline'),
           ),
         ],
       ),
    );
  }
}