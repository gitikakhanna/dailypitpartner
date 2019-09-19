import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../blocs/register_provider.dart';
import '../blocs/register_bloc.dart';

class RegisterLayoutScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = RegisterProvider.of(context);
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      //backgroundColor: Colors.blue[400],
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.all(40.0),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                nameField(bloc),
                SizedBox(
                  height: 8.0,
                ),
                emailField(bloc),
                SizedBox(
                  height: 8.0,
                ),
                phoneField(bloc),
                SizedBox(
                  height: 8.0,
                ),
                addressField(bloc),
                Container(
                  margin: EdgeInsets.only(top: 25.0),
                ),
                submitButton(bloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameField(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.name,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onChanged: bloc.changeName,
          decoration: InputDecoration(
            hintText: 'Full Name',
            labelText: 'Name',
            errorText: snapshot.error,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget emailField(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          decoration: InputDecoration(
            hintText: 'you@example.com',
            labelText: 'Email address',
            errorText: snapshot.error,
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }

  Widget phoneField(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.phoneno,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          keyboardType: TextInputType.phone,
          onChanged: bloc.changePhone,
          decoration: InputDecoration(
            hintText: 'Contact Number',
            labelText: 'Contact Number',
            errorText: snapshot.error,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget addressField(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.address,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          keyboardType: TextInputType.multiline,
          onChanged: bloc.changeAddress,
          decoration: InputDecoration(
            hintText: 'Address',
            labelText: 'Complete Address',
            errorText: snapshot.error,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget submitButton(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.submit,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
          onPressed: snapshot.hasData
              ? () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text('Register your data ?'),
                        actions: <Widget>[
                          CupertinoButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoButton(
                            child: Text('Confirm'),
                            onPressed: () {
                              bloc.registerDataValue();
                              Navigator.pop(context);
                              Navigator.pop(context);
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        title: Text('Thank You'),
                                        content: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              'We have recieved your request . We will mail you the login password'),
                                        ),
                                        actions: <Widget>[
                                          CupertinoButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ));
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
          color: Colors.blue,
          textColor: Colors.white,
        );
      },
    );
  }
}
