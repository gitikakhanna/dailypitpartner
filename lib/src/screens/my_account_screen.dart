import 'package:dailypitpartner/src/blocs/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overlay_support/overlay_support.dart';

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({Key key}) : super(key: key);

  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String newPassword;
  String reenteredPassword;
  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
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
                  if (userSnapshot.data.documents.length == 0) {
                    return ListTile(
                      title: Text('Please Login to get full experience'),
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
                    subtitle: Text(
                      '${userSnapshot.data.documents.first.data['phoneno']}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        print("Go to My Profile editable");
                      },
                    ),
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
          Container(
            margin: EdgeInsets.all(8.0),
            child: CupertinoButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Change Password'),
                      content: Column(
                        children: <Widget>[
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                newPassword = value;
                              });
                            },
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              hintText: 'XXXX',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                reenteredPassword = value;
                              });
                            },
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Re Enter Password',
                              hintText: 'XXXX',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            print('$reenteredPassword');
                            print('$newPassword');
                            if (reenteredPassword.length != 0 &&
                                reenteredPassword == newPassword) {
                              bool result =
                                  await bloc.reAuthenticate(reenteredPassword);
                              if (result) {
                                toast('Password Updated Successfully !!');
                                FirebaseAuth.instance.signOut();
                                Navigator.popAndPushNamed(context, '/l');
                              } else {
                                toast('Oops Something is Wrong');
                              }
                            } else {
                              toast('Entered Password is not same');
                            }
                          },
                          child: Text('Change'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                      contentPadding: EdgeInsets.all(8.0),
                    );
                  },
                );
              },
              color: Colors.blue,
              child: Text('Change Password'),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            child: CupertinoButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, '/l');
              },
              color: Colors.blue,
              child: Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }

  reAuthenticate() async {
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'shubham77seven@gmail.com',
      password: 'DcOaVhyI',
    );
    user.updatePassword('dailypit12345').then((_) {
      print('Updated');
    });
  }
}
