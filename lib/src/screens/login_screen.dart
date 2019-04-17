import 'package:flutter/material.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget{
  Widget build(context){

    //for scoped instance of bloc
    final bloc = LoginProvider.of(context);
    //this line reaches the nearest provider of this context and return the bloc
    return Align(
      alignment: Alignment.center,
      child:Container(
        margin: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            emailField(bloc),
            passwordField(bloc),
            Container(
              margin: EdgeInsets.only(top:20.0),
            ),
            Row(
              children: [
                submitButton(),
                registerButton(context),
              ],
            ),
          ],
        ), 
      ),
    );
  }

  Widget emailField(LoginBloc bloc){
    // Stream Builder widget has two named parameters
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot){
        //it is called everytime the stream comes with an event and changes
        //snapshot maintains info that came across the stream....AyncSnapshot class
        return TextField(
          onChanged: (newValue){
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

  Widget passwordField(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot){
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

  Widget submitButton(){
    return RaisedButton(
      onPressed: (){

      },
      child: Text('Login'),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  Widget registerButton(context){
    return RaisedButton(
      onPressed: (){
        //navigate to register screen
        navigateToRegister(context);
      },
      child: Text('Register'),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  Future navigateToRegister(BuildContext context) async{
    Navigator.push(context, new MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

}