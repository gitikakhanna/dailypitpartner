import 'dart:async';

class LoginValidator{
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if(email.contains('@'))
      {
        sink.add(email);
      }
      else{
        sink.addError('enter a valid email');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if(password.length>6){
        sink.add(password);
      }
      else{
        sink.addError('Password must be atleast 6 characters long');
      }
    }
  );
}

