import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NewOrderScreen extends StatefulWidget {
  NewOrderScreen({Key key}) : super(key: key);

  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {},
              child: Text('Accept'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Decline'),
            ),
          ],
        ),
      ),
    );
  }
}
