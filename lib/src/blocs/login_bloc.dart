import 'dart:async';
import 'login_validator.dart';

class LoginBloc extends Object with LoginValidator{
  final _emailController = new StreamController<String>();
  final _passwordController = new StreamController<String>();

  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  dispose(){
    _emailController.close();
    _passwordController.close();
  }
}