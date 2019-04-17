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
          passwordField(bloc),
          confirmField(),
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
            prefixIcon: Icon(Icons.mail_outline, size: 15.0,),
            errorText: snapshot.error,
          ),
          keyboardType: TextInputType.emailAddress,
        );        
      },
    );

  }
  
  Widget passwordField(RegisterBloc bloc){
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, AsyncSnapshot<String> snapshot){
        return TextField(
          obscureText: true,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            hintText: 'Password must contain atleast 6 characters',
            labelText: 'Password',
            errorText: snapshot.error,
            prefixIcon: Icon(Icons.vpn_key, size: 15.0,),
          ),
        ); 
      },
    );
  }

  Widget confirmField(){
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        labelText: 'Confirm Password',
      ),
    );
  }

  Widget submitButton(RegisterBloc bloc){
    return StreamBuilder(
      stream: bloc.submit,
      builder: (context, AsyncSnapshot<bool> snapshot){
        return RaisedButton(
          onPressed: ()
          {
            snapshot.hasData ? (){
              bloc.registerDataValue();
            } : null;
          },
          child: Text('Register'),
          color: Colors.blue,
          textColor: Colors.white,
        );
      },
    );

  }
}