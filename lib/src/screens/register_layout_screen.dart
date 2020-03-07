import 'package:dailypitpartner/src/models/category_response.dart';
import 'package:dailypitpartner/src/resources/dailypit_api_provider.dart';
import 'package:dailypitpartner/src/resources/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../blocs/register_provider.dart';
import '../blocs/register_bloc.dart';

class RegisterLayoutScreen extends StatefulWidget {
  @override
  _RegisterLayoutScreenState createState() => _RegisterLayoutScreenState();
}

class _RegisterLayoutScreenState extends State<RegisterLayoutScreen> {
  Future<CategoryResponse> categoryResponse;

  List _categories;

  @override
  void initState() {
    super.initState();
    _categories = [];
    categoryResponse = fetchCategories();
  }

  Future<CategoryResponse> fetchCategories() async {
    CategoryResponse categoryResponse =
        await DailypitApiProvider().getCategories();
    return categoryResponse;
  }

  Widget build(BuildContext context) {
    final bloc = RegisterProvider.of(context);
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      //backgroundColor: Colors.blue[400],
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(40.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/logo.png"),
                    height: MediaQuery.of(context).size.height * 0.1,
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
                  SizedBox(
                    height: 8.0,
                  ),
                  FutureBuilder<CategoryResponse>(
                    future: categoryResponse,
                    builder:
                        (context, AsyncSnapshot<CategoryResponse> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('Starting');
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              'Loading',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) return Text('Error');
                          return Container(
                            child: MultiSelectFormField(
                              titleText: 'Services you provide',
                              dataSource:
                                  snapshot.data.categories.map((category) {
                                return {
                                  'display': category.categoryname,
                                  'value': category
                                };
                              }).toList(),
                              textField: 'display',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintText: 'Please choose one or more',
                              value: _categories,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _categories = value;
                                });

                                bloc.addCategories(CategoryResponse(
                                    categories: _categories.map((category) {
                                  return Categories(
                                    categoryid: category.categoryid,
                                    categoryname: category.categoryname,
                                  );
                                }).toList()));
                              },
                            ),
                          );
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25.0),
                  ),
                  submitButton(bloc),
                ],
              ),
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
