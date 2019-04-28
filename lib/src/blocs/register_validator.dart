import 'dart:async';

class Validator{
  final validateName = StreamTransformer<String, String>.fromHandlers(handleData:(name, sink){
    if(name.length>0){
      sink.add(name);
    }
    else{
      sink.addError('Name is required');
    }
  });

  final validateEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink){
    if(email.contains('@'))
    {
      sink.add(email);
    }
    else{
      sink.addError('Please enter a valid email');
    }
  });

  final validatePhone = StreamTransformer<String, String>.fromHandlers(handleData: (phoneno, sink){
    if(phoneno.length != 10){
      sink.addError('Please enter a valid contact number');
    }
    else{
      sink.add(phoneno);
    }
  });

  final validateAddress = StreamTransformer<String, String>.fromHandlers(handleData: (address, sink){
    if(address.length != 0){
      sink.add(address);
    }
    else{
      sink.addError(address);
    }
  });

}