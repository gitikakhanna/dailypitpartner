import 'package:dailypitpartner/src/screens/main_screen.dart';
import 'package:dailypitpartner/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_provider.dart';
import 'register_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Use these to save data in the firestore
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _messaging = FirebaseMessaging();
  String token;
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  initLogin() {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account != null) {
        // user logged
        print('Account ID' + account.id);
      } else {
        // user NOT logged
      }
    });
    //  _googleSignIn.signInSilently().whenComplete(() => {});
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initLogin();
    _messaging.getToken().then((t) {
      print(t);
      token = t;
    });

    // _messaging.configure(onMessage: (Map<String, dynamic> map) async {
    //   print('onMessage : ${map['data']['subCategoryId']}');
    //   print('onMessage : ${map['data']['userId']}');
    //   print('onMessage : ${map['data']['price']}');
    //   print('onMessage : ${map['data']['orderId']}');
    //   Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    // }, onLaunch: (Map<String, dynamic> map) async {
    //   print('onLaunch : ${map['data']['subCategoryId']}');
    //   print('onLaunch : ${map['data']['userId']}');
    //   print('onLaunch : ${map['data']['price']}');
    //   print('onLaunch : ${map['data']['orderId']}');
    //   Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    // }, onResume: (Map<String, dynamic> map) async {
    //   print('onResume : ${map['data']['subCategoryId']}');
    //   print('onResume : ${map['data']['userId']}');
    //   print('onResume : ${map['data']['price']}');
    //   print('onResume : ${map['data']['orderId']}');
    //   Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    // });

    // FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    //   if (user != null) {
    //     Navigator.pushNamed(context, '/d');
    //   }
    // });
  }

  Widget build(context) {
    //for scoped instance of bloc
    final bloc = LoginProvider.of(context);
    //this line reaches the nearest provider of this context and return the bloc
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(40.0),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 10,
                height: MediaQuery.of(context).size.height / 10,
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(8.0),
                child: Text(
                  'Dailypit Partner',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              emailField(bloc),
              SizedBox(
                height: 8.0,
              ),
              passwordField(bloc),
              Container(
                margin: EdgeInsets.only(top: 32.0),
              ),
              submitButton(bloc),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(8.0),
                child: Text(
                  'Want to provide services ? Join Us',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(child: registerButton(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailField(LoginBloc bloc) {
    // Stream Builder widget has two named parameters
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        //it is called everytime the stream comes with an event and changes
        //snapshot maintains info that came across the stream....AyncSnapshot class
        return TextField(
          onChanged: (newValue) {
            bloc.changeEmail(newValue);
          },
          //or onChanged: bloc.changeEmail;
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'you@example.com',
            labelText: 'Email Address',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'enter password',
            errorText: snapshot.error,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget submitButton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.submit,
        builder: (context, snapshot) {
          return RaisedButton(
            onPressed: snapshot.hasData
                ? () {
                    print('Test');
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          content: CupertinoActivityIndicator(),
                        );
                      },
                    );
                    bloc.login().then((FirebaseUser user) {
                      print('${user.email}');
                      if (user != null) {
                        Constants.prefs.setBool(Constants.pref_logged_in, true);
                        Constants.prefs
                            .setString(Constants.firebase_user_id, user.uid);
                        Firestore.instance
                            .collection('freelancer')
                            .where('emailid', isEqualTo: user.email)
                            .getDocuments()
                            .then((QuerySnapshot sn) {
                          print('Document Id ${sn.documents.first.documentID}');

                          _messaging.getToken().then((token) {
                            Firestore.instance
                                .document(
                                    'freelancer/${sn.documents.first.documentID}')
                                .updateData({
                              'freelancerid': user.uid,
                              'token': token,
                            });
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return MainScreen();
                              },
                            ));
                          });
                        });
                      } else {
                        Navigator.pop(context);
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Error'),
                              content:
                                  Text('Username or password is incorrect'),
                              actions: <Widget>[
                                CupertinoButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }).catchError((e) {
                      print('Error is $e');
                      Navigator.pop(context);
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('Error'),
                            content: Text('Username or password is incorrect'),
                            actions: <Widget>[
                              CupertinoButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            color: Colors.blue,
            textColor: Colors.white,
          );
        });
  }

  Widget registerButton(context) {
    return RaisedButton(
      onPressed: () {
        //navigate to register screen
        Navigator.pushNamed(context, '/r');
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  Future navigateToRegister(BuildContext context) async {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => RegisterScreen()));
  }
}
