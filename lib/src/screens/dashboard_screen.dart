import 'package:dailypitpartner/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key key}) : super(key: key);

  _DashBoardScreenState createState() => _DashBoardScreenState();
}

Map<String, Color> statusColors = {
  'online': Colors.green[300],
  'offline': Colors.red[300],
  'unavailable': Colors.grey,
  'assigned': Colors.yellow[300],
};

class _DashBoardScreenState extends State<DashBoardScreen> {
  Color statusColor;
  String statusText;
  Widget notifyWidget = NotifyWidget();
  String userId;
  final _messaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = Constants.prefs.getString(Constants.firebase_user_id);
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user == null) {
        Navigator.pushNamed(context, '/l');
      } else {
        setState(() {
          userId = user.uid;
        });
      }
    });

    _messaging.getToken().then((token) {
      print(token);
    });

    _messaging.configure(onMessage: (Map<String, dynamic> map) async {
      setState(() {
        if (map['data']['id'] == '1') {
          notifyWidget = ServiceNotifyWidget(
              orderId: map['data']['orderId'], notifyParent: refresh);
        } else if (map['data']['id'] == '2') {
          notifyWidget = NotifyWidget();
          statusText = 'assigned';
          statusColor = statusColors['assigned'];
          Navigator.pushNamed(context, '/c${map['data']['orderId']}');
        }
      });
    }, onLaunch: (Map<String, dynamic> map) async {
      setState(() {
        if (map['data']['id'] == '1') {
          notifyWidget = ServiceNotifyWidget(
              orderId: map['data']['orderId'], notifyParent: refresh);
        } else if (map['data']['id'] == '2') {
          notifyWidget = NotifyWidget();
          statusText = 'assigned';
          statusColor = statusColors['assigned'];
          Navigator.pushNamed(context, '/c${map['data']['orderId']}');
        }
      });
    }, onResume: (Map<String, dynamic> map) async {
      setState(() {
        if (map['data']['id'] == '1') {
          notifyWidget = ServiceNotifyWidget(
              orderId: map['data']['orderId'], notifyParent: refresh);
        } else if (map['data']['id'] == '2') {
          notifyWidget = NotifyWidget();
          statusText = 'assigned';
          statusColor = statusColors['assigned'];
          Navigator.pushNamed(context, '/c${map['data']['orderId']}');
        }
      });
    });

    statusColor = statusColors['unavailable'];
    statusText = 'Unavailable';
  }

  showStatusDialog(String docId) {
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
                    Firestore.instance
                        .document('freelancer/$docId')
                        .updateData({'active': 'online'});

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
                    Firestore.instance
                        .document('freelancer/$docId')
                        .updateData({'active': 'offline'});

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
                    Firestore.instance
                        .document('freelancer/$docId')
                        .updateData({'active': 'assigned'});

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

  refresh(int temp) {
    setState(() {
      if (temp == 1) // Decline Button
        notifyWidget = NotifyWidget();
      else if (temp == 0) // Accept Button
        notifyWidget = AcceptNotifyWidget();
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
          userId == '' || userId == null
              ? Container()
              : new FreelancerDetailWidget(
                  statusColor: statusColor,
                  statusText: statusText,
                  userId: userId,
                ),
          Container(
            //alignment: Alignment.center,
            margin: EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.blue,
              child: Text('Change Status'),
              textColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                Firestore.instance
                    .collection('freelancer')
                    .where('freelancerid', isEqualTo: userId)
                    .getDocuments()
                    .then((QuerySnapshot sn) {
                  showStatusDialog(sn.documents.first.documentID);
                });
              },
            ),
          ),
          //Show Request
          notifyWidget,
        ],
      ),
    );
  }
}

class FreelancerDetailWidget extends StatelessWidget {
  const FreelancerDetailWidget({
    Key key,
    @required this.statusColor,
    @required this.statusText,
    @required this.userId,
  }) : super(key: key);

  final Color statusColor;
  final String statusText;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          StreamBuilder(
              stream: Firestore.instance
                  .collection('freelancer')
                  .where('freelancerid', isEqualTo: userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Row(
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
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //status color
                    Container(
                      margin: EdgeInsets.all(8.0),
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        color: statusColors[
                            '${snapshot.data.documents.first.data['active']}'],
                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                      ),
                    ),
                    Text(
                      '${snapshot.data.documents.first.data['active']}',
                    ),
                  ],
                );
              }),
          //Freelancer Name
          Container(
            margin: EdgeInsets.only(bottom: 8.0, top: 4.0),
            alignment: Alignment.center,
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('freelancer')
                  .where('freelancerid', isEqualTo: userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return Container(
                  child: Text(
                    '${snapshot.data.documents.first.data['name']}',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                );
              },
            ),
          ),
          //Freelance Email Perhaps
          Container(
            alignment: Alignment.center,
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('freelancer')
                  .where('freelancerid', isEqualTo: userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return Container(
                  child: Text(
                    '${snapshot.data.documents.first.data['emailid']}',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 8.0,
          ),

          SizedBox(
            height: 10.0,
          ),
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
      margin: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No New Orders',
          style: TextStyle(fontSize: 20.0, color: Colors.grey[400]),
        ),
      ),
    );
  }
}

class AcceptNotifyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'We will notify you with the update',
          style: TextStyle(fontSize: 20.0, color: Colors.grey[400]),
        ),
      ),
    );
  }
}

class ServiceNotifyWidget extends StatefulWidget {
  final String orderId;
  final Function(int) notifyParent;
  const ServiceNotifyWidget(
      {Key key, this.orderId, @required this.notifyParent})
      : super(key: key);

  @override
  _ServiceNotifyWidgetState createState() => _ServiceNotifyWidgetState();
}

class _ServiceNotifyWidgetState extends State<ServiceNotifyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          ListTile(
            title: StreamBuilder(
                stream: Firestore.instance
                    .document('orders/${widget.orderId}')
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .where('userid',
                              isEqualTo: snapshot.data.data['userId'])
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> userDataSnapshot) {
                        if (!userDataSnapshot.hasData) {
                          return ListTile(
                            title: Text('Loading'),
                          );
                        }
                        return Text(
                          '${userDataSnapshot.data.documents.first['name']} has send a service request',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        );
                      });
                }),
            trailing: FlatButton(
              onPressed: () async {
                var result =
                    await Navigator.pushNamed(context, '/n${widget.orderId}');
                print('result is $result');
                widget.notifyParent(result);
              },
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
                    FirebaseAuth.instance
                        .currentUser()
                        .then((FirebaseUser user) {
                      Firestore.instance
                          .document('orders/${widget.orderId}')
                          .updateData({
                        //'status': 'accepted',
                        'list': FieldValue.arrayUnion(<String>[user.uid])
                      });
                      widget.notifyParent(0);
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
                  onPressed: () {
                    widget.notifyParent(1);
                  },
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
