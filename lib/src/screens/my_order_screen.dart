import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOrderScreen extends StatefulWidget {
  MyOrderScreen({Key key}) : super(key: key);

  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser> user) {
        //print(user.data.uid);
        if (!user.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder(
          stream: Firestore.instance
              .collection('orders')
              .where('assigneduser', isEqualTo: user.data.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  child: Text('You have not serviced yet'),
                ),
              );
            }
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Container(
                  child: Text('You have not serviced yet'),
                ),
              );
            }

            return ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                int id = int.parse(document['subcategoryId']);
                assert(id is int);

                return StreamBuilder(
                  stream: Firestore.instance
                      .collection('subcategories')
                      .where('id', isEqualTo: id)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> dataSnapshot) {
                    if (!dataSnapshot.hasData) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        child: ListTile(
                          title: Container(
                            color: Colors.grey[100],
                            height: 20,
                          ),
                          subtitle: Container(
                            color: Colors.grey[100],
                            height: 20,
                          ),
                        ),
                      );
                    }

                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      child: ListTile(
                        onTap: () {
                          //Navigator.pushNamed(
                            //  context, '/f${document.documentID}');
                        },
                        title:
                            Text('${dataSnapshot.data.documents[0]['name']}'),
                        subtitle: Text('${document['price']}'),
                        trailing: Text('${document['status']}'),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
