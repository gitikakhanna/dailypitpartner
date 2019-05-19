import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DashBoardScreen(),
    DashBoardScreen(),
    DashBoardScreen(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text(
                'Home',
                style:
                    TextStyle(fontFamily: 'ProductSans', color: Colors.black),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text(
                'My Orders',
                style:
                    TextStyle(fontFamily: 'ProductSans', color: Colors.black),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                  color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text(
                'My Account',
                style:
                    TextStyle(fontFamily: 'ProductSans', color: Colors.black),
              )),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key key}) : super(key: key);

  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  Color statusColor;
  String statusText;
  Widget notifyWidget = NotifyWidget();
  Map<String, Color> statusColors = {
    'online': Colors.green[300],
    'offline': Colors.red[300],
    'unavailable': Colors.grey,
    'assigned': Colors.yellow[300],
  };
  final _messaging = FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      print(user.uid);
    });

    _messaging.configure(onMessage: (Map<String, dynamic> map) async {
      print('onMessage : ${map['data']['subCategoryId']}');
      print('onMessage : ${map['data']['userId']}');
      print('onMessage : ${map['data']['price']}');
      print('onMessage : ${map['data']['orderId']}');
      setState(() {
       notifyWidget = ServiceNotifyWidget(orderId : map['data']['orderId']);
      });
      //Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    }, onLaunch: (Map<String, dynamic> map) async {
      print('onLaunch : ${map['data']['subCategoryId']}');
      print('onLaunch : ${map['data']['userId']}');
      print('onLaunch : ${map['data']['price']}');
      print('onLaunch : ${map['data']['orderId']}');
      setState(() {
       notifyWidget = ServiceNotifyWidget(orderId : map['data']['orderId']);
      });
      //Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    }, onResume: (Map<String, dynamic> map) async {
      print('onResume : ${map['data']['subCategoryId']}');
      print('onResume : ${map['data']['userId']}');
      print('onResume : ${map['data']['price']}');
      print('onResume : ${map['data']['orderId']}');
      setState(() {
       notifyWidget = ServiceNotifyWidget(orderId : map['data']['orderId']);
      });
      //Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    });


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
                      //notifyWidget = ServiceNotifyWidget();
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
    return SafeArea(
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
                SizedBox(
                  height: 10.0,
                ),
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
                Container(
                  //alignment: Alignment.center,
                  margin: EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.blue[300],
                    child: Text('Change Status'),
                    textColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      showStatusDialog();
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          //Show Request
          notifyWidget,
        ],
      ),
    );
  }
}

class NotifyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Text('Khali hai'),
    );
  }
}

class ServiceNotifyWidget extends StatelessWidget {

  final String orderId;


  const ServiceNotifyWidget({
    Key key,this.orderId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Shubham ne request bheji hai',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            trailing: FlatButton(
              onPressed: () {},
              color: Colors.white,
              child: Text(
                'Details',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FlatButton(
                  onPressed: () {
                    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
            Firestore.instance.document('orders/$orderId').updateData({
              'status': 'accepted',
              'list': FieldValue.arrayUnion(<String>[user.uid])
            });
            Navigator.popAndPushNamed(context, '/d');
          });
                  },
                  color: Colors.green[300],
                  child: Text(
                    'Accept',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.red[300],
                  child: Text(
                    'Decline',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
