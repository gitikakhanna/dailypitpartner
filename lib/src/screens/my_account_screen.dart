import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({Key key}) : super(key: key);

  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (!snapshot.hasData) {
                return ListTile(
                  title: Container(
                    height: 50.0,
                    color: Colors.grey[200],
                  ),
                );
              }

              return StreamBuilder(
                stream: Firestore.instance
                    .collection('freelancer')
                    .where('freelancerid', isEqualTo: snapshot.data.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: Container(
                        height: 20.0,
                        color: Colors.grey[200],
                      ),
                    );
                  }
                  if(userSnapshot.data.documents.length == 0){
                    return ListTile(
                      title: Text(
                        'Please Login to get full experience'
                      ),
                    ); 
                  }

                  return ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(
                      '${userSnapshot.data.documents.first.data['name']}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      ),
                    subtitle: Text('${userSnapshot.data.documents.first.data['emailid']}'),
                    trailing: Text('${userSnapshot.data.documents.first.data['phoneno']}',
                      style: TextStyle(
                        fontSize: 18,
                      ),),
                  );
                },
              );
            },
          ),
          Divider(
            height: 8.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          ListTile(
            leading: Icon(Icons.error_outline),
            title: Text('About Dailypit'),
          ),
          Divider(
            height: 8.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          ListTile(
            leading: Icon(Icons.error_outline),
            title: Text('Our Mission'),
          ),
          Divider(
            height: 8.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          ListTile(
            leading: Icon(Icons.error_outline),
            title: Text('Terms and Conditions'),
          ),
          Divider(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
