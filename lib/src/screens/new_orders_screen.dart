import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewOrderScreen extends StatefulWidget {
  NewOrderScreen({Key key, this.orderId}) : super(key: key);
  final String orderId;
  _NewOrderScreenState createState() => _NewOrderScreenState(this.orderId);
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final String orderId;
  _NewOrderScreenState(this.orderId);

  @override
  Widget build(BuildContext context) {
    print(orderId);
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.blueGrey[50],
        title: Text(
          'Request Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 28.0,
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    color: Colors.white),
                child: Text(
                  'Customer Detail',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
              UserDetailBuilder(orderId: orderId),
              SizedBox(
                height: 8.0,
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    color: Colors.white),
                child: Text(
                  'Service Detail',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
              OrderDetailBuilder(orderId: orderId),
              AcceptButton(orderId: orderId),
              DeclineButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailBuilder extends StatelessWidget {
  const OrderDetailBuilder({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0,bottom: 16.0,right: 16.0,left: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Colors.white,
      ),
      child: StreamBuilder(
        stream: Firestore.instance
            .document('orders/$orderId')
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
                .collection('subcategories')
                .where('id',
                    isEqualTo:
                        int.parse(snapshot.data['subcategoryId']))
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot> orderSnapshot) {
              if (!orderSnapshot.hasData) {
                return ListTile(
                  title: Text('Loading'),
                );
              }

              return ListTile(
                title: Text(
                  '${orderSnapshot.data.documents.first['name']}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                trailing: Text(
                  '${snapshot.data['price']}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserDetailBuilder extends StatelessWidget {
  const UserDetailBuilder({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0,bottom: 16.0,right: 16.0,left: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Colors.white,
      ),
      child: StreamBuilder(
          stream: Firestore.instance.document('orders/$orderId').snapshots(),
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
                  .where('userid', isEqualTo: snapshot.data['userId'])
                  .snapshots(),
              builder:
                  (context, AsyncSnapshot<QuerySnapshot> userDataSnapshot) {
                if (!userDataSnapshot.hasData) {
                  return ListTile(
                    title: Text('Loading'),
                  );
                }

                return ListTile(
                  title: Text(
                    '${userDataSnapshot.data.documents.first['name']}',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  trailing: Text(
                    '${userDataSnapshot.data.documents.first['address']}',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

class DeclineButton extends StatelessWidget {
  const DeclineButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        onPressed: () {},
        child: Text(
          'Decline',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class AcceptButton extends StatelessWidget {
  const AcceptButton({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context){
              return AlertDialog(
                title: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
          FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
            Firestore.instance.document('orders/$orderId').updateData({
              'status': 'accepted',
              'list': FieldValue.arrayUnion(<String>[user.uid])
            });
            Navigator.popAndPushNamed(context, '/d');
          });
        },
        child: Text(
          'Accept',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
