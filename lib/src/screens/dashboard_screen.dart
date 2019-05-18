import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key key}) : super(key: key);

  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  Color statusColor;
  String statusText;

  Map<String, Color> statusColors = {
    'online': Colors.green[300],
    'offline': Colors.red[300],
    'unavailable': Colors.grey,
    'assigned': Colors.yellow[300],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    statusColor = statusColors['unavailable'];
    statusText = 'Unavailable';
  }

  showStatusDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Status'),
            titlePadding: EdgeInsets.all(16.0),
            content: Wrap(
              //direction: Axis.vertical,
              children: <Widget>[
                ListTile(
                  leading: Text('Online'),
                  onTap: () {
                    setState(() {
                      statusColor = statusColors['online'];
                      statusText = 'Online';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Text('Offline'),
                  onTap: () {
                    setState(() {
                      statusColor = statusColors['offline'];
                      statusText = 'Offline';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Text('Assigned'),
                  onTap: () {
                    setState(() {
                      statusColor = statusColors['assigned'];
                      statusText = 'Assigned';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            // Freelancer Detail
            Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  // Profile Image
                  Container(
                    margin: EdgeInsets.all(8.0),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[50],
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  // Freelancer Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //status color
                      Container(
                        margin: EdgeInsets.all(8.0),
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                      ),
                      Text(
                        '$statusText',
                      ),
                    ],
                  ),
                  //Freelancer Name
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, top: 4.0),
                    alignment: Alignment.center,
                    child: StreamBuilder(
                      stream: null,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  //Freelance Email Perhaps
                  Container(
                    alignment: Alignment.center,
                    child: StreamBuilder(
                      stream: null,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
            // Change Status
            Container(
              margin: EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.blue,
                child: ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Change Status',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  showStatusDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
