import 'dart:convert';

class Register{
  String name;
  String email;
  String password;

  Register({
    this.name,
    this.email,
    this.password,
  });

  Register.fromJson(Map<String, dynamic> parsedJson){
    name = parsedJson['name'];
    email = parsedJson['email'];
    password = parsedJson['password'];
  }

  Map<String, String> toMap(){
    return <String, String>{
      "name": name,
      "email": email,
      "password": password,
    };
  }
}