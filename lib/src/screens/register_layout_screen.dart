import 'package:flutter/material.dart';
import '../blocs/register_provider.dart';
import '../blocs/register_bloc.dart';

class RegisterLayoutScreen extends StatelessWidget{
  Widget build(BuildContext context) {
    
    final bloc = RegisterProvider.of(context);
    return Container(
      margin: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            child: Image(
              image: AssetImage("assets/logo.png"),
            ),
          ),
          nameField(bloc),
          emailField(bloc),
          phoneField(bloc),
          addressField(bloc),
          Container(
            margin: EdgeInsets.only(top: 25.0),
          ),
          submitButton(bloc),
        ],
      ),
    );
  }

  Widget nameField(RegisterBloc bloc){
    return StreamBuilder(
      stream: bloc.name,
      builder: (context, AsyncSnapshot<String> snapshot){
        return TextField(
          onChanged: bloc.changeName,
          decoration: InputDecoration(
            hintText: 'Full Name',
            labelText: 'Name',
            errorText: snapshot.error,
          ),
        );
      },
    );
    
  }

  Widget emailField(RegisterBloc bloc){
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, AsyncSnapshot<String> snapshot){
        return TextField(
          onChanged: bloc.changeEmail,
          decoration: InputDecoration(
            hintText: 'you@example.com',
            labelText: 'Email address',
            errorText: snapshot.error,
          ),
          keyboardType: TextInputType.emailAddress,
        );        
      },
    );

  }

  Widget phoneField(RegisterBloc bloc){
    return StreamBuilder(
      stream: bloc.phoneno,
      builder: (context, AsyncSnapshot<String> snapshot){
        return TextField(
          keyboardType: TextInputType.phone,
          onChanged: bloc.changePhone,
          decoration: InputDecoration(
            hintText: 'Contact Number',
            labelText: 'Contact Number',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget addressField(RegisterBloc bloc){
    return StreamBuilder(
      stream: bloc.address,
      builder: (context, AsyncSnapshot<String> snapshot){
        return TextField(
          keyboardType: TextInputType.multiline,
          onChanged: bloc.changeAddress,
          decoration: InputDecoration(
            hintText: 'Address',
            labelText: 'Complete Address',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget submitButton(RegisterBloc bloc){
    return StreamBuilder(
      stream: bloc.submit,
      builder: (context, AsyncSnapshot<bool> snapshot){
        return RaisedButton(
          onPressed: snapshot.hasData
          ?(){bloc.registerDataValue();}
          :null,
          child: Text('Register'),
          color: Colors.blue,
          textColor: Colors.white,
        );
      }, 
    );

  }
}


