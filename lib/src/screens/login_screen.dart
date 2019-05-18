import 'package:flutter/material.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_provider.dart';
import 'register_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Use these to save data in the firestore
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _messaging = FirebaseMessaging();
  String token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _messaging.getToken().then((t) {
      print(t);
      token = t;
    });

    _messaging.configure(onMessage: (Map<String, dynamic> map) async {
      print('onMessage : ${map['data']['subCategoryId']}');
      print('onMessage : ${map['data']['userId']}');
      print('onMessage : ${map['data']['price']}');
      print('onMessage : ${map['data']['orderId']}');
      Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    }, onLaunch: (Map<String, dynamic> map) async {
      print('onLaunch : ${map['data']['subCategoryId']}');
      print('onLaunch : ${map['data']['userId']}');
      print('onLaunch : ${map['data']['price']}');
      print('onLaunch : ${map['data']['orderId']}');
      Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    }, onResume: (Map<String, dynamic> map) async {
      print('onResume : ${map['data']['subCategoryId']}');
      print('onResume : ${map['data']['userId']}');
      print('onResume : ${map['data']['price']}');
      print('onResume : ${map['data']['orderId']}');
      Navigator.pushNamed(context, '/n${map['data']['orderId']}');
    });

    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null) {
        Navigator.pushNamed(context, '/d');
      }
    });
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
              emailField(bloc),
              passwordField(bloc),
              Container(
                margin: EdgeInsets.only(top: 20.0),
              ),
              Row(
                children: [
                  submitButton(bloc),
                  SizedBox(
                    width: 16.0,
                  ),
                  registerButton(context),
                ],
              ),
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
                    bloc.login().then((FirebaseUser user) {
                      print('${user.email}');

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
                          Navigator.popAndPushNamed(context, '/d');
                        });
                      });
                    }).catchError((e) {
                      print('Error is $e');
                    });
                  }
                : null,
            child: Text('Login'),
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
      child: Text('Register'),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  Future navigateToRegister(BuildContext context) async {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => RegisterScreen()));
  }
}
